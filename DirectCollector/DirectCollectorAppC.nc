#include <Timer.h>
#include "../WSN.h"

configuration DirectCollectorAppC {
}
implementation {
  components MainC;
  components LedsC;
  components DirectCollectorC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMReceiverC(AM_WSN_INDIRECT_COLLECTOR) as DataReceiver;
  components new AMSenderC(AM_DATAMSG) as DataSender;
  components new AMReceiverC(AM_CONTROLMSG) as ControlReceiver;
  components new AMSenderC(AM_WSN_INDIRECT_COLLECTOR) as ControlSender;
  components new SensirionSht11C() as Sensor;
  components new HamamatsuS1087ParC() as IlluminationSensor;
  components Msp430Counter32khzC;

  App.Msp430Counter32khz -> Msp430Counter32khzC.Msp430Counter32khz;
  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> DataSender;
  App.AMPacket -> DataSender;
  App.AMControl -> ActiveMessageC;
  App.DataSend -> DataSender;
  App.DataReceive -> DataReceiver;
  App.ControlReceive -> ControlReceiver;
  App.ControlSend -> ControlSender;
  App.ReadTemperature -> Sensor.Temperature;
  App.ReadHumidity -> Sensor.Humidity;
  App.ReadIllumination -> IlluminationSensor;
}
