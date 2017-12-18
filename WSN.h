#ifndef DIRECTCOLLECTOR_H
#define DIRECTCOLLECTOR_H

enum {
  AM_WSN_DIRECT_COLLECTOR = 0xcf,
  AM_WSN_INDIRECT_COLLECTOR = 0xce,
  AM_DATAMSG = 0x1e,
  AM_CONTROLMSG = 0x4b,
  TIMER_PERIOD_MILLI = 1000,
  CONTROL_STOP = 1,
  CONTROL_START = 2
};

typedef nx_struct DataMsg {
  nx_uint16_t nodeid;
  nx_uint16_t temperature;
  nx_uint16_t humidity;
  nx_uint16_t illumination;
  nx_uint32_t timestamp;
  nx_uint16_t sequence_num;
} DataMsg;

typedef nx_struct ControlMsg {
  nx_uint8_t control_type;
  nx_uint16_t interval;
} ControlMsg;

typedef nx_struct nxSYS_Time_t {
    nx_uint32_t ticks_round;
    nx_uint16_t ticks;
    nx_uint32_t timestamp;
} nxSYS_Time_t;

#endif
