#include <Timer.h>
#include "CoReceiver.h"

configuration CoReceiverAppC {
}

implementation {
  components MainC;
  components LedsC;
  components CoReceiverC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_CORECEIVER) as CoSender;
  components new AMReceiverC(AM_CORECEIVER) as CoreReceiver;
  components new AMReceiverC(AM_CORECEIVER) as RandomDataReceiver;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.CoreReceive -> CoreReceiver;
  App.RandomDataReceive -> RandomDataReceiver;
}
<<<<<<< HEAD



//TODO
=======
>>>>>>> dbab5e8e516f5fce3e5982e9c20069b119771768
