configuration CalculatorAppC {
}

implementation {
  components MainC;
  components LedsC;
  components CalculatorC as App;
  components ActiveMessageC;
  components new AMReceiverC(0);
  
  components PrintfC;
  components SerialStartC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.Receive -> AMReceiverC;
  App.Leds -> LedsC;
}
