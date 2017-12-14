#include <Timer.h>
#include "IndirectCollector.h"

module IndirectCollectorC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t>;
}
implementation {

  message_t pkt;
  bool busy = FALSE;

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Read.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      if (!busy) {
        IndirectCollectorMsg* collectPacket =
  	  (IndirectCollectorMsg*)(call Packet.getPayload(&pkt, sizeof(IndirectCollectorMsg)));
        if (collectPacket == NULL) {
  		return;
        }
        call Leds.led2Toggle();
        collectPacket->nodeid = TOS_NODE_ID;
        collectPacket->temperature = data;
        if (call AMSend.send(AM_BROADCAST_ADDR,
            &pkt, sizeof(IndirectCollectorMsg)) == SUCCESS) {
          busy = TRUE;
        }
      }
    }
  }

  event void Timer0.fired() {
    call Read.read();
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }
}
