#include "Timer.h"
#include "../msg.h"
#include <stdio.h>

#define SAMPLING_FREQUENCY 100

module ACKSenderC {
  uses interface Boot;
  uses interface Leds;
  uses interface SplitControl as AMControl;
	uses interface AMSend;
	uses interface Packet;
	uses interface AMPacket;
  uses interface Receive;
}
implementation {
  message_t pkt;
  bool busy = FALSE;

  event void Boot.booted() {
  	call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
      // Nothing TODO
		} else {
			call AMControl.start();
		}
  }

  event void Control.stopDone(error_t err) {
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		//if(len == sizeof(result_msg_t) && call AMPacket.source(msg) == 10 && call AMPacket.destination(msg) == 0) {
    if(len == sizeof(result_msg_t) {
			result_msg_t* recv_pkt = (result_msg_t*)payload;
			ack_msg_t* this_pkt = (ack_msg_t*)(call Packet.getPayload(&pkt, NULL));
			//printf("group_id: %u\nmax: %lu\nmin: %lu\nsum: %lu\naverage: %lu\nmedian: %lu\n", recv_pkt->group_id, recv_pkt->max, recv_pkt->min, recv_pkt->sum, recv_pkt->average, recv_pkt->median);
			this_pkt -> group_id = 19;
			if(call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(ack_msg_t)) == SUCCESS) {
				busy = TRUE;
			}
		}
		return msg;
	}

  event void AMSend.sendDone(message_t* msg, error_t error) {
		if(&pkt == msg) {
			busy = FALSE;
		}
	}
}
