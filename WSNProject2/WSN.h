#ifndef WSN_H
#define WSN_H

enum {
  AM_CO = 0xeb,
  DATA_ARRAY_LEN = 2000,
  SEQ_SET_LEN = 63,
  UINT_MAX = 2147483647,
  AM_REQMSG_NODE1 = 34,
  AM_REQMSG_NODE2 = 35
};

typedef nx_struct AskMsg {
  nx_uint16_t sequence;
}AskMsg;

#endif
