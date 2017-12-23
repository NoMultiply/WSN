#include "../RandomSender/Calculate.h"
#include "printf.h"

module ReceiverC {
  uses interface Boot;
  uses interface Leds;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend as CoSend;
  uses interface Receive as CoreReceive;
  uses interface SplitControl as AMControl;
  uses interface Receive as RandomDataReceive;
}

implementation {
  message_t pkt;
  uint32_t randomData[DATA_ARRAY_LEN];
  uint32_t data_count = 0;
  uint32_t core_require = UINT_MAX;
  bool finish = 0;

  event void Boot.booted() {
    uint16_t i;
    for (i = 0; i < DATA_ARRAY_LEN; ++i) {
      randomData[i] = UINT_MAX;
    }
    core_require = UINT_MAX;
    data_count = 0;
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Leds.led2On();
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  task void send_to_core() {
    data_packge * replypkt = (data_packge *)(call Packet.getPayload(&pkt,sizeof(data_packge)));
    replypkt->sequence_number = core_require;
    replypkt->random_integer = randomData[core_require - 1];
    call Leds.led2Toggle();
    call CoSend.send(AM_BROADCAST_ADDR, &pkt,sizeof(data_packge));
  }

  event message_t* RandomDataReceive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(data_packge) && !finish) {
      data_packge *data_pkt = (data_packge *)payload;
      randomData[data_pkt->sequence_number - 1] = data_pkt->random_integer;
      if (data_pkt->sequence_number - data_count != 1) {
        call Leds.led0Toggle();
      }
      data_count = data_pkt->sequence_number;
      if (data_count % 100 == 0) {
        call Leds.led1Toggle();
      }
      if (data_count == 2000) {
        finish = 1;
      }
      if (core_require <= data_count) {
        post send_to_core();
      }
    }
    return msg;
  }

  event message_t* CoreReceive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(data_packge)) {
      data_packge *data_pkt = (data_packge *)payload;
      core_require = data_pkt->sequence_number;
      if (core_require < data_count) {
        post send_to_core();
      }
    }
    return msg;
  }

  event void CoSend.sendDone(message_t* msg, error_t err) {
    if (msg == &pkt) {
      core_require = UINT_MAX;
    }
  }
}
