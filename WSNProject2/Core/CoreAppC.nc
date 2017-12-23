#include "../WSN.h"

configuration CoreAppC {
}

implementation {
  components MainC;
  components LedsC;
  components CoreC as App;
  components ActiveMessageC;
  components new AMSenderC(AM_CO) as CoSender;
  components new AMReceiverC(AM_CO) as CoreReceiver;

  components PrintfC;
  components SerialStartC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.CoreReceive -> CoreReceiver;
  App.Packet -> CoSender;
  App.AMPacket -> CoSender;
  App.CoSend -> CoSender;
  App.CoAck -> CoSender;
  App.Leds -> LedsC;
}
