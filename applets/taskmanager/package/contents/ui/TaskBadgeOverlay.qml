/*
    SPDX-FileCopyrightText: 2016 Kai Uwe Broulik <kde@privat.broulik.de>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.graphicaleffects as KGraphicalEffects
import org.kde.lingmo.plasmoid 2.0

Item {
    id: root

    readonly property int iconWidthDelta: (icon.width - icon.paintedWidth) / 2
    readonly property bool shiftBadgeDown: (Plasmoid.pluginName === "org.kde.lingmo.icontasks") && task.audioStreamIcon !== null

    Item {
        id: badgeMask
        anchors.fill: parent

        Rectangle {
            readonly property int offset: Math.round(Math.max(LingmoUI.Units.smallSpacing / 2, badgeMask.width / 32))

            anchors.right: parent.right
            anchors.rightMargin: -offset
            y: root.shiftBadgeDown ? (icon.height / 2) : 0

            Behavior on y {
                NumberAnimation { duration: LingmoUI.Units.longDuration }
            }

            visible: task.smartLauncherItem.countVisible
            width: badgeRect.width + offset * 2
            height: badgeRect.height + offset * 2
            radius: badgeRect.radius + offset * 2

            // Badge changes width based on number.
            onWidthChanged: maskShaderSource.scheduleUpdate()
            onVisibleChanged: maskShaderSource.scheduleUpdate()
            onYChanged: maskShaderSource.scheduleUpdate()
        }
    }

    ShaderEffectSource {
        id: iconShaderSource
        sourceItem: icon
        hideSource: GraphicsInfo.api !== GraphicsInfo.Software
    }

    ShaderEffectSource {
        id: maskShaderSource
        sourceItem: badgeMask
        hideSource: true
        live: false
    }

    KGraphicalEffects.BadgeEffect {
        id: shader

        anchors.fill: parent
        source: iconShaderSource
        mask: maskShaderSource

        onWidthChanged: maskShaderSource.scheduleUpdate()
        onHeightChanged: maskShaderSource.scheduleUpdate()
    }

    Badge {
        id: badgeRect

        anchors.right: parent.right
        y: {
            const offset = Math.round(Math.max(LingmoUI.Units.smallSpacing / 2, badgeMask.width / 32));
            return offset + (root.shiftBadgeDown ? (icon.height / 2) : 0);
        }

        Behavior on y {
            NumberAnimation { duration: LingmoUI.Units.longDuration }
        }

        height: Math.round(parent.height * 0.4)
        visible: task.smartLauncherItem.countVisible
        number: task.smartLauncherItem.count
    }
}
