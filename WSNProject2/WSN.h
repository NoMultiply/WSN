#ifndef WSN_H
#define WSN_H

enum {
  AM_CO = 0xeb,
  AM_MSG = 0,
  AM_SENDER = 0xdf,
  GROUP_ID = 19,
  ID_CORE = 58,
  ID_ZERO = 0,
  ID_CORECEIVER_1 = 59,
  ID_CORECEIVER_2 = 60,
  DATA_ARRAY_LEN = 2000,
  B_LEN = 1002,
  B_MID_LEN = 1001,
  SEQ_SET_LEN = 63,
  UINT_MAX = 2147483647,
  SEND_RESULT_INTERVAL = 10,
  //AM_REQMSG = 34,
  //AM_REQMSG_NODE2 = 35
};

typedef nx_struct AskMsg {
  nx_uint16_t sequence;
}AskMsg;

typedef nx_struct ResultMsg {
	nx_uint8_t group_id;
	nx_uint32_t max;
	nx_uint32_t min;
	nx_uint32_t sum;
	nx_uint32_t average;
	nx_uint32_t median;
} ResultMsg;

typedef nx_struct ack_msg_t {
	nx_uint8_t group_id;
}ack_msg_t;

#endif
