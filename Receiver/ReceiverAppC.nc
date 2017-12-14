#include "printf.h"
#include "Timer.h"
#include "Receiver.h"

configuration ReceiverAppC {
}
implementation {
  components MainC;
  components LedsC;
  components PrintfC;
  components SerialStartC;
  components ReceiverC as App;
  components new AMReceiverC(AM_WSN_DIRECT_COLLECTOR);
  components ActiveMessageC;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Receive -> AMReceiverC;
  App.AMControl -> ActiveMessageC;
}
