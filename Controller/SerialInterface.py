from ControlMsg import *
from DataMsg import *
from tinyos.message import MoteIF
from PyQt4.QtCore import pyqtSignal, QObject


class SerialInterface(QObject):

    received = pyqtSignal(int, int, int, int, int, int)

    def __init__(self):
        super(SerialInterface, self).__init__()
        self.mif = MoteIF.MoteIF()
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


