/*
    SPDX-FileCopyrightText: 2018 Tomaz Canabrava <tcanabrava@kde.org>

    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
*/

import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Dialogs 6.3 as Dialogs
import org.kde.kcmutils as KCM
import org.kde.kquickcontrols 2.0 as KQuickAddons
import org.kde.lingmoui 2.3 as LingmoUI

LingmoUI.FormLayout {

    Dialogs.FileDialog {
        id: fileDialog
        title: i18n("Please choose an audio file")
        nameFilters: [i18nc("Name filters in a file dialog. Do not translate `(*.ogg *.oga *.wav)`",
                            "ogg, oga, and wav audio files (*.ogg *.oga *.wav)")]
        onAccepted: {
            kcm.bellSettings.customBellFile = fileDialog.selectedFile
        }
    }

    QQC2.CheckBox {
        id: systemBell

        LingmoUI.FormData.label: i18n("Audible bell:")
        text: i18nc("Enable the system bell", "Enable")
        KCM.SettingStateBinding {
            configObject: kcm.bellSettings
            settingName: "SystemBell"
        }

        checked: kcm.bellSettings.systemBell
        onToggled: kcm.bellSettings.systemBell = checked
    }

    RowLayout {
        LingmoUI.FormData.label: i18nc("Defines if the system will use a sound system bell", "Custom sound:")
        spacing: 0

        QQC2.CheckBox {
            id: customBell
            Layout.alignment: Qt.AlignVCenter

            KCM.SettingStateBinding {
                configObject: kcm.bellSettings
                settingName: "CustomBell"
                extraEnabledConditions: kcm.bellSettings.systemBell
            }

            checked: kcm.bellSettings.customBell
            onToggled: kcm.bellSettings.customBell= checked
        }

        QQC2.TextField {
            id: textEdit

            text: kcm.bellSettings.customBellFile

            KCM.SettingStateBinding {
                configObject: kcm.bellSettings
                settingName: "CustomBellFile"
                extraEnabledConditions: kcm.bellSettings.customBell
            }

            onEditingFinished: kcm.bellSettings.customBellFile = textEdit.text
        }
        QQC2.Button {
            icon.name: "folder"
            QQC2.ToolTip.visible: down
            QQC2.ToolTip.text: i18n("Search audio file for the system bell")
            Accessible.name: i18n("Button search audio file")
            KCM.SettingStateBinding {
                configObject: kcm.bellSettings
                settingName: "CustomBellFile"
                extraEnabledConditions: kcm.bellSettings.customBell
            }

            onClicked: fileDialog.open()
        }
    }
    Item {
        LingmoUI.FormData.isSection: true
    }
    QQC2.CheckBox {
        id: visibleBell

        LingmoUI.FormData.label: i18n("Visual bell:")
        text: i18nc("Enable visual bell", "Enable")

        KCM.SettingStateBinding {
            configObject: kcm.bellSettings
            settingName: "VisibleBell"
        }

        checked: kcm.bellSettings.visibleBell
        onToggled: kcm.bellSettings.visibleBell = checked
    }

    QQC2.RadioButton {
        id: invertScreen

        text: i18nc("Invert screen on a system bell", "Invert Screen")

        KCM.SettingStateBinding {
            configObject: kcm.bellSettings
            settingName: "InvertScreen"
            extraEnabledConditions: kcm.bellSettings.visibleBell
        }

        checked: kcm.bellSettings.invertScreen
        onToggled: kcm.bellSettings.invertScreen = checked
    }
    RowLayout {
        enabled: kcm.bellSettings.visibleBell

        QQC2.RadioButton {
            id: flashScreen

            text: i18nc("Flash screen on a system bell", "Flash")

            KCM.SettingStateBinding {
                configObject: kcm.bellSettings
                settingName: "InvertScreen"
            }

            checked: !kcm.bellSettings.invertScreen
            onToggled: kcm.bellSettings.invertScreen = !checked
        }
        KQuickAddons.ColorButton {
            text: i18nc("Color of the system bell","Color")
            // avoid to show text outside button
            display: QQC2.AbstractButton.IconOnly

            KCM.SettingStateBinding {
                configObject: kcm.bellSettings
                settingName: "VisibleBellColor"
            }

            color: kcm.bellSettings.visibleBellColor
            onAccepted: color => kcm.bellSettings.visibleBellColor = color
        }
    }
    QQC2.SpinBox {
        LingmoUI.FormData.label: i18nc("Duration of the system bell", "Duration:")

        from: 100
        to: 2000

        KCM.SettingStateBinding {
            configObject: kcm.bellSettings
            settingName: "VisibleBellPause"
            extraEnabledConditions: kcm.bellSettings.visibleBell
        }

        value: kcm.bellSettings.visibleBellPause
        onValueModified: kcm.bellSettings.visibleBellPause = value
    }
}
