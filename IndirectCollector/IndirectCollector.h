#ifndef INDIRECTCOLLECTOR_H
#define INDIRECTCOLLECTOR_H

enum {
  AM_WSN_INDIRECT_COLLECTOR = 0xce,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct IndirectCollectorMsg {
  nx_uint16_t nodeid;
  nx_uint16_t temperature;
  nx_uint16_t humidity;
  nx_uint16_t illumination;
  nx_uint32_t timestamp;
  nx_uint16_t sequence_num;
} IndirectCollectorMsg;

typedef nx_struct nxSYS_Time_t {
    nx_uint32_t ticks_round;
    nx_uint16_t ticks;
    nx_uint32_t timestamp;
} nxSYS_Time_t;
#endif
