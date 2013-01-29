#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/poll.h>
#include <sys/time.h>

#include <cutils/log.h>
#include <cutils/properties.h>

#include "libbluetooth/bluetooth/bluetooth.h"
#include "libbluetooth/bluetooth/hci.h"
#include "libbluetooth/bluetooth/hci_lib.h"

#include "common.h"

#ifndef HCI_DEV_ID
#define HCI_DEV_ID 0
#endif

#define HCID_START_DELAY_SEC   3
#define HCID_STOP_DELAY_USEC 500000

#define LOG(x...) printf(x)

#define MIN(x,y) (((x)<(y))?(x):(y))

#define BTHWCTL_DEV_NAME             "/dev/bthwctl"
#define BTHWCTL_IOC_MAGIC            0xf6
#define BTHWCTL_IOCTL_SET_POWER      _IOWR(BTHWCTL_IOC_MAGIC, 0, uint32_t)	

enum WIFI_CHIP_TYPE_LIST{
	BCM4329 = 0,
	RTL8188CU,
	RTL8188EU,
	BCM4330,
	RK901,
	RK903,
	MT6620,
	RT5370,
  MT5931
};

static int rfkill_id = -1;
static char *rfkill_state_path = NULL;
static int bluetooth_power_status = 0;
static int chip_type;

#define WIFI_CHIP_TYPE_PATH "/sys/class/rkwifi/chip"
int getChipType(void) {
	  int wififd;
	  char buf[64];
	  int chip_type = RTL8188EU;
	
	  wififd = open(WIFI_CHIP_TYPE_PATH, O_RDONLY);
	  if( wififd < 0 ){
	          printf("Can't open %s, errno = %d\n", WIFI_CHIP_TYPE_PATH, errno);
	          goto done;
	  }
	
	  memset(buf, 0, 64);
	  if( 0 == read(wififd, buf, 10) ){
	          printf("read failed\n");
	          close(wififd);
	          goto done;
	  }
	  close(wififd);
	
	  if(0 == strncmp(buf, "BCM4329", strlen("BCM4329")) ) {
	          chip_type = BCM4329;
	          printf("Read wifi chip type OK ! chip_type = BCM4329\n");
	  }
	  else if (0 == strncmp(buf, "RTL8188CU", strlen("RTL8188CU")) ) {
	          chip_type = RTL8188CU;
	          printf("Read wifi chip type OK ! chip_type = RTL8188CU\n");
	  }
	  else if (0 == strncmp(buf, "RTL8188EU", strlen("RTL8188EU")) ) {
	          chip_type = RTL8188EU;
	          printf("Read wifi chip type OK ! chip_type = RTL8188EU\n");
	  }
	  else if (0 == strncmp(buf, "BCM4330", strlen("BCM4330")) ) {
	          chip_type = BCM4330;
	          printf("Read wifi chip type OK ! chip_type = BCM4330\n");
	  }
	  else if (0 == strncmp(buf, "RK901", strlen("RK901")) ) {
	          chip_type = RK901;
	          printf("Read wifi chip type OK ! chip_type = RK901\n");
	  }
	  else if (0 == strncmp(buf, "RK903", strlen("RK903")) ) {
	          chip_type = RK903;
	          printf("Read wifi chip type OK ! chip_type = RK903\n");
	  }
	  else if (0 == strncmp(buf, "MT6620", strlen("MT6620")) ) {
	          chip_type = MT6620;
	          printf("Read wifi chip type OK ! chip_type = MT6620\n");
	  }
	  else if (0 == strncmp(buf, "RT5370", strlen("RT5370")) ) {
	          chip_type = RT5370;
	          printf("Read wifi chip type OK ! chip_type = RT5370\n");
	  }
	  else if (0 == strncmp(buf, "MT5931", strlen("MT5931")) ) {
	          chip_type = MT5931;
	          printf("Read wifi chip type OK ! chip_type = MT5931\n");
	  }
	
done:
	  return chip_type;
}

static int init_rfkill() {
    char path[64];
    char buf[16];
    int fd;
    int sz;
    int id;
    for (id = 0; ; id++) {
        snprintf(path, sizeof(path), "/sys/class/rfkill/rfkill%d/type", id);
        fd = open(path, O_RDONLY);
        if (fd < 0) {
            LOGW("open(%s) failed: %s (%d)\n", path, strerror(errno), errno);
            return -1;
        }
        sz = read(fd, &buf, sizeof(buf));
        close(fd);
        if (sz >= 9 && memcmp(buf, "bluetooth", 9) == 0) {
            rfkill_id = id;
            break;
        }
    }

    asprintf(&rfkill_state_path, "/sys/class/rfkill/rfkill%d/state", rfkill_id);
    return 0;
}

static int broadcom_set_bluetooth_power(int on) {
    int sz;
    int fd = -1;
    int ret = -1;
    const char buffer = (on ? '1' : '0');

    if (rfkill_id == -1) {
        if (init_rfkill()) goto out;
    }

    fd = open(rfkill_state_path, O_WRONLY);
    if (fd < 0) {
        printf("open(%s) for write failed: %s (%d)\n", rfkill_state_path,
             strerror(errno), errno);
        goto out;
    }
    sz = write(fd, &buffer, 1);
    if (sz < 0) {
        printf("write(%s) failed: %s (%d)\n", rfkill_state_path, strerror(errno),
             errno);
        goto out;
    }
    ret = 0;

out:
    if (fd >= 0) close(fd);
    return ret;	
}

static int mtk_set_bluetooth_power(int on) {
    int sz;
    int fd = -1;
    int ret = -1;
    const uint32_t buf = (on ? 1 : 0);

    fd = open(BTHWCTL_DEV_NAME, O_RDWR);
    if (fd < 0) {
        LOGE("Open %s to set BT power fails: %s(%d)", BTHWCTL_DEV_NAME,
             strerror(errno), errno);
        goto out1;
    }
    
    ret = ioctl(fd, BTHWCTL_IOCTL_SET_POWER, &buf);
    if(ret < 0) {
        LOGE("Set BT power %d fails: %s(%d)\n", buf, 
             strerror(errno), errno);
        goto out1;
    }

    bluetooth_power_status = on ? 1 : 0;

out1:
    if (fd >= 0) close(fd);
    return ret;	
}

static int set_bluetooth_power(int on) {
	if(chip_type != MT5931) {
		return broadcom_set_bluetooth_power(on);
	} else {
		return mtk_set_bluetooth_power(on);
	}
}

/**
@ret:
  >=0 , socket created ok;
  <0, socket created fail;
*/
static inline int bt_test_create_sock() {
    int sock = 0;
	sock = socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);
    if (sock < 0) {
        printf("bluetooth_test Failed to create bluetooth hci socket: %s (%d)\n",
             strerror(errno), errno);
		return -1;
    }
    return sock;
}

static int start_hciattach() {
	int ret;
	if(chip_type != MT5931) {	
		ret = __system("/system/bin/brcm_patchram_plus --patchram bychip --baudrate 1500000 --enable_lpm --enable_hci /dev/ttyS0 &");
	} else {
		ret = __system("/system/bin/hciattach_mtk -n -t 10 -s 115200 /dev/ttyS0 mtk 1500000 noflow &");
	}	
	return ret;
}

static int bt_test_enable() {
    int ret = -1;
    int hci_sock = -1;
    int attempt;

    if (set_bluetooth_power(1) < 0) goto out;

    printf("Starting hciattach daemon\n");
    if (start_hciattach() != 0) {
        printf("Failed to start hciattach\n");
        set_bluetooth_power(0);
        goto out;
    }

    // Try for 10 seconds, this can only succeed once hciattach has sent the
    // firmware and then turned on hci device via HCIUARTSETPROTO ioctl
    printf("Waiting for HCI device present...\n");
    for (attempt = 50; attempt > 0;  attempt--) {
        printf("..%d..\n", attempt);
        hci_sock = bt_test_create_sock();
        if (hci_sock < 0) goto out;

        ret = ioctl(hci_sock, HCIDEVUP, HCI_DEV_ID);

        if (!ret) {
            break;
        } else if (errno == EALREADY) {
            printf("Bluetoothd already started, unexpectedly!\n");
            break;
        }

        close(hci_sock);
        usleep(200000);  // 200 ms retry delay
    }
    if (attempt == 0) {
        printf("%s: Timeout waiting for HCI device to come up, ret=%d\n",
            __FUNCTION__, ret);
        set_bluetooth_power(0);
        goto out;
    }

		printf("bt_enable success.\n");
    ret = 0;

out:
    if (hci_sock >= 0) close(hci_sock);
    return ret;
}

static int my_ba2str(const bdaddr_t *ba, char *str) {
    return sprintf(str, "%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X",
                ba->b[5], ba->b[4], ba->b[3], ba->b[2], ba->b[1], ba->b[0]);
}

int bt_test(void)
{
    int dev_id = 0;
	int sock = 0;
    int i = 0;
	int ret = 0;
	
	chip_type = getChipType();
	if(chip_type != BCM4329 &&
		 chip_type != BCM4330 &&
		 chip_type != RK903 &&
		 chip_type != MT6620 &&
		 chip_type != MT5931 ) {
		printf("hardware not support, skip bt test.\n");
		return 0;
	}	
	
	printf("bluetooth_test main function started\n");

	ret = bt_test_enable();
	if(ret < 0){
		printf("bluetooth_test main function fail to enable \n");
		goto fail;
		return 0;
	}

	dev_id = hci_get_route(NULL);
	
	if(dev_id < 0){
		printf("bluetooth_test main function fail to get dev id\n");
		goto fail;
		return 0;
	}
	
	printf("bluetooth_test main function hci_get_route dev_id=%d\n",dev_id);

    sock = hci_open_dev( dev_id );
	if(sock < 0){
		printf("bluetooth_test main function fail to open bluetooth sock\n");
		goto fail;
		return 0;
	}

	printf("bluetooth_test main function hci_open_dev ok\n");

	if(sock >= 0){
		close( sock );
	}

	/*ret = bt_test_disable();
	if(ret < 0){
		printf("bluetooth_test main function fail to disable\n");
		ui_print_xy_rgba(0,get_cur_print_y(),255,0,0,255,"bluetooth test error\n");
		return 0;
	}*/

	ui_print_xy_rgba(0,get_cur_print_y(),0,255,0,255,"BT    : [OK]\n");
	printf("bluetooth_test main function end\n");
	return 0;
	
fail:
	ui_print_xy_rgba(0,get_cur_print_y(),255,0,0,255,"BT    : [FAIL]\n");
	printf("bluetooth_test main function end\n");
	return 0;
}