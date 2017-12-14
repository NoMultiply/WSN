#ifndef DIRECTCOLLECTOR_H
#define DIRECTCOLLECTOR_H

enum {
  AM_WSN_DIRECT_COLLECTOR = 0xcf,
  AM_WSN_INDIRECT_COLLECTOR = 0xce,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct DirectCollectorMsg {
  nx_uint16_t nodeid;
  nx_uint16_t temperature;
  nx_uint16_t humidity;
  nx_uint16_t illumination;
} DirectCollectorMsg;

#endif
