// $Id: BlinkToRadio.h,v 1.4 2006/12/12 18:22:52 vlahan Exp $

#ifndef DIRECTCOLLECTOR_H
#define DIRECTCOLLECTOR_H

enum {
  AM_BLINKTORADIO = 6,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct DirectCollectorMsg {
  nx_uint16_t nodeid;
  nx_uint16_t temperature;
} DirectCollectorMsg;

#endif
