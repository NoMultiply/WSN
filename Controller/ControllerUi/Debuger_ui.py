# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/shatter/Desktop/WSN/Controller/ControllerUi/Debuger.ui'
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

class Ui_DebugerGUI(object):
    def setupUi(self, DebugerGUI):
        DebugerGUI.setObjectName(_fromUtf8("DebugerGUI"))
        DebugerGUI.setWindowModality(QtCore.Qt.WindowModal)
        DebugerGUI.resize(954, 587)
        self.centralwidget = QtGui.QWidget(DebugerGUI)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.verticalLayout_4 = QtGui.QVBoxLayout(self.centralwidget)
        self.verticalLayout_4.setObjectName(_fromUtf8("verticalLayout_4"))
        self.verticalLayout_3 = QtGui.QVBoxLayout()
        self.verticalLayout_3.setObjectName(_fromUtf8("verticalLayout_3"))
        self.horizontalLayout_3 = QtGui.QHBoxLayout()
        self.horizontalLayout_3.setObjectName(_fromUtf8("horizontalLayout_3"))
        self.m_interval = QtGui.QLineEdit(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_interval.sizePolicy().hasHeightForWidth())
        self.m_interval.setSizePolicy(sizePolicy)
        self.m_interval.setObjectName(_fromUtf8("m_interval"))
        self.horizontalLayout_3.addWidget(self.m_interval)
        self.m_send = QtGui.QPushButton(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_send.sizePolicy().hasHeightForWidth())
        self.m_send.setSizePolicy(sizePolicy)
        self.m_send.setObjectName(_fromUtf8("m_send"))
        self.horizontalLayout_3.addWidget(self.m_send)
        self.m_stop = QtGui.QPushButton(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_stop.sizePolicy().hasHeightForWidth())
        self.m_stop.setSizePolicy(sizePolicy)
        self.m_stop.setObjectName(_fromUtf8("m_stop"))
        self.horizontalLayout_3.addWidget(self.m_stop)
        self.verticalLayout_3.addLayout(self.horizontalLayout_3)
        self.horizontalLayout_4 = QtGui.QHBoxLayout()
        self.horizontalLayout_4.setObjectName(_fromUtf8("horizontalLayout_4"))
        self.verticalLayout = QtGui.QVBoxLayout()
        self.verticalLayout.setObjectName(_fromUtf8("verticalLayout"))
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setObjectName(_fromUtf8("horizontalLayout"))
        self.label = QtGui.QLabel(self.centralwidget)
        self.label.setObjectName(_fromUtf8("label"))
        self.horizontalLayout.addWidget(self.label)
        self.m_clear1 = QtGui.QPushButton(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_clear1.sizePolicy().hasHeightForWidth())
        self.m_clear1.setSizePolicy(sizePolicy)
        self.m_clear1.setObjectName(_fromUtf8("m_clear1"))
        self.horizontalLayout.addWidget(self.m_clear1)
        spacerItem = QtGui.QSpacerItem(40, 20, QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Minimum)
        self.horizontalLayout.addItem(spacerItem)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.m_result1 = QtGui.QTextBrowser(self.centralwidget)
        self.m_result1.setObjectName(_fromUtf8("m_result1"))
        self.verticalLayout.addWidget(self.m_result1)
        self.horizontalLayout_4.addLayout(self.verticalLayout)
        self.verticalLayout_2 = QtGui.QVBoxLayout()
        self.verticalLayout_2.setObjectName(_fromUtf8("verticalLayout_2"))
        self.horizontalLayout_2 = QtGui.QHBoxLayout()
        self.horizontalLayout_2.setObjectName(_fromUtf8("horizontalLayout_2"))
        self.label_2 = QtGui.QLabel(self.centralwidget)
        self.label_2.setObjectName(_fromUtf8("label_2"))
        self.horizontalLayout_2.addWidget(self.label_2)
        self.m_clear2 = QtGui.QPushButton(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_clear2.sizePolicy().hasHeightForWidth())
        self.m_clear2.setSizePolicy(sizePolicy)
        self.m_clear2.setObjectName(_fromUtf8("m_clear2"))
        self.horizontalLayout_2.addWidget(self.m_clear2)
        spacerItem1 = QtGui.QSpacerItem(40, 20, QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem1)
        self.verticalLayout_2.addLayout(self.horizontalLayout_2)
        self.m_result2 = QtGui.QTextBrowser(self.centralwidget)
        self.m_result2.setObjectName(_fromUtf8("m_result2"))
        self.verticalLayout_2.addWidget(self.m_result2)
        self.horizontalLayout_4.addLayout(self.verticalLayout_2)
        self.verticalLayout_3.addLayout(self.horizontalLayout_4)
        self.verticalLayout_4.addLayout(self.verticalLayout_3)
        DebugerGUI.setCentralWidget(self.centralwidget)
        self.menubar = QtGui.QMenuBar(DebugerGUI)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 954, 31))
        self.menubar.setObjectName(_fromUtf8("menubar"))
        DebugerGUI.setMenuBar(self.menubar)

        self.retranslateUi(DebugerGUI)
        QtCore.QMetaObject.connectSlotsByName(DebugerGUI)

    def retranslateUi(self, DebugerGUI):
        DebugerGUI.setWindowTitle(_translate("DebugerGUI", "Debuger", None))
        self.m_interval.setText(_translate("DebugerGUI", "1000", None))
        self.m_send.setText(_translate("DebugerGUI", "send", None))
        self.m_stop.setText(_translate("DebugerGUI", "stop", None))
        self.label.setText(_translate("DebugerGUI", "Node 1", None))
        self.m_clear1.setText(_translate("DebugerGUI", "clear", None))
        self.label_2.setText(_translate("DebugerGUI", "Node 2", None))
        self.m_clear2.setText(_translate("DebugerGUI", "clear", None))

