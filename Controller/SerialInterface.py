from ControlMsg import *
from DataMsg import *
from tinyos.message import MoteIF
from PyQt4.QtCore import pyqtSignal, QObject
# import serial.tools.list_ports
# import os
# import threading


class SerialInterface(QObject):

    received = pyqtSignal(int, int, int, int, int, int)

    def __init__(self):
        super(SerialInterface, self).__init__()
        self.mif = MoteIF.MoteIF()
        # port_list = list(serial.tools.list_ports.comports())
        # if len(port_list) <= 0:
        #     print "The Serial port can't find!"
        #     raise OSError
        # else:
        #     port_list_0 = list(port_list[0])
        #     port_serial = port_list_0[0]
        #     thread = threading.Thread(target=os.system,
        #        args=("java net.tinyos.sf.SerialForwarder -comm serial@" + port_serial + ":telosb",))
        #     thread.setDaemon(True)
        #     thread.start()
        self.source = self.mif.addSource("sf@localhost:9002")
        self.mif.addListener(self, DataMsg)
        self.handler = None

    def receive(self, src, msg):
        self.received.emit(msg.get_nodeid(), msg.get_sequence_num(), msg.get_timestamp(),
                           msg.get_temperature(), msg.get_humidity(), msg.get_illumination())

    def send(self, type, interval=0):
        ts = ControlMsg()
        ts.set_control_type(type)
        ts.set_interval(interval)
        self.mif.sendMsg(self.source, 0, ts.get_amType(), 0, ts)


