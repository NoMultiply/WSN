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
  uses interface PacketAcknowledgements as CoreAck;
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
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event message_t* RandomDataReceive.receive(message_t* msg, void* payload, uint8_t len){
    atomic if (len == sizeof(data_packge)) {
      data_packge *data_pkt = (data_packge *)payload;
      randomData[data_pkt->sequence_number - 1] = data_pkt->random_integer;
      if (data_pkt->sequence_number % 100 == 0) {
        call Leds.led1Toggle();
      }
      else if (data_pkt->sequence_number == 2000) {
        call Leds.led0On();
      }

    }
    return msg;
  }

  task void send_to_core() {
    while (call CoreAck.requestAck(&pkt) != SUCCESS) {

    }
    while (call CoreSend.send(124, &pkt, sizeof(data_packge)) == SUCCESS) {
      while (call CoreAck.requestAck(&pkt) != SUCCESS) {

      }
    }
  }

  event message_t* CoreReceive.receive(message_t* msg, void* payload, uint8_t len){
    atomic if (len == sizeof(AskMsg)) {
      AskMsg *ask_pkt = (AskMsg *)payload;
      data_packge *replypkt;
      call Leds.led2Toggle();
      replypkt = (data_packge *)(call Packet.getPayload(&pkt,sizeof(data_packge)));
      replypkt->sequence_number = ask_pkt->sequence;
      replypkt->random_integer = randomData[ask_pkt->sequence - 1];
      post send_to_core();
    }
    return msg;
  }

  event void CoreSend.sendDone(message_t* msg, error_t err) {
    if (call CoreAck.wasAcked(&pkt)) {
      // Nothing TODO
    }
    else {
      post send_to_core();
    }
  }
}
