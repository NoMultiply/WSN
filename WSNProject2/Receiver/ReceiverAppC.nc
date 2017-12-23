#include "../WSN.h"

configuration ReceiverAppC {
}

implementation {
  components MainC;
  components LedsC;
  components ReceiverC as App;
  components ActiveMessageC;
  components new AMSenderC(AM_CO) as CoSender;
  components new AMReceiverC(AM_CO) as CoreReceiver;
  components new AMReceiverC(0) as RandomDataReceiver;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Packet -> CoSender;
  App.AMPacket -> CoSender;
  App.AMControl -> ActiveMessageC;
  App.CoSend -> CoSender;
  App.CoreReceive -> CoreReceiver;
  App.RandomDataReceive -> RandomDataReceiver;
}
