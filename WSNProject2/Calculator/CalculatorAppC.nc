configuration CalculatorAppC {
}

implementation {
  components MainC;
  components LedsC;
  components CalculatorC as App;
  components ActiveMessageC;
  components new AMReceiverC(0) as RandomDataReceiver;
  components new AMReceiverC(AM_CO) as CoReceiver;
  components new AMSenderC(AM_CO) as ReqSender;

  components PrintfC;
  components SerialStartC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.RandomDataReceive -> RandomDataReceiver;
  App.CoReceive -> CoReceiver;
  App.Packet -> ReqSender;
  App.AMPacket -> ReqSender;
  App.Leds -> LedsC;
  App.ReqSend -> ReqSender;
  App.ReqAck -> ReqSender;
}
