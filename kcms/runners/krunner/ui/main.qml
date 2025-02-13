/*
    SPDX-FileCopyrightText: 2022 Fushan Wen <qydwhotmail@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2

import org.kde.lingmoui 2.19 as LingmoUI
import org.kde.kcmutils as KCM
import org.kde.config as KConfig

import org.kde.lingmo.runners.kcm

KCM.SimpleKCM {
    id: root

    implicitWidth: LingmoUI.Units.gridUnit * 32
    implicitHeight: LingmoUI.Units.gridUnit * 18

    LingmoUI.FormLayout {
        width: parent.width
        anchors.top: parent.top

        QQC2.ButtonGroup {
            id: positionGroup
        }

        QQC2.RadioButton {
            LingmoUI.FormData.label: i18n("Position on screen:")
            onToggled: kcm.krunnerSettings.freeFloating = false
            checked: !kcm.krunnerSettings.freeFloating
            QQC2.ButtonGroup.group: positionGroup
            text: i18n("Top")
        }

        QQC2.RadioButton {
            checked: kcm.krunnerSettings.freeFloating
            onToggled: kcm.krunnerSettings.freeFloating = true
            QQC2.ButtonGroup.group: positionGroup
            text: i18n("Center")

            KCM.SettingStateBinding {
                configObject: kcm.krunnerSettings
                settingName: "freeFloating"
            }
        }

        Item {
            LingmoUI.FormData.isSection: false
        }

        QQC2.CheckBox {
            LingmoUI.FormData.label: i18n("Activation:")
            checked: kcm.krunnerSettings.activateWhenTypingOnDesktop
            onToggled: kcm.krunnerSettings.activateWhenTypingOnDesktop = checked
            text: i18nc("@option:check", "Activate when pressing any key on the desktop")

            KCM.SettingStateBinding {
                configObject: kcm.krunnerSettings
                settingName: "activateWhenTypingOnDesktop"
            }
        }

        Item {
            LingmoUI.FormData.isSection: false
        }

        QQC2.RadioButton {
            LingmoUI.FormData.label: i18n("History:")
            checked: kcm.krunnerSettings.historyBehavior === KRunnerSettings.Disabled
            onToggled: kcm.krunnerSettings.historyBehavior = KRunnerSettings.Disabled
            text: i18nc("@option:check", "Disabled")
        }
        QQC2.RadioButton {
            checked: kcm.krunnerSettings.historyBehavior === KRunnerSettings.CompletionSuggestion
            onToggled: kcm.krunnerSettings.historyBehavior = KRunnerSettings.CompletionSuggestion
            text: i18nc("@option:check The thing being enabled is search history", "Enable suggestions")
        }
        QQC2.RadioButton {
            checked: kcm.krunnerSettings.historyBehavior === KRunnerSettings.ImmediateCompletion
            onToggled: kcm.krunnerSettings.historyBehavior = KRunnerSettings.ImmediateCompletion
            text: i18nc("@option:check The thing being enabled is search history", "Enabled auto-complete")
        }

        QQC2.Button {
            id: clearHistoryButton
            enabled: kcm.krunnerSettings.historyBehavior !== KRunnerSettings.Disabled && kcm.historyKeys.length > 0

            icon.name: Qt.application.layoutDirection === Qt.LeftToRight ? "edit-clear-locationbar-ltr" : "edit-clear-locationbar-rtl"
            text: i18n("Clear History…")

            checked: activityMenu.visible

            // NOTE: Use onReleased to avoid race condition
            onReleased: {
                if (!activityList.model) {
                    activityList.model = Qt.createQmlObject("import org.kde.activities 0.1; ActivityModel {}", root); // Lazy load
                }

                if (activityMenu.visible) {
                    activityMenu.close();
                } else {
                    activityMenu.popup(x, y + implicitHeight);
                }
            }
        }

        QQC2.Menu {
            id: activityMenu

            QQC2.MenuItem {
                icon.name: clearHistoryButton.icon.name
                text: i18nc("@item:inmenu delete krunner history for all activities", "For all activities")

                onTriggered: kcm.deleteAllHistory()
            }

            Repeater {
                id: activityList

                QQC2.MenuItem {
                    enabled: kcm.historyKeys.includes(model.id)

                    icon.source: model.iconSource
                    text: i18nc("@item:inmenu delete krunner history for this activity", "For activity \"%1\"", model.name)

                    onTriggered: kcm.deleteHistoryGroup(model.id)
                }
            }
        }

        Item {
            visible: pluginButton.visible
            LingmoUI.FormData.isSection: false
        }

        Loader {
            id: pluginButton
            active: kcm.doesShowPluginButton
            visible: active

            LingmoUI.FormData.label: i18nc("@label", "Plugins:")

            sourceComponent: QQC2.Button {
                enabled: KConfig.KAuthorized.authorizeControlModule("kcm_krunnersettings")
                text: i18nc("@action:button", "Configure Enabled Search Plugins…")
                icon.name: "settings-configure"

                onClicked: KCM.KCMLauncher.openSystemSettings("kcm_lingmosearch")
            }
        }
    }
}
