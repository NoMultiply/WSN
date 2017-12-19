#include "../WSN.h"

configuration BaseStationC {
}
implementation {
  components MainC, BaseStationP, LedsC;
  components ActiveMessageC as Radio, SerialActiveMessageC as Serial;
  components new AMReceiverC(AM_DATAMSG);
  components new AMSenderC(AM_CONTROLMSG);
  components new AMSnooperC(AM_DATAMSG);

  MainC.Boot <- BaseStationP;

  BaseStationP.RadioControl -> Radio;
  BaseStationP.SerialControl -> Serial;

  BaseStationP.UartSend -> Serial;
  BaseStationP.UartReceive -> Serial.Receive;
  BaseStationP.UartPacket -> Serial;
  BaseStationP.UartAMPacket -> Serial;
  BaseStationP.RadioSend -> AMSenderC;
  BaseStationP.RadioReceive -> AMReceiverC;
  BaseStationP.RadioSnoop -> AMSnooperC;
  BaseStationP.RadioPacket -> Radio;
  BaseStationP.RadioAMPacket -> Radio;
  BaseStationP.RadioAck -> AMSenderC;

  BaseStationP.Leds -> LedsC;
}
