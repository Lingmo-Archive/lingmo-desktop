# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/lingmo/project/nx_pkg/LingmoOS/shell/frameworks/lingmo-desktop/kcms/solid_actions/ActionEditor.ui'
#
# Created by: PyQt5 UI code generator 5.15.11
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_ActionEditor(object):
    def setupUi(self, ActionEditor):
        ActionEditor.setObjectName("ActionEditor")
        ActionEditor.resize(602, 522)
        self.gridLayout_5 = QtWidgets.QGridLayout(ActionEditor)
        self.gridLayout_5.setObjectName("gridLayout_5")
        self.GbParameter = QtWidgets.QGroupBox(ActionEditor)
        self.GbParameter.setObjectName("GbParameter")
        self.gridLayout_2 = QtWidgets.QGridLayout(self.GbParameter)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.GlParameterType = QtWidgets.QGridLayout()
        self.GlParameterType.setObjectName("GlParameterType")
        self.LblParameterType = QtWidgets.QLabel(self.GbParameter)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Maximum, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.LblParameterType.sizePolicy().hasHeightForWidth())
        self.LblParameterType.setSizePolicy(sizePolicy)
        self.LblParameterType.setMinimumSize(QtCore.QSize(150, 0))
        self.LblParameterType.setMaximumSize(QtCore.QSize(150, 16777215))
        self.LblParameterType.setObjectName("LblParameterType")
        self.GlParameterType.addWidget(self.LblParameterType, 0, 0, 1, 1)
        self.CbParameterType = QtWidgets.QComboBox(self.GbParameter)
        self.CbParameterType.setObjectName("CbParameterType")
        self.CbParameterType.addItem("")
        self.CbParameterType.addItem("")
        self.CbParameterType.addItem("")
        self.CbParameterType.addItem("")
        self.GlParameterType.addWidget(self.CbParameterType, 0, 1, 1, 1)
        self.gridLayout_2.addLayout(self.GlParameterType, 0, 0, 1, 1)
        self.GlDeviceType = QtWidgets.QGridLayout()
        self.GlDeviceType.setObjectName("GlDeviceType")
        self.LblDeviceType = QtWidgets.QLabel(self.GbParameter)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Maximum, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.LblDeviceType.sizePolicy().hasHeightForWidth())
        self.LblDeviceType.setSizePolicy(sizePolicy)
        self.LblDeviceType.setMinimumSize(QtCore.QSize(150, 0))
        self.LblDeviceType.setMaximumSize(QtCore.QSize(150, 16777215))
        self.LblDeviceType.setObjectName("LblDeviceType")
        self.GlDeviceType.addWidget(self.LblDeviceType, 0, 0, 1, 1)
        self.CbDeviceType = QtWidgets.QComboBox(self.GbParameter)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.CbDeviceType.sizePolicy().hasHeightForWidth())
        self.CbDeviceType.setSizePolicy(sizePolicy)
        self.CbDeviceType.setObjectName("CbDeviceType")
        self.GlDeviceType.addWidget(self.CbDeviceType, 0, 1, 1, 1)
        self.gridLayout_2.addLayout(self.GlDeviceType, 1, 0, 1, 1)
        self.GlValueName = QtWidgets.QGridLayout()
        self.GlValueName.setObjectName("GlValueName")
        self.LblValueName = QtWidgets.QLabel(self.GbParameter)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Maximum, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.LblValueName.sizePolicy().hasHeightForWidth())
        self.LblValueName.setSizePolicy(sizePolicy)
        self.LblValueName.setMinimumSize(QtCore.QSize(150, 0))
        self.LblValueName.setMaximumSize(QtCore.QSize(150, 16777215))
        self.LblValueName.setObjectName("LblValueName")
        self.GlValueName.addWidget(self.LblValueName, 0, 0, 1, 1)
        self.CbValueName = QtWidgets.QComboBox(self.GbParameter)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.CbValueName.sizePolicy().hasHeightForWidth())
        self.CbValueName.setSizePolicy(sizePolicy)
        self.CbValueName.setObjectName("CbValueName")
        self.GlValueName.addWidget(self.CbValueName, 0, 1, 1, 1)
        self.gridLayout_2.addLayout(self.GlValueName, 2, 0, 1, 1)
        self.GlValueMatch = QtWidgets.QGridLayout()
        self.GlValueMatch.setObjectName("GlValueMatch")
        self.CbValueMatch = QtWidgets.QComboBox(self.GbParameter)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Maximum, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.CbValueMatch.sizePolicy().hasHeightForWidth())
        self.CbValueMatch.setSizePolicy(sizePolicy)
        self.CbValueMatch.setMinimumSize(QtCore.QSize(150, 0))
        self.CbValueMatch.setMaximumSize(QtCore.QSize(150, 16777215))
        self.CbValueMatch.setObjectName("CbValueMatch")
        self.CbValueMatch.addItem("")
        self.CbValueMatch.addItem("")
        self.GlValueMatch.addWidget(self.CbValueMatch, 0, 0, 1, 1)
        self.LeValueMatch = QtWidgets.QLineEdit(self.GbParameter)
        self.LeValueMatch.setObjectName("LeValueMatch")
        self.GlValueMatch.addWidget(self.LeValueMatch, 0, 1, 1, 1)
        self.gridLayout_2.addLayout(self.GlValueMatch, 3, 0, 1, 1)
        self.GlParameterControl = QtWidgets.QGridLayout()
        self.GlParameterControl.setObjectName("GlParameterControl")
        spacerItem = QtWidgets.QSpacerItem(227, 25, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.GlParameterControl.addItem(spacerItem, 0, 0, 1, 1)
        self.PbParameterReset = QtWidgets.QPushButton(self.GbParameter)
        self.PbParameterReset.setObjectName("PbParameterReset")
        self.GlParameterControl.addWidget(self.PbParameterReset, 0, 1, 1, 1)
        self.PbParameterSave = QtWidgets.QPushButton(self.GbParameter)
        self.PbParameterSave.setObjectName("PbParameterSave")
        self.GlParameterControl.addWidget(self.PbParameterSave, 0, 2, 1, 1)
        self.gridLayout_2.addLayout(self.GlParameterControl, 4, 0, 1, 1)
        self.gridLayout_5.addWidget(self.GbParameter, 3, 0, 1, 1)
        self.GlActionIconName = QtWidgets.QGridLayout()
        self.GlActionIconName.setObjectName("GlActionIconName")
        self.IbActionIcon = KIconButton(ActionEditor)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.IbActionIcon.sizePolicy().hasHeightForWidth())
        self.IbActionIcon.setSizePolicy(sizePolicy)
        self.IbActionIcon.setMinimumSize(QtCore.QSize(80, 80))
        self.IbActionIcon.setMaximumSize(QtCore.QSize(75, 75))
        self.IbActionIcon.setObjectName("IbActionIcon")
        self.GlActionIconName.addWidget(self.IbActionIcon, 0, 0, 1, 1)
        self.LeActionFriendlyName = QtWidgets.QLineEdit(ActionEditor)
        self.LeActionFriendlyName.setObjectName("LeActionFriendlyName")
        self.GlActionIconName.addWidget(self.LeActionFriendlyName, 0, 1, 1, 1)
        self.gridLayout_5.addLayout(self.GlActionIconName, 0, 0, 1, 1)
        self.GlActionCommand = QtWidgets.QGridLayout()
        self.GlActionCommand.setObjectName("GlActionCommand")
        self.TlActionCommand = QtWidgets.QLabel(ActionEditor)
        self.TlActionCommand.setMinimumSize(QtCore.QSize(80, 0))
        self.TlActionCommand.setObjectName("TlActionCommand")
        self.GlActionCommand.addWidget(self.TlActionCommand, 0, 0, 1, 1)
        self.LeActionCommand = KUrlRequester(ActionEditor)
        self.LeActionCommand.setObjectName("LeActionCommand")
        self.GlActionCommand.addWidget(self.LeActionCommand, 0, 1, 1, 1)
        self.gridLayout_5.addLayout(self.GlActionCommand, 1, 0, 1, 1)
        self.GlPredicateTree = QtWidgets.QGridLayout()
        self.GlPredicateTree.setObjectName("GlPredicateTree")
        self.TlPredicateTree = QtWidgets.QLabel(ActionEditor)
        self.TlPredicateTree.setMinimumSize(QtCore.QSize(80, 0))
        self.TlPredicateTree.setObjectName("TlPredicateTree")
        self.GlPredicateTree.addWidget(self.TlPredicateTree, 0, 0, 1, 2)
        self.TvPredicateTree = QtWidgets.QTreeView(ActionEditor)
        self.TvPredicateTree.setObjectName("TvPredicateTree")
        self.GlPredicateTree.addWidget(self.TvPredicateTree, 1, 0, 1, 2)
        self.gridLayout_5.addLayout(self.GlPredicateTree, 2, 0, 1, 1)
        self.buttonBox = QtWidgets.QDialogButtonBox(ActionEditor)
        self.buttonBox.setStandardButtons(QtWidgets.QDialogButtonBox.Cancel|QtWidgets.QDialogButtonBox.Ok)
        self.buttonBox.setObjectName("buttonBox")
        self.gridLayout_5.addWidget(self.buttonBox, 4, 0, 1, 1)

        self.retranslateUi(ActionEditor)
        QtCore.QMetaObject.connectSlotsByName(ActionEditor)
        ActionEditor.setTabOrder(self.IbActionIcon, self.LeActionFriendlyName)
        ActionEditor.setTabOrder(self.LeActionFriendlyName, self.LeActionCommand)
        ActionEditor.setTabOrder(self.LeActionCommand, self.TvPredicateTree)
        ActionEditor.setTabOrder(self.TvPredicateTree, self.CbDeviceType)
        ActionEditor.setTabOrder(self.CbDeviceType, self.CbParameterType)
        ActionEditor.setTabOrder(self.CbParameterType, self.CbValueName)
        ActionEditor.setTabOrder(self.CbValueName, self.CbValueMatch)
        ActionEditor.setTabOrder(self.CbValueMatch, self.LeValueMatch)
        ActionEditor.setTabOrder(self.LeValueMatch, self.PbParameterReset)
        ActionEditor.setTabOrder(self.PbParameterReset, self.PbParameterSave)

    def retranslateUi(self, ActionEditor):
        _translate = QtCore.QCoreApplication.translate
        self.GbParameter.setTitle(_translate("ActionEditor", "Edit Parameter"))
        self.LblParameterType.setText(_translate("ActionEditor", "Parameter type:"))
        self.CbParameterType.setItemText(0, _translate("ActionEditor", "Property Match"))
        self.CbParameterType.setItemText(1, _translate("ActionEditor", "Content Conjunction"))
        self.CbParameterType.setItemText(2, _translate("ActionEditor", "Content Disjunction"))
        self.CbParameterType.setItemText(3, _translate("ActionEditor", "Device Interface Match"))
        self.LblDeviceType.setText(_translate("ActionEditor", "Device type:"))
        self.LblValueName.setText(_translate("ActionEditor", "Value name:"))
        self.CbValueMatch.setItemText(0, _translate("ActionEditor", "Equals"))
        self.CbValueMatch.setItemText(1, _translate("ActionEditor", "Contains"))
        self.PbParameterReset.setText(_translate("ActionEditor", "Reset Parameter"))
        self.PbParameterSave.setText(_translate("ActionEditor", "Save Parameter Changes"))
        self.IbActionIcon.setToolTip(_translate("ActionEditor", "Action icon, click to change it"))
        self.LeActionFriendlyName.setToolTip(_translate("ActionEditor", "Action name"))
        self.TlActionCommand.setText(_translate("ActionEditor", "Command: "))
        self.LeActionCommand.setToolTip(_translate("ActionEditor", "Command that will trigger the action\n"
"This can include any or all of the following case insensitive expands:\n"
"\n"
"%f: The mountpoint for the device - Storage Access devices only\n"
"%d: Path to the device node - Block devices only\n"
"%i: The identifier of the device"))
        self.TlPredicateTree.setText(_translate("ActionEditor", "Devices must match the following parameters for this action:"))
from kiconbutton import KIconButton
from kurlrequester import KUrlRequester
