#include "printf.h"
#include "Timer.h"
#include "Receiver.h"

module ReceiverC {
  uses interface Boot;
  uses interface Leds;
  uses interface Receive;
  uses interface SplitControl as AMControl;
}
implementation {

  event void Boot.booted() {
    printf("booted\n");
    printfflush();
    call Leds.led1On();
    call AMControl.start();
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

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(CollectorMsg)) {
      CollectorMsg* packet = (CollectorMsg*)payload;
      call Leds.led2Toggle();
      printf("nodeid: %u, temperature: %u, humidity: %u, illumination: %u\n", packet->nodeid, packet->temperature, packet->humidity, packet->illumination);
      printfflush();
    }
    return msg;
  }
}
