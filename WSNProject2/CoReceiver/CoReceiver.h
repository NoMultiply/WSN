#ifndef CORECEIVER_H
#define CORECEIVER_H

enum {
  DATA_ARRAY_LEN = 2000,
  UINT_MAX = 4294967295
};

typedef nx_struct DataMsg {
  nx_uint16_t sequence_number;
  nx_uint32_t random_integer;
}DataMsg;

typedef nx_struct AskMsg {
  nx_uint16_t sequence;
}AskMsg;

<<<<<<< HEAD
//TODO
=======
>>>>>>> fa07d5a7073faaaed4b403346c7b38a359d58e2c
/*
typedef nx_struct ReplyMsg {
  nx_uint32_t reply_data;
}ReplyMsg;
*/

<<<<<<< HEAD

=======
>>>>>>> fa07d5a7073faaaed4b403346c7b38a359d58e2c
#endif
