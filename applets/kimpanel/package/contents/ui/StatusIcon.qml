/*
    SPDX-FileCopyrightText: 2014 Weng Xuetian <wengxt@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.lingmo.plasmoid 2.0
import org.kde.lingmo.core as LingmoCore
import org.kde.lingmo.components 3.0 as LingmoComponents3
import org.kde.kquickcontrolsaddons 2.0
import org.kde.lingmoui 2.20 as LingmoUI

Item {
    id: statusIcon
    property string icon;
    property string label;
    property string tip;
    property string hint;
    signal triggered(variant button);
    property int iconSize: LingmoUI.Units.iconSizes.roundedIconSize(Math.min(width, height))

    opacity: 'disable' == hint ? 0.3 : 1

    function extractLabelString(l) {
        if (l.length >= 2 && l.charCodeAt(0) < 127 && l.charCodeAt(1) < 127) {
            return l.substring(0, 2);
        } else {
             return l.substring(0, 1);
        }
    }

    LingmoUI.Icon {
        id: imageIcon
        anchors.centerIn: parent
        width: iconSize
        height: iconSize
        scale: mouseArea.pressed ? 0.9 : 1
        source: statusIcon.icon
        visible: statusIcon.icon.length > 0
        animated: false
        // active: mouseArea.containsMouse
    }
    LingmoComponents3.Label {
        id: textIcon
        anchors.centerIn: parent
        width: iconSize
        height: iconSize
        scale: (mouseArea.pressed ? 0.9 : 1)
        // a reasonable large size to make Text.Fit work
        minimumPointSize: 0
        font.pointSize: 1024
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: extractLabelString(label)
        textFormat: Text.PlainText
        visible: icon.length == 0
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            statusIcon.triggered(mouse.button);
        }

        LingmoCore.ToolTipArea {
            anchors.fill: parent
            mainText: statusIcon.label
            subText: statusIcon.tip
            icon: statusIcon.icon
        }
    }
}
