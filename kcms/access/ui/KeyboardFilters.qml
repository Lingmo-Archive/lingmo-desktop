/*
    SPDX-FileCopyrightText: 2018 Tomaz Canabrava <tcanabrava@kde.org>

    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
*/

import QtQuick 2.6
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.12 as QQC2
import org.kde.kcmutils as KCM

import org.kde.lingmoui 2.3 as LingmoUI

LingmoUI.FormLayout {
    QQC2.CheckBox {
        id: slowKeys

        LingmoUI.FormData.label: i18n("Slow keys:")
        text: i18nc("Enable slow keys", "Enable")
        
        QQC2.ToolTip {
            text: i18n("For a key to be accepted, it has to be held until the set amount of time")
        }

        KCM.SettingStateBinding {
            configObject: kcm.keyboardFiltersSettings
            settingName: "SlowKeys"
        }

        checked: kcm.keyboardFiltersSettings.slowKeys
        onToggled: kcm.keyboardFiltersSettings.slowKeys = checked
    }

    QQC2.SpinBox {
        id: slowKayDelay

        LingmoUI.FormData.label: i18nc("Slow keys Delay", "Delay:")

        KCM.SettingStateBinding {
            configObject: kcm.keyboardFiltersSettings
            settingName: "SlowKeysDelay"
            extraEnabledConditions: kcm.keyboardFiltersSettings.slowKeys
        }

        from: 100
        to: 10000

        value: kcm.keyboardFiltersSettings.slowKeysDelay
        onValueModified: kcm.keyboardFiltersSettings.slowKeysDelay = value
    }
    Item {
        LingmoUI.FormData.isSection: true
    }
    QQC2.CheckBox {
        id: slowKeysPressBeep

        LingmoUI.FormData.label: i18n("Ring system bell:")
        text: i18nc("Use system bell when a key is pressed", "when any key is &pressed")

        KCM.SettingStateBinding {
            configObject: kcm.keyboardFiltersSettings
            settingName: "SlowKeysPressBeep"
            extraEnabledConditions: kcm.keyboardFiltersSettings.slowKeys
        }

        checked: kcm.keyboardFiltersSettings.slowKeysPressBeep
        onToggled: kcm.keyboardFiltersSettings.slowKeysPressBeep = checked
    }
    QQC2.CheckBox {
        id: slowKeysAcceptBeep

        text: i18nc("Use system bell when a key is accepted", "when any key is &accepted")

        KCM.SettingStateBinding {
            configObject: kcm.keyboardFiltersSettings
            settingName: "SlowKeysAcceptBeep"
            extraEnabledConditions: kcm.keyboardFiltersSettings.slowKeys
        }

        checked: kcm.keyboardFiltersSettings.slowKeysAcceptBeep
        onToggled: kcm.keyboardFiltersSettings.slowKeysAcceptBeep = checked
    }
    QQC2.CheckBox {
        id: slowKeysRejectBeep

        text: i18nc("Use system bell when a key is rejected", "when any key is &rejected")

        KCM.SettingStateBinding {
            configObject: kcm.keyboardFiltersSettings
            settingName: "SlowKeysRejectBeep"
            extraEnabledConditions: kcm.keyboardFiltersSettings.slowKeys
        }

        checked: kcm.keyboardFiltersSettings.slowKeysRejectBeep
        onToggled: kcm.keyboardFiltersSettings.slowKeysRejectBeep = checked
    }
    Item {
        LingmoUI.FormData.isSection: true
    }
    QQC2.CheckBox {
        id: bounceKeys

        LingmoUI.FormData.label: i18n("Bounce keys:")
        text: i18nc("Bounce keys enable", "Enable");

        QQC2.ToolTip {
            text: i18n("Ignore rapid, repeated keypresses of the same key")
        }

        KCM.SettingStateBinding {
            configObject: kcm.keyboardFiltersSettings
            settingName: "BounceKeys"
        }

        checked: kcm.keyboardFiltersSettings.bounceKeys
        onToggled: kcm.keyboardFiltersSettings.bounceKeys = checked
    }

    QQC2.SpinBox {
        id: bounceKeysDelay

        LingmoUI.FormData.label: i18nc("Bounce keys delay", "Delay:")

        KCM.SettingStateBinding {
            configObject: kcm.keyboardFiltersSettings
            settingName: "BounceKeysDelay"
            extraEnabledConditions: kcm.keyboardFiltersSettings.bounceKeys
        }

        from: 100
        to: 10000

        value: kcm.keyboardFiltersSettings.bounceKeysDelay
        onValueModified: kcm.keyboardFiltersSettings.bounceKeysDelay = value
    }

    QQC2.CheckBox {
        id: bounceKeysRejectBeep

        text: i18n("Ring system bell when rejected")

        KCM.SettingStateBinding {
            configObject: kcm.keyboardFiltersSettings
            settingName: "BounceKeysRejectBeep"
            extraEnabledConditions: kcm.keyboardFiltersSettings.bounceKeys
        }

        checked: kcm.keyboardFiltersSettings.bounceKeysRejectBeep
        onToggled: kcm.keyboardFiltersSettings.bounceKeysRejectBeep = checked
    }
}
