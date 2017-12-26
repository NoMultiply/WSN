#include "../RandomSender/Calculate.h"
#include "../WSN.h"
#include "printf.h"

module CalculatorC {
  uses interface Boot;
  uses interface Leds;
  uses interface Receive as RandomDataReceive;
  uses interface Receive as CoReceive;
  uses interface Receive as CoReceive2;
  uses interface Packet;
  uses interface AMPacket;
  uses interface PacketAcknowledgements as ReqAck;
  uses interface SplitControl as AMControl;
  uses interface AMSend as ReqSend;
}

implementation {
  message_t askPkt;
  uint32_t count = 1;
	uint32_t nums[DATA_ARRAY_LEN];
	uint32_t max = 0;
	uint32_t min = 0xffffffff;
	uint32_t sum = 0;
	uint32_t average = 0;
	uint32_t median = 0;
  uint32_t insert_len;
  uint32_t insert_data;
  uint32_t b_start, b_end;
  uint32_t seq_set[SEQ_SET_LEN];
  bool insert_busy = FALSE;
  bool finish = FALSE;

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      uint16_t i = 0;
      for (i = 0; i < SEQ_SET_LEN; ++i) {
        seq_set[i] = 0;
      }
      insert_busy = FALSE;
      insert_len = 1;
      b_start = b_end = DATA_ARRAY_LEN + 1;
    }
    else {
      call AMControl.start();
    }
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.stopDone(error_t err) {
  }

  task void cal_result() {
    call Leds.led0On();
    printf("insert_len: %lu\n", insert_len);

    average = sum / DATA_ARRAY_LEN;
    median = (nums[(b_start + 999) % DATA_ARRAY_LEN] + nums[(b_start + 1000) % DATA_ARRAY_LEN]) / 2;
    call Leds.led1On();
    printf("%lu %lu %lu %lu %lu\n", max, min, sum, average, median);
    printfflush();
    call Leds.led0On();
    call Leds.led2On();
  }

  bool req_lost();
  task void sendRequest();

  task void b_insert() {
    uint32_t left, right, mid, front, back, i, pos;
    if (b_start == DATA_ARRAY_LEN + 1) {
      nums[0] = insert_data;
      b_start = b_end = 0;
    }
    else {
      if (insert_data >= nums[b_end]) {
        ++b_end;
        nums[b_end] = insert_data;
      }
      else if (insert_data <= nums[b_start] ){
        if (b_start == 0) {
          b_start = DATA_ARRAY_LEN - 1;
        }
        else {
          --b_start;
        }
        nums[b_start] = insert_data;
      }
      else {
        left = b_start;
        right = b_end;
        while (1) {
          if (left == right) {
            if (left >= b_start) {
              front = left - b_start;
            }
            else {
              front = left + DATA_ARRAY_LEN - b_start;
            }
            if (b_end >= left) {
              back = b_end - left;
            }
            else {
              back = b_end + DATA_ARRAY_LEN - left;
            }
            if (back <= front) {
              pos = left;
              if (insert_data >= nums[left]) {
                pos = left + 1;
                if (pos >= DATA_ARRAY_LEN) {
                  pos = 0;
                }
              }
              //printf("pos: %d, ", pos);
              i = b_end;
              while (1) {
                if (i == DATA_ARRAY_LEN - 1) {
                  nums[0] = nums[i];
                }
                else {
                  nums[i + 1] = nums[i];
                }
                if (i == pos) {
                  break;
                }
                if (i == 0) {
                  i = DATA_ARRAY_LEN - 1;
                }
                else {
                  --i;
                }
              }
              nums[pos] = insert_data;
              ++b_end;
            }
            else {
              pos = left;
              if (insert_data <= nums[left]) {
                if (pos == 0) {
                  pos = DATA_ARRAY_LEN - 1;
                }
                else {
                  pos = left - 1;
                }
              }
              i = b_start;
              while (1) {
                if (i == 0) {
                  nums[DATA_ARRAY_LEN - 1] = nums[0];
                }
                else {
                  nums[i - 1] = nums[i];
                }
                if (i == pos) {
                  break;
                }
                ++i;
                if (i >= DATA_ARRAY_LEN) {
                  i = 0;
                }
              }
              nums[pos] = insert_data;
              if (b_start == 0) {
                b_start = DATA_ARRAY_LEN - 1;
              }
              else {
                --b_start;
              }
            }
            break;
          }
          else {
            //printf("left: %d, right: %d\n", left, right);
            if (left > right) {
              mid = ((left + right + DATA_ARRAY_LEN) / 2) % DATA_ARRAY_LEN;
            }
            else {
              mid = (left + right) / 2;
            }
            if (insert_data == nums[mid]) {
              left = right = mid;
            }
            else if (insert_data > nums[mid]) {
              if (mid == right) {
                left = right;
              }
              else {
                left = mid + 1;
                if (left >= DATA_ARRAY_LEN) {
                  left = 0;
                }
              }
            }
            else {
              if (mid == left) {
                right = left;
              }
              else {
                if (mid == 0) {
                  right = DATA_ARRAY_LEN - 1;
                }
                else {
                  right = mid - 1;
                }
              }
            }
          }
        }
      }
    }
    ++insert_len;
    insert_busy = FALSE;
    if (finish) {
      if (!req_lost()) {
        printf("success\n");
        printfflush();
        post cal_result();
      }
    }
  }


  uint8_t req_index, req_bit;

  bool req_lost() {
    bool flag = FALSE;
    bool check_finish = FALSE;
    uint32_t seq;
    atomic {
      for (; req_index < SEQ_SET_LEN; ++req_index) {
        if (req_index == SEQ_SET_LEN - 1) {
          check_finish = TRUE;
        }
        seq = seq_set[req_index];
        for (; req_bit < 32; ++req_bit) {
          if (check_finish && req_bit == 16) {
            return FALSE;
          }
          if (seq & ((uint32_t)1 << req_bit)) {
            // Nothing TODO
          }
          else {
            flag = TRUE;
            break;
          }
        }
        if (flag) {
          break;
        }
        req_bit = 0;
      }
    }
    atomic if (flag) {
      AskMsg* ask_pkt = (AskMsg*)(call Packet.getPayload(&askPkt, sizeof(AskMsg)));
      if (ask_pkt == NULL) {
        // Nothing TODO
        return req_lost();
      }
      ask_pkt -> sequence = (((uint32_t)req_index << 5) | (uint32_t)req_bit) + 1;
      /*printf("req: %u, index: %lu, %lu\n", ask_pkt -> sequence, (uint32_t)req_index << 5, (uint32_t)req_bit);
      printfflush();*/
      post sendRequest();
      return TRUE;
    }
    else {
      return FALSE;
    }
  }

  event message_t* RandomDataReceive.receive(message_t* msg, void* payload, uint8_t len){
    if (!finish) {
      if (len == sizeof(data_packge)) {
        uint32_t temp;
        uint32_t index, bit;
        data_packge * pkt = (data_packge*)payload;
        if (count % 100 == 0) {
          call Leds.led1Toggle();
          printf("%lu\n", count);
          printfflush();
        }
        if (count > pkt->sequence_number) {
          finish = 1;
          call Leds.led1Off();
          call Leds.led0Off();
          req_index = 0;
          req_bit = 0;
          if (!req_lost()) {
            printf("cal_result\n");
            printfflush();
            post cal_result();
          }
          return msg;
        }
        if (count % DATA_ARRAY_LEN != pkt->sequence_number) {
          call Leds.led0Toggle();
          count = pkt->sequence_number;
        }
        temp = pkt->random_integer;
        if (temp > max) {
          max = temp;
        }
        if (temp < min) {
          min = temp;
        }
        sum += temp;
        if (!insert_busy) {
          atomic {
            //judge lose packet
            insert_busy = TRUE;
            insert_data = temp;
            index = (count - 1) >> 5;
            bit = (count - 1) & 31;
            seq_set[index] |= ((uint32_t)1 << bit);
            post b_insert();
          }
        }
        ++count;
      }
    }
    return msg;
  }

  task void sendRequest() {
    call Leds.led0Toggle();
    while ((call ReqAck.requestAck(&askPkt)) != SUCCESS) {
    }
    while ((call ReqSend.send(ID_CORECEIVER_1, &askPkt, sizeof(AskMsg)) == SUCCESS)) {
      while ((call ReqAck.requestAck(&askPkt)) != SUCCESS) {

      }
    }
  }

  task void sendRequest2() {
    call Leds.led0Toggle();
    while ((call ReqAck.requestAck(&askPkt)) != SUCCESS) {
    }
    while ((call ReqSend.send(ID_CORECEIVER_2, &askPkt, sizeof(AskMsg)) == SUCCESS)) {
      while ((call ReqAck.requestAck(&askPkt)) != SUCCESS) {

      }
    }
  }

  event void ReqSend.sendDone(message_t* msg, error_t err) {
    if (call ReqAck.wasAcked(&askPkt)) {
      // Nothing TODO
    }
    else {
      uint16_t addr = call AMPacket.destination(msg);
      if (addr == ID_CORECEIVER_1) {
        post sendRequest();
      }
      else if (addr == ID_CORECEIVER_2) {
        post sendRequest2();
      }
    }
  }

  event message_t* CoReceive2.receive(message_t* msg, void* payload, uint8_t len) {
    if (len == sizeof(data_packge)) {
      uint8_t index, bit;
      data_packge * pkt = (data_packge*)payload;
      call Leds.led2Toggle();
      insert_busy = TRUE;
      insert_data = pkt->random_integer;
      atomic if (insert_data == UINT_MAX) {
        printf("CoReceiver 2 lose packet %u\n", pkt->sequence_number);
        printfflush();
      }
      index = (pkt->sequence_number - 1) >> 5;
      bit = (pkt->sequence_number - 1) & 31;
      if (index == req_index && bit == req_bit) {
        seq_set[index] |= ((uint32_t)1 << bit);
        sum += insert_data;
        if (insert_data > max) {
          max = insert_data;
        }
        if (insert_data < min) {
          min = insert_data;
        }
        ++req_bit;
        if (req_bit >= 32) {
          ++req_index;
          req_bit = 0;
        }
        post b_insert();
      }
      else {
        post sendRequest();
        call Leds.led1Toggle();
      }
    }
    return msg;
  }

  event message_t* CoReceive.receive(message_t* msg, void* payload, uint8_t len) {
    if (len == sizeof(data_packge)) {
      uint8_t index, bit;
      data_packge * pkt = (data_packge*)payload;
      call Leds.led2Toggle();
      insert_busy = TRUE;
      insert_data = pkt->random_integer;
      atomic if (insert_data == UINT_MAX) {
        post sendRequest2();
        printf("CoReceiver 1 lose packet %u\n", pkt->sequence_number);
        printfflush();
        return msg;
      }
      index = (pkt->sequence_number - 1) >> 5;
      bit = (pkt->sequence_number - 1) & 31;
      if (index == req_index && bit == req_bit) {
        seq_set[index] |= ((uint32_t)1 << bit);
        sum += insert_data;
        if (insert_data > max) {
          max = insert_data;
        }
        if (insert_data < min) {
          min = insert_data;
        }
        ++req_bit;
        if (req_bit >= 32) {
          ++req_index;
          req_bit = 0;
        }
        post b_insert();
      }
      else {
        post sendRequest();
        call Leds.led1Toggle();
      }
    }
    return msg;
  }
}
