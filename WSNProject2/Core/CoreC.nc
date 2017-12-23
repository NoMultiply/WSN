#include "../RandomSender/Calculate.h"
#include "printf.h"

module CoreC {
  uses interface Boot;
  uses interface Leds;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend as CoSend;
  uses interface Receive as CoreReceive;
  uses interface SplitControl as AMControl;
  uses interface PacketAcknowledgements as CoAck;
}

implementation {
  message_t pkt;
  uint32_t randomData[DATA_ARRAY_LEN];
  uint32_t data_count = 1;

  task void require_data();

  event void Boot.booted() {
    uint16_t i;
    for (i = 0; i < DATA_ARRAY_LEN; ++i) {
      randomData[i] = UINT_MAX;
    }
    data_count = 1;
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Leds.led2On();
      post require_data();
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  task void require_data() {
    data_packge * require_pkt = (data_packge *)(call Packet.getPayload(&pkt,sizeof(data_packge)));
    require_pkt->sequence_number = data_count;
    call Leds.led0Toggle();
    call CoAck.requestAck(&pkt);
    call CoSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(data_packge));
  }

  task void cal_result() {
    uint32_t i;
    call Leds.led0On();
    call Leds.led1On();
    call Leds.led2On();
    for (i = 0; i < DATA_ARRAY_LEN; ++i) {
      printf("%lu ", randomData[i]);
    }
    printfflush();
    call Leds.led0Off();
    call Leds.led1Off();
    call Leds.led2Off();
  }

  event message_t* CoreReceive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(data_packge)) {
      data_packge *data_pkt = (data_packge *)payload;
      call Leds.led1Toggle();
      if (data_count == data_pkt->sequence_number) {
        call Leds.led2Toggle();
        randomData[data_count - 1] = data_pkt->random_integer;
        ++data_count;
      }
      if (data_count > DATA_ARRAY_LEN) {
        post cal_result();
      }
      else {
        post require_data();
      }
    }
    return msg;
  }

  event void CoSend.sendDone(message_t* msg, error_t err) {
    if (msg == &pkt) {
      if(call CoAck.wasAcked(msg)){
        // Nothing TODO
      }
      else {
        post require_data();
      }
    }
  }
}
