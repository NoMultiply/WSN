#include "../RandomSender/Calculate.h"
#include "printf.h"

module CalculatorC {
  uses interface Boot;
  uses interface Leds;
  uses interface Receive;
  uses interface SplitControl as AMControl;
}

implementation {
  uint16_t count = 1;
	uint32_t nums[2000];
	uint32_t max = 0;
	uint32_t min = 0xffffffff;
	uint32_t sum = 0;
	uint32_t average = 0;
	uint32_t median = 0;
  bool finish = FALSE;

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Leds.led2On();
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
    //uint16_t i = 0;
    //uint16_t j = 0;
    //uint32_t temp = 0;
    //printfflush();
    call Leds.led0On();
    /*for (i = 0; i < 2000; ++i) {
      for (j = 1; j < 2000 - i; ++j) {
        if (nums[j] < nums[j - 1]) {
          temp = nums[j];
          nums[j] = nums[j - 1];
          nums[j - 1] = temp;
        }
      }
    }*/
    average = sum / 2000;
    median = (nums[999] + nums[1000]) / 2;
    call Leds.led1On();
    call Leds.led0Off();
    printf("%lu %lu %lu %lu %lu\n", max, min, sum, average, median);
    printfflush();
  }

  uint32_t insert_len;
  uint32_t insert_data;

  task void insert() {
    atomic {
      uint32_t i, j;
      for (i = 0; i < insert_len - 1; ++i) {
        if (nums[i] > insert_data) {
          break;
        }
      }
      for (j = insert_len; j > i; --j) {
        nums[j] = nums[j - 1];
      }
      nums[i] = insert_data;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (!finish) {
      if (len == sizeof(data_packge)) {
        uint32_t temp;
        data_packge * pkt = (data_packge*)payload;
        if (count % 100 == 0) {
          call Leds.led1Toggle();
          printf("%u\n", count);
          printfflush();
        }
        if (count != pkt->sequence_number) {
          if (count % 100 == 0)
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
        atomic insert_len = count;
        atomic insert_data = temp;
        post insert();
        if (count == 2000) {
          count = 1;
          finish = 1;
          call Leds.led2Toggle();
          call Leds.led1Off();
          call Leds.led0Off();
          post cal_result();
        }
        ++count;
      }
    }
    return msg;
  }
}
