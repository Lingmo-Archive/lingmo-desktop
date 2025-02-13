/*
    SPDX-FileCopyrightText: 2013 Eike Hein <hein@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.lingmoui 2.19 as LingmoUI
import org.kde.lingmo.core as LingmoCore
import org.kde.lingmo.plasmoid 2.0
import org.kde.kcmutils as KCM

import org.kde.lingmo.workspace.dbus as DBus

KCM.SimpleKCM {
    property alias cfg_groupingStrategy: groupingStrategy.currentIndex
    property alias cfg_groupedTaskVisualization: groupedTaskVisualization.currentIndex
    property alias cfg_groupPopups: groupPopups.checked
    property alias cfg_onlyGroupWhenFull: onlyGroupWhenFull.checked
    property alias cfg_sortingStrategy: sortingStrategy.currentIndex
    property alias cfg_separateLaunchers: separateLaunchers.checked
    property alias cfg_hideLauncherOnStart: hideLauncherOnStart.checked
    property alias cfg_middleClickAction: middleClickAction.currentIndex
    property alias cfg_wheelEnabled: wheelEnabled.checked
    property alias cfg_wheelSkipMinimized: wheelSkipMinimized.checked
    property alias cfg_showOnlyCurrentScreen: showOnlyCurrentScreen.checked
    property alias cfg_showOnlyCurrentDesktop: showOnlyCurrentDesktop.checked
    property alias cfg_showOnlyCurrentActivity: showOnlyCurrentActivity.checked
    property alias cfg_showOnlyMinimized: showOnlyMinimized.checked
    property alias cfg_minimizeActiveTaskOnClick: minimizeActive.checked
    property alias cfg_unhideOnAttention: unhideOnAttention.checked
    property alias cfg_reverseMode: reverseMode.checked

    DBus.DBusServiceWatcher {
        id: effectWatcher
        busType: DBus.BusType.Session
        watchedService: "org.kde.KWin.Effect.WindowView1"
    }

    LingmoUI.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        ComboBox {
            id: groupingStrategy
            LingmoUI.FormData.label: i18n("Group:")
            Layout.fillWidth: true
            Layout.minimumWidth: LingmoUI.Units.gridUnit * 14
            model: [i18n("Do not group"), i18n("By program name")]
        }

        ComboBox {
            id: groupedTaskVisualization
            LingmoUI.FormData.label: i18n("Clicking grouped task:")
            Layout.fillWidth: true
            Layout.minimumWidth: LingmoUI.Units.gridUnit * 14

            enabled: groupingStrategy.currentIndex !== 0

            model: [
                i18nc("Completes the sentence 'Clicking grouped task cycles through tasks' ", "Cycles through tasks"),
                i18nc("Completes the sentence 'Clicking grouped task shows tooltip window thumbnails' ", "Shows small window previews"),
                i18nc("Completes the sentence 'Clicking grouped task shows windows side by side' ", "Shows large window previews"),
                i18nc("Completes the sentence 'Clicking grouped task shows textual list' ", "Shows textual list"),
            ]

            Accessible.name: currentText
            Accessible.onPressAction: currentIndex = currentIndex === count - 1 ? 0 : (currentIndex + 1)
        }
        // "You asked for Window View but Window View is not available" message
        LingmoUI.InlineMessage {
            Layout.fillWidth: true
            visible: groupedTaskVisualization.currentIndex === 2 && !effectWatcher.registered
            type: LingmoUI.MessageType.Warning
            text: i18n("The compositor does not support displaying windows side by side, so a textual list will be displayed instead.")
        }

        Item {
            LingmoUI.FormData.isSection: true
        }

        CheckBox {
            id: groupPopups
            visible: (Plasmoid.pluginName !== "org.kde.lingmo.icontasks")
            text: i18n("Combine into single button")
            enabled: groupingStrategy.currentIndex > 0
        }

        CheckBox {
            id: onlyGroupWhenFull
            visible: (Plasmoid.pluginName !== "org.kde.lingmo.icontasks")
            text: i18n("Group only when the Task Manager is full")
            enabled: groupingStrategy.currentIndex > 0 && groupPopups.checked
            Accessible.onPressAction: toggle()
        }

        Item {
            LingmoUI.FormData.isSection: true
            visible: (Plasmoid.pluginName !== "org.kde.lingmo.icontasks")
        }

        ComboBox {
            id: sortingStrategy
            LingmoUI.FormData.label: i18n("Sort:")
            Layout.fillWidth: true
            Layout.minimumWidth: LingmoUI.Units.gridUnit * 14
            model: [i18n("Do not sort"), i18n("Manually"), i18n("Alphabetically"), i18n("By desktop"), i18n("By activity")]
        }

        CheckBox {
            id: separateLaunchers
            visible: (Plasmoid.pluginName !== "org.kde.lingmo.icontasks")
            text: i18n("Keep launchers separate")
            enabled: sortingStrategy.currentIndex == 1
        }

        CheckBox {
            id: hideLauncherOnStart
            visible: (Plasmoid.pluginName !== "org.kde.lingmo.icontasks")
            text: i18n("Hide launchers after application startup")
        }

        Item {
            LingmoUI.FormData.isSection: true
            visible: (Plasmoid.pluginName !== "org.kde.lingmo.icontasks")
        }

        CheckBox {
            id: minimizeActive
            LingmoUI.FormData.label: i18nc("Part of a sentence: 'Clicking active task minimizes the task'", "Clicking active task:")
            text: i18nc("Part of a sentence: 'Clicking active task minimizes the task'", "Minimizes the task")
        }

        ComboBox {
            id: middleClickAction
            LingmoUI.FormData.label: i18n("Middle-clicking any task:")
            Layout.fillWidth: true
            Layout.minimumWidth: LingmoUI.Units.gridUnit * 14
            model: [
                i18nc("Part of a sentence: 'Middle-clicking any task does nothing'", "Does nothing"),
                i18nc("Part of a sentence: 'Middle-clicking any task closes window or group'", "Closes window or group"),
                i18nc("Part of a sentence: 'Middle-clicking any task opens a new window'", "Opens a new window"),
                i18nc("Part of a sentence: 'Middle-clicking any task minimizes/restores window or group'", "Minimizes/Restores window or group"),
                i18nc("Part of a sentence: 'Middle-clicking any task toggles grouping'", "Toggles grouping"),
                i18nc("Part of a sentence: 'Middle-clicking any task brings it to the current virtual desktop'", "Brings it to the current virtual desktop")
            ]
        }

        Item {
            LingmoUI.FormData.isSection: true
        }

        CheckBox {
            id: wheelEnabled
            LingmoUI.FormData.label: i18nc("Part of a sentence: 'Mouse wheel cycles through tasks'", "Mouse wheel:")
            text: i18nc("Part of a sentence: 'Mouse wheel cycles through tasks'", "Cycles through tasks")
        }

        RowLayout {
            // HACK: Workaround for LingmoUI bug 434625
            // due to which a simple Layout.leftMargin on CheckBox doesn't work
            Item { implicitWidth: LingmoUI.Units.gridUnit }
            CheckBox {
                id: wheelSkipMinimized
                text: i18n("Skip minimized tasks")
                enabled: wheelEnabled.checked
            }
        }

        Item {
            LingmoUI.FormData.isSection: true
        }

        CheckBox {
            id: showOnlyCurrentScreen
            LingmoUI.FormData.label: i18n("Show only tasks:")
            text: i18n("From current screen")
        }

        CheckBox {
            id: showOnlyCurrentDesktop
            text: i18n("From current desktop")
        }

        CheckBox {
            id: showOnlyCurrentActivity
            text: i18n("From current activity")
        }

        CheckBox {
            id: showOnlyMinimized
            text: i18n("That are minimized")
        }

        Item {
            LingmoUI.FormData.isSection: true
        }

        CheckBox {
            id: unhideOnAttention
            LingmoUI.FormData.label: i18n("When panel is hidden:")
            text: i18n("Unhide when a window wants attention")
        }

        Item {
            LingmoUI.FormData.isSection: true
        }

        ButtonGroup {
            id: reverseModeRadioButtonGroup
        }

        RadioButton {
            LingmoUI.FormData.label: i18n("New tasks appear:")
            checked: !reverseMode.checked
            text: {
                if (Plasmoid.formFactor === LingmoCore.Types.Vertical) {
                    return i18n("On the bottom")
                }
                // horizontal
                if (Qt.application.layoutDirection === Qt.LeftToRight) {
                    return i18n("To the right");
                } else {
                    return i18n("To the left")
                }
            }
            ButtonGroup.group: reverseModeRadioButtonGroup
            visible: reverseMode.visible
        }

        RadioButton {
            id: reverseMode
            checked: Plasmoid.configuration.reverseMode === true
            text: {
                if (Plasmoid.formFactor === LingmoCore.Types.Vertical) {
                    return i18n("On the Top")
                }
                // horizontal
                if (Qt.application.layoutDirection === Qt.LeftToRight) {
                    return i18n("To the left");
                } else {
                    return i18n("To the right");
                }
            }
            ButtonGroup.group: reverseModeRadioButtonGroup
        }

    }
}
