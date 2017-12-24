#include "../RandomSender/Calculate.h"
#include "../WSN.h"
#include "printf.h"

module CalculatorC {
  uses interface Boot;
  uses interface Leds;
  uses interface Receive;
  uses interface SplitControl as AMControl;
}

implementation {
  uint32_t count = 1;
	uint32_t nums[DATA_ARRAY_LEN];
	uint32_t max = 0;
	uint32_t min = 0xffffffff;
	uint32_t sum = 0;
	uint32_t average = 0;
	uint32_t median = 0;
  uint32_t insert_len;
  uint32_t insert_data;
  uint32_t seq_set[SEQ_SET_LEN];
  bool insert_busy = FALSE;
  bool finish = FALSE;

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      uint16_t i = 0;
      for (i = 0; i < SEQ_SET_LEN; ++i) {
        seq_set[i] = 0;
      }
      call Leds.led2On();
      insert_busy = FALSE;
      insert_len = 1;
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
    uint16_t i = 0;
    //uint16_t j = 0;
    //uint32_t temp = 0;
    //printfflush();
    call Leds.led0On();
    /*for (i = 0; i < DATA_ARRAY_LEN; ++i) {
      for (j = 1; j < DATA_ARRAY_LEN - i; ++j) {
        if (nums[j] < nums[j - 1]) {
          temp = nums[j];
          nums[j] = nums[j - 1];
          nums[j - 1] = temp;
        }
      }
    }*/
    printf("insert_len: %lu\n", insert_len);
    atomic {
      for (i = 0; i < insert_len; ++i) {
        printf("%lu \n", nums[i]);
      }
    }

    average = sum / DATA_ARRAY_LEN;
    median = (nums[999] + nums[1000]) / 2;
    call Leds.led1On();
    call Leds.led0Off();
    printf("%lu %lu %lu %lu %lu\n", max, min, sum, average, median);
    printfflush();
  }

  task void insert() {
    atomic {
      uint32_t i, j;
      for (i = 0; i < insert_len - 1; ++i) {
        if (nums[i] < insert_data) {
          break;
        }
      }
      for (j = insert_len; j > i; --j) {
        nums[j] = nums[j - 1];
      }
      nums[i] = insert_data;
      ++insert_len;
      insert_busy = FALSE;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
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
          call Leds.led2Toggle();
          call Leds.led1Off();
          call Leds.led0Off();
          post cal_result();
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
            insert_busy = TRUE;
            insert_data = temp;
            index = count >> 5;
            bit = count & 31;
            seq_set[index] |= ((uint32_t)1 << bit);
            post insert();
          }
        }
        ++count;
      }
    }
    return msg;
  }
}
