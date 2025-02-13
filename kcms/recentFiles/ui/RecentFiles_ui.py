# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/lingmo/project/nx_pkg/LingmoOS/shell/frameworks/lingmo-desktop/kcms/recentFiles/ui/RecentFiles.ui'
#
# Created by: PyQt5 UI code generator 5.15.11
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_RecentFiles(object):
    def setupUi(self, RecentFiles):
        RecentFiles.setObjectName("RecentFiles")
        RecentFiles.resize(629, 500)
        self.verticalLayout = QtWidgets.QVBoxLayout(RecentFiles)
        self.verticalLayout.setObjectName("verticalLayout")
        self.messageWidget = KMessageWidget(RecentFiles)
        self.messageWidget.setMessageType(KMessageWidget.Positive)
        icon = QtGui.QIcon.fromTheme("dialog-ok-apply")
        self.messageWidget.setIcon(icon)
        self.messageWidget.setObjectName("messageWidget")
        self.verticalLayout.addWidget(self.messageWidget)
        self.formLayout = QtWidgets.QFormLayout()
        self.formLayout.setFormAlignment(QtCore.Qt.AlignHCenter|QtCore.Qt.AlignTop)
        self.formLayout.setObjectName("formLayout")
        self.labelKeepHistory = QtWidgets.QLabel(RecentFiles)
        self.labelKeepHistory.setObjectName("labelKeepHistory")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.LabelRole, self.labelKeepHistory)
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.kcfg_keepHistoryFor = QtWidgets.QSpinBox(RecentFiles)
        self.kcfg_keepHistoryFor.setObjectName("kcfg_keepHistoryFor")
        self.horizontalLayout.addWidget(self.kcfg_keepHistoryFor)
        self.buttonClearRecentHistory = QtWidgets.QPushButton(RecentFiles)
        icon = QtGui.QIcon.fromTheme("edit-clear-history")
        self.buttonClearRecentHistory.setIcon(icon)
        self.buttonClearRecentHistory.setObjectName("buttonClearRecentHistory")
        self.horizontalLayout.addWidget(self.buttonClearRecentHistory)
        self.formLayout.setLayout(0, QtWidgets.QFormLayout.FieldRole, self.horizontalLayout)
        self.kcfg_whatToRemember = QtWidgets.QGroupBox(RecentFiles)
        self.kcfg_whatToRemember.setTitle("")
        self.kcfg_whatToRemember.setFlat(True)
        self.kcfg_whatToRemember.setObjectName("kcfg_whatToRemember")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout(self.kcfg_whatToRemember)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.radioRememberAllApplications = QtWidgets.QRadioButton(self.kcfg_whatToRemember)
        self.radioRememberAllApplications.setChecked(True)
        self.radioRememberAllApplications.setObjectName("radioRememberAllApplications")
        self.verticalLayout_2.addWidget(self.radioRememberAllApplications)
        self.radioDontRememberApplications = QtWidgets.QRadioButton(self.kcfg_whatToRemember)
        self.radioDontRememberApplications.setObjectName("radioDontRememberApplications")
        self.verticalLayout_2.addWidget(self.radioDontRememberApplications)
        self.radioRememberSpecificApplications = QtWidgets.QRadioButton(self.kcfg_whatToRemember)
        self.radioRememberSpecificApplications.setObjectName("radioRememberSpecificApplications")
        self.verticalLayout_2.addWidget(self.radioRememberSpecificApplications)
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.FieldRole, self.kcfg_whatToRemember)
        self.labelRememberDocuments = QtWidgets.QLabel(RecentFiles)
        self.labelRememberDocuments.setObjectName("labelRememberDocuments")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.LabelRole, self.labelRememberDocuments)
        self.verticalLayout.addLayout(self.formLayout)
        self.viewBlacklistedApplications = QtQuickWidgets.QQuickWidget(RecentFiles)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.MinimumExpanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.viewBlacklistedApplications.sizePolicy().hasHeightForWidth())
        self.viewBlacklistedApplications.setSizePolicy(sizePolicy)
        self.viewBlacklistedApplications.setMinimumSize(QtCore.QSize(0, 200))
        self.viewBlacklistedApplications.setResizeMode(QtQuickWidgets.QQuickWidget.SizeRootObjectToView)
        self.viewBlacklistedApplications.setObjectName("viewBlacklistedApplications")
        self.verticalLayout.addWidget(self.viewBlacklistedApplications)
        self.horizontalLayout_1 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_1.setContentsMargins(6, -1, -1, -1)
        self.horizontalLayout_1.setObjectName("horizontalLayout_1")
        self.kcfg_blockedByDefault = QtWidgets.QCheckBox(RecentFiles)
        self.kcfg_blockedByDefault.setObjectName("kcfg_blockedByDefault")
        self.horizontalLayout_1.addWidget(self.kcfg_blockedByDefault)
        self.verticalLayout.addLayout(self.horizontalLayout_1)

        self.retranslateUi(RecentFiles)
        self.radioRememberSpecificApplications.toggled['bool'].connect(self.kcfg_blockedByDefault.setEnabled) # type: ignore
        QtCore.QMetaObject.connectSlotsByName(RecentFiles)

    def retranslateUi(self, RecentFiles):
        _translate = QtCore.QCoreApplication.translate
        self.messageWidget.setText(_translate("RecentFiles", "Cleared the activity history."))
        self.labelKeepHistory.setText(_translate("RecentFiles", "Keep history:"))
        self.buttonClearRecentHistory.setText(_translate("RecentFiles", "Clear History"))
        self.radioRememberAllApplications.setText(_translate("RecentFiles", "For a&ll applications"))
        self.radioDontRememberApplications.setText(_translate("RecentFiles", "&Do not remember"))
        self.radioRememberSpecificApplications.setText(_translate("RecentFiles", "O&nly for specific applications:"))
        self.labelRememberDocuments.setText(_translate("RecentFiles", "Remember opened documents:"))
        self.kcfg_blockedByDefault.setText(_translate("RecentFiles", "Blacklist applications not on the list"))
from PyQt5 import QtQuickWidgets
from kmessagewidget import KMessageWidget
