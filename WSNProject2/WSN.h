#ifndef WSN_H
#define WSN_H

enum {
  AM_CO = 0xeb,
  ID_CORE = 58,
  ID_CORECEIVER_1 = 59,
  ID_CORECEIVER_2 = 60,
  DATA_ARRAY_LEN = 2000,
  SEQ_SET_LEN = 63,
  UINT_MAX = 2147483647,
  //AM_REQMSG = 34,
  //AM_REQMSG_NODE2 = 35
};

typedef nx_struct AskMsg {
  nx_uint16_t sequence;
}AskMsg;

#endif
