#include "Timer.h"
#include "../msg.h"
#include <stdio.h>

#define SAMPLING_FREQUENCY 100

module ACKSenderC {
  uses {
  	interface SplitControl as Control;
  	interface AMSend;
  	interface Packet;
  	interface AMPacket;
    interface Boot;
    interface Leds;
    interface Receive;
  }
}
implementation {

}
