#ifndef RECEIVER_H
#define RECEIVER_H

enum {
  AM_WSN_DIRECT_COLLECTOR = 0xcf,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct CollectorMsg {
  nx_uint16_t nodeid;
  nx_uint16_t temperature;
  nx_uint16_t humidity;
  nx_uint16_t illumination;
  nx_uint32_t timestamp;
  nx_uint16_t sequence_num;
} CollectorMsg;


#endif
