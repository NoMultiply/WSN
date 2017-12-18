from ControllerUi.controller_ui import Ui_ControllerGUI
from PyQt4.QtGui import QMainWindow, QIntValidator
from SerialInterface import SerialInterface


class ControllerGui(Ui_ControllerGUI, QMainWindow):

    def __init__(self):
        super(ControllerGui, self).__init__()
        self.setupUi(self)
        self.m_clear.clicked.connect(self.m_result.clear)
        self.m_send.clicked.connect(self.send_freq)
        self.interface = SerialInterface()
        self.interface.received.connect(self.show_received)
        self.m_freq.setValidator(QIntValidator(0, 10000))

    def show_received(self, node_id, sequence_num, timestamp, temperature, humidity, illumination):
        self.m_result.append(
            "node_id: %d, sequence_num: %d, timestamp: %d, temperature: %d, humidity: %d, illumination: %d" %
            (node_id, sequence_num, timestamp, temperature, humidity, illumination))

    def send_freq(self):
        self.interface.send(int(self.m_freq.text()))