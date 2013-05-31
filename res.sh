#!/bin/bash
echo res.sh $1 $2 $3
TARGET_PRODUCT=$1
PRODUCT_OUT=$2
TARGET_BOARD_PLATFORM=$3
TARGET_COMMON=common
if [ $TARGET_BOARD_PLATFORM == "rk30xx" -o $TARGET_BOARD_PLATFORM = "rk30xxb" ]; then
    MODULE="modules_smp"
elif [ $TARGET_BOARD_PLATFORM == "rk2928" ]; then
    MODULE="modules"
fi
echo MODULE $MODULE
if [ ! -e "device/rockchip/$TARGET_COMMON/app" ] ; then
    if [ -e "device/rockchip/$TARGET_PRODUCT/8188eu.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/8188eu.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/8188eu.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/8188eu.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/8192cu.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/8192cu.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/8192cu.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/8192cu.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/rda5890.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/rda5890.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/rda5890.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/rda5890.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/rt5370sta.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/rt5370sta.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/rt5370sta.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/rt5370sta.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/mt7601sta.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/mt7601sta.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/mtprealloc7601Usta.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/mtprealloc7601Usta.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/8723au.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/8723au.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/8723as.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/8723as.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/rkwifi.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/rkwifi.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/rkwifi.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/rkwifi.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/wlan.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/wlan.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/wlan.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/wlan.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ ! -e "$PRODUCT_OUT/recovery/root/system/etc/" ] ; then
    mkdir $PRODUCT_OUT/recovery/root/system/etc/
    fi

    if [ ! -e "$PRODUCT_OUT/recovery/root/system/etc/firmware" ] ; then
    mkdir $PRODUCT_OUT/recovery/root/system/etc/firmware/
    fi

    if [ ! -e "$PRODUCT_OUT/recovery/root/etc/firmware" ] ; then
    mkdir $PRODUCT_OUT/recovery/root/etc/firmware/
    fi

    if [ -e "external/wlan_loader/firmware/" ] ; then
    cp external/wlan_loader/firmware/ $PRODUCT_OUT/recovery/root/system/etc/ -a
    fi 

    if [ -e "device/rockchip/$TARGET_PRODUCT/proprietary/libipp/rk29-ipp.ko" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/proprietary/libipp/rk29-ipp.ko $PRODUCT_OUT/recovery/root/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/proprietary/libipp/rk29-ipp.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/proprietary/libipp/rk29-ipp.ko.3.0.36+ $PRODUCT_OUT/recovery/root/
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/bluetooth/pcba/rk903/system/bin" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/bluetooth/pcba/rk903/system/bin/ $PRODUCT_OUT/recovery/root/system/ -a
    fi

    if [ -e "device/rockchip/$TARGET_PRODUCT/bluetooth/pcba/rk903/system/etc" ] ; then
    cp device/rockchip/$TARGET_PRODUCT/bluetooth/pcba/rk903/system/etc/ $PRODUCT_OUT/recovery/root/system/ -a
    fi

else
    ##################################### WIFI MODULES #####################################################
    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8188eu.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8188eu.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8188eu.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8188eu.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8192cu.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8192cu.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8192cu.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8192cu.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rda5890.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rda5890.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rda5890.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rda5890.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rt5370sta.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rt5370sta.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rt5370sta.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rt5370sta.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/mt7601sta.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/mt7601sta.ko $PRODUCT_OUT/recovery/root/res/
    fi

		if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/mtprealloc7601Usta.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/mtprealloc7601Usta.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8723au.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8723au.ko $PRODUCT_OUT/recovery/root/res/
	  fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8723as.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/8723as.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rkwifi.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rkwifi.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rkwifi.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/rkwifi.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/wlan.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/wlan.ko $PRODUCT_OUT/recovery/root/res/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/wlan.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_COMMON/wifi/lib/$MODULE/wlan.ko.3.0.36+ $PRODUCT_OUT/recovery/root/res/
    fi
    #########################################################################################################
    if [ ! -e "$PRODUCT_OUT/recovery/root/system/etc/" ] ; then
    mkdir $PRODUCT_OUT/recovery/root/system/etc/
    fi

    if [ ! -e "$PRODUCT_OUT/recovery/root/system/etc/firmware" ] ; then
    mkdir $PRODUCT_OUT/recovery/root/system/etc/firmware/
    fi

    if [ ! -e "$PRODUCT_OUT/recovery/root/etc/firmware" ] ; then
    mkdir $PRODUCT_OUT/recovery/root/etc/firmware/
    fi

    if [ -e "external/wlan_loader/firmware/" ] ; then
    cp external/wlan_loader/firmware/ $PRODUCT_OUT/recovery/root/system/etc/ -a
    fi 

    if [ -e "device/rockchip/$TARGET_COMMON/ipp/lib/rk29-ipp.ko" ] ; then
    cp device/rockchip/$TARGET_COMMON/ipp/lib/rk29-ipp.ko $PRODUCT_OUT/recovery/root/
    fi

    if [ -e "device/rockchip/$TARGET_COMMON/ipp/lib/rk29-ipp.ko.3.0.36+" ] ; then
    cp device/rockchip/$TARGET_COMMON/ipp/lib/rk29-ipp.ko.3.0.36+ $PRODUCT_OUT/recovery/root/
    fi

    if [ -e "device/rockchip/common/bluetooth/pcba/system/bin" ] ; then
    cp device/rockchip/common/bluetooth/pcba/system/bin/ $PRODUCT_OUT/recovery/root/system/ -a
    fi

    if [ -e "device/rockchip/common/bluetooth/pcba/system/etc" ] ; then
    cp device/rockchip/common/bluetooth/pcba/system/etc/ $PRODUCT_OUT/recovery/root/system/ -a
    fi
fi
