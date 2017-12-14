#ifndef INDIRECTCOLLECTOR_H
#define INDIRECTCOLLECTOR_H

enum {
  AM_BLINKTORADIO = 6,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct IndirectCollectorMsg {
  nx_uint16_t nodeid;
  nx_uint16_t temperature;
} IndirectCollectorMsg;

#endif
