#include <Timer.h>
#include "printf.h"
#include "DirectCollector.h"

configuration DirectCollectorAppC {
}
implementation {
  components MainC;
  components LedsC;
  components PrintfC;
  components SerialStartC;
  components DirectCollectorC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMReceiverC(AM_WSN_INDIRECT_COLLECTOR);
  components new AMSenderC(AM_WSN_DIRECT_COLLECTOR);
  components new SensirionSht11C() as Sensor;
  components new HamamatsuS1087ParC() as IlluminationSensor;
  components Msp430Counter32khzC;

  App.Msp430Counter32khz -> Msp430Counter32khzC.Msp430Counter32khz;
  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.ReadTemperature -> Sensor.Temperature;
  App.ReadHumidity -> Sensor.Humidity;
  App.ReadIllumination -> IlluminationSensor;
}
