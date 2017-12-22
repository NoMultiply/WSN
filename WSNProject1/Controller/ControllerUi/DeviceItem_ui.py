# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/shatter/Desktop/WSN/Controller/ControllerUi/DeviceItem.ui'
#
# Created by: PyQt4 UI code generator 4.11.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_DeviceItem(object):
    def setupUi(self, DeviceItem):
        DeviceItem.setObjectName(_fromUtf8("DeviceItem"))
        DeviceItem.resize(175, 189)
        DeviceItem.setStyleSheet(_fromUtf8(""))
        self.verticalLayout_3 = QtGui.QVBoxLayout(DeviceItem)
        self.verticalLayout_3.setContentsMargins(-1, -1, 20, -1)
        self.verticalLayout_3.setObjectName(_fromUtf8("verticalLayout_3"))
        self.m_box = QtGui.QGroupBox(DeviceItem)
        self.m_box.setAutoFillBackground(False)
        self.m_box.setObjectName(_fromUtf8("m_box"))
        self.verticalLayout_2 = QtGui.QVBoxLayout(self.m_box)
        self.verticalLayout_2.setObjectName(_fromUtf8("verticalLayout_2"))
        self.verticalLayout = QtGui.QVBoxLayout()
        self.verticalLayout.setObjectName(_fromUtf8("verticalLayout"))
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setObjectName(_fromUtf8("horizontalLayout"))
        self.label_2 = QtGui.QLabel(self.m_box)
        self.label_2.setObjectName(_fromUtf8("label_2"))
        self.horizontalLayout.addWidget(self.label_2)
        self.m_color = QtGui.QPushButton(self.m_box)
        self.m_color.setStyleSheet(_fromUtf8("border: 1px solid black"))
        self.m_color.setText(_fromUtf8(""))
        self.m_color.setObjectName(_fromUtf8("m_color"))
        self.horizontalLayout.addWidget(self.m_color)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.m_show = QtGui.QCheckBox(self.m_box)
        self.m_show.setChecked(True)
        self.m_show.setObjectName(_fromUtf8("m_show"))
        self.verticalLayout.addWidget(self.m_show)
        self.m_temperature = QtGui.QCheckBox(self.m_box)
        self.m_temperature.setChecked(True)
        self.m_temperature.setObjectName(_fromUtf8("m_temperature"))
        self.verticalLayout.addWidget(self.m_temperature)
        self.m_humidity = QtGui.QCheckBox(self.m_box)
        self.m_humidity.setChecked(True)
        self.m_humidity.setObjectName(_fromUtf8("m_humidity"))
        self.verticalLayout.addWidget(self.m_humidity)
        self.m_illumination = QtGui.QCheckBox(self.m_box)
        self.m_illumination.setChecked(True)
        self.m_illumination.setObjectName(_fromUtf8("m_illumination"))
        self.verticalLayout.addWidget(self.m_illumination)
        self.verticalLayout_2.addLayout(self.verticalLayout)
        self.verticalLayout_3.addWidget(self.m_box)

        self.retranslateUi(DeviceItem)
        QtCore.QMetaObject.connectSlotsByName(DeviceItem)

    def retranslateUi(self, DeviceItem):
        DeviceItem.setWindowTitle(_translate("DeviceItem", "Form", None))
        self.m_box.setTitle(_translate("DeviceItem", "Device 0", None))
        self.label_2.setText(_translate("DeviceItem", "color", None))
        self.m_show.setText(_translate("DeviceItem", "show", None))
        self.m_temperature.setText(_translate("DeviceItem", "temperature", None))
        self.m_humidity.setText(_translate("DeviceItem", "humidity", None))
        self.m_illumination.setText(_translate("DeviceItem", "illumination", None))

