#include "../RandomSender/Calculate.h"
#include "../WSN.h"

module CoReceiverC {
  uses interface Boot;
  uses interface Leds;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend as CoreSend;
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
    uint16_t i;
    call AMControl.start();
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

  event message_t* RandomDataReceive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(data_packge)) {
      data_packge *data_pkt = (data_packge *)payload;
      randomData[data_pkt->sequence_number - 1] = data_pkt->random_integer;
    }
    return msg;
  }

  event message_t* CoreReceive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(AskMsg)) {
      AskMsg *ask_pkt = (AskMsg *)payload;
      data_packge *replypkt;
      replypkt = (data_packge *)(call Packet.getPayload(&pkt,sizeof(data_packge)));
      replypkt->sequence_number = ask_pkt->sequence;
      replypkt->random_integer = randomData[ask_pkt->sequence - 1];
      if (call CoreSend.send(AM_BROADCAST_ADDR, &pkt,sizeof(data_packge)) == SUCCESS) {
        busy = TRUE;
      }
    }
    return msg;
  }

  event void CoreSend.sendDone(message_t* msg, error_t err) {
    // Nothing TODO
  }
}
