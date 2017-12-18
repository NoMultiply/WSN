from ControllerUi.DeviceItem_ui import Ui_DeviceItem
from PyQt4.QtGui import QWidget, QColorDialog, QColor
from PyQt4.QtCore import pyqtSignal
import random


class DeviceItem(Ui_DeviceItem, QWidget):

    colorChanged = pyqtSignal(int, QColor)
    showChanged = pyqtSignal(int, bool, bool, bool, bool)
    temperatureChanged = pyqtSignal(int, bool)
    humidityChanged = pyqtSignal(int, bool)
    illuminationChanged = pyqtSignal(int, bool)

    def __init__(self, parent, node_id):
        super(DeviceItem, self).__init__(parent)
        self.setupUi(self)
        self.m_box.setTitle("Device " + str(node_id))
        self.m_color.clicked.connect(self.get_color)
        self.node_id = node_id
        self.color =  QColor(random.uniform(0, 255), random.uniform(0, 100), random.uniform(0, 100))
        self.m_show.stateChanged.connect(self.change_show)
        self.m_temperature.stateChanged.connect(self.change_temperature)
        self.m_humidity.stateChanged.connect(self.change_humidity)
        self.m_illumination.stateChanged.connect(self.change_illumination)
        self.set_color(self.color)

    def get_color(self):
        color = QColorDialog.getColor(self.color)
        self.color = color
        self.set_color(color)

    def set_color(self, color):
        str_color = "%02x%02x%02x" % (color.red(), color.green(), color.blue())
        self.m_color.setStyleSheet("background: #" + str_color)
        self.colorChanged.emit(self.node_id, color)

    def change_show(self):
        self.showChanged.emit(self.node_id, self.m_show.isChecked(), self.m_temperature.isChecked(),
                              self.m_humidity.isChecked(), self.m_illumination.isChecked())
        if self.m_show.isChecked():
            self.m_temperature.setEnabled(True)
            self.m_humidity.setEnabled(True)
            self.m_illumination.setEnabled(True)
        else:
            self.m_temperature.setEnabled(False)
            self.m_humidity.setEnabled(False)
            self.m_illumination.setEnabled(False)

    def change_temperature(self):
        self.temperatureChanged.emit(self.node_id, self.m_temperature.isChecked())

    def change_humidity(self):
        self.humidityChanged.emit(self.node_id, self.m_humidity.isChecked())

    def change_illumination(self):
        self.illuminationChanged.emit(self.node_id, self.m_illumination.isChecked())