#include <stdio.h>
#include <stdlib.h>
#include "screen_test.h"
#include "common.h"
#include "./minuitwrp/minui.h"

void* screen_test(void *argc)
{
	//struct screen_msg *screen_msg = (struct screen_msg *)argc;
	int x =  gr_fb_width() >> 1;;
	int y = (gr_fb_height()*2)/3;
	int w =  gr_fb_width() >> 1;
	int h = gr_fb_height()/3;
	//printf("%s->x:%d y:%d w:%d h:%d\n",__func__,x,y,w,h);
	FillColor(255,0,0,255,x,y,w/3,h); 			//red
	FillColor(0,255,0,255,x+w/3,y,w/3,h);		//green
	FillColor(0,0,255,255,x+(2*w)/3,y,w/3,h);	//blue
	//screen_msg->result = 0;
	return argc;
}

