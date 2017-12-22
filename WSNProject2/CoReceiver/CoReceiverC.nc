#include <Timer.h>
#include "CoReceiver.h"

module CoReceiverC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive as CoreReceive;
  uses interface SplitControl as AMControl;
  uses interface Receive as RandomDataReceive;
}

implementation {
  message_t pkt;
  bool busy = FALSE;
  uint32_t randomData[DATA_ARRAY_LEN];
  uint8_t seqNum[];

  event void Boot.booted() {
    call AMControl.start();
    uint8_t i;
    for (i = 0; i < DATA_ARRAY_LEN; ++i) {
      randomData[i] = UINT_MAX;
    }
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      // Nothing TODO
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event message_t* RandomDataReceiver.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(DataMsg)) {
      DataMsg *data_pkt = (DataMsg *)payload;
      randomData[data_pkt.sequence_number] = data_pkt.random_integer;
    }
    return msg;
  }

  event message_t* CoreReceiver.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(AskMsg)) {
      AskMsg *ask_pkt = (AskMsg *)payload;
      DataMsg *replypkt;
      replypkt = (DataMsg *)(call Packet.getPayload(&pkt,sizeof(DataMsg)));
      replypkt.sequence_number = ask_pkt.sequence;
      replypkt.random_integer = randomData[ask_pkt.sequence];
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt,sizeof(DataMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
    return msg;
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }
}


//TODO
