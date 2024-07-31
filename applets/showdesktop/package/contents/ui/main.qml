/*
    SPDX-FileCopyrightText: 2014 Ashish Madeti <ashishmadeti@gmail.com>
    SPDX-FileCopyrightText: 2016 Kai Uwe Broulik <kde@privat.broulik.de>
    SPDX-FileCopyrightText: 2022 ivan (@ratijas) tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.1

import org.kde.lingmo.core as LingmoCore
import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.ksvg 1.0 as KSvg

import org.kde.lingmo.plasmoid 2.0

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    toolTipSubText: activeController.description

    Plasmoid.icon: Plasmoid.configuration.icon
    Plasmoid.title: activeController.title
    Plasmoid.onActivated: activeController.toggle();

    Plasmoid.backgroundHints: LingmoCore.Types.NoBackground

    Layout.minimumWidth: LingmoUI.Units.iconSizes.medium
    Layout.minimumHeight: LingmoUI.Units.iconSizes.medium

    Layout.maximumWidth: Layout.minimumWidth
    Layout.maximumHeight: Layout.minimumHeight

    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

    readonly property bool inPanel: [LingmoCore.Types.TopEdge, LingmoCore.Types.RightEdge, LingmoCore.Types.BottomEdge, LingmoCore.Types.LeftEdge]
            .includes(Plasmoid.location)

    readonly property bool vertical: Plasmoid.location === LingmoCore.Types.RightEdge || Plasmoid.location === LingmoCore.Types.LeftEdge

    /**
    * @c true if the current applet is Minimize All, @c false if the
    * current applet is Show Desktop.
    */
    readonly property bool isMinimizeAll: Plasmoid.pluginName === "org.kde.lingmo.minimizeall"

    readonly property Controller primaryController: isMinimizeAll ? minimizeAllController : peekController

    readonly property Controller activeController: {
        if (minimizeAllController.active) {
            return minimizeAllController;
        } else if (peekController.active) {
            return peekController;
        } else {
            return primaryController;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        activeFocusOnTab: true
        hoverEnabled: true

        onClicked: Plasmoid.activated();

        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Space:
            case Qt.Key_Enter:
            case Qt.Key_Return:
            case Qt.Key_Select:
                Plasmoid.activated();
                break;
            }
        }

        Accessible.name: Plasmoid.title
        Accessible.description: toolTipSubText
        Accessible.role: Accessible.Button
        Accessible.onPressAction: Plasmoid.activated()

        PeekController {
            id: peekController
        }

        MinimizeAllController {
            id: minimizeAllController
        }

        LingmoUI.Icon {
            anchors.fill: parent
            active: mouseArea.containsMouse || activeController.active
            source: Plasmoid.icon
        }

        // also activate when dragging an item over the plasmoid so a user can easily drag data to the desktop
        DropArea {
            anchors.fill: parent
            onEntered: activateTimer.start()
            onExited: activateTimer.stop()
        }

        Timer {
            id: activateTimer
            interval: 250 // to match TaskManager
            onTriggered: Plasmoid.activated()
        }

        // Active/not active indicator
        KSvg.FrameSvgItem {
            Accessible.name: i18n("Minimize All Applet Active Indicator")
            property var containerMargins: {
                let item = this;
                while (item.parent) {
                    item = item.parent;
                    if (item.isAppletContainer) {
                        return item.getMargins;
                    }
                }
                return undefined;
            }

            anchors {
                fill: parent
                property bool returnAllMargins: true
                // The above makes sure margin is returned even for side margins
                // that would be otherwise turned off.
                topMargin: !vertical && containerMargins ? -containerMargins('top', returnAllMargins) : 0
                leftMargin: vertical && containerMargins ? -containerMargins('left', returnAllMargins) : 0
                rightMargin: vertical && containerMargins ? -containerMargins('right', returnAllMargins) : 0
                bottomMargin: !vertical && containerMargins ? -containerMargins('bottom', returnAllMargins) : 0
            }
            imagePath: "widgets/tabbar"
            visible: opacity > 0
            prefix: {
                let prefix;
                switch (Plasmoid.location) {
                case LingmoCore.Types.LeftEdge:
                    prefix = "west-active-tab";
                    break;
                case LingmoCore.Types.TopEdge:
                    prefix = "north-active-tab";
                    break;
                case LingmoCore.Types.RightEdge:
                    prefix = "east-active-tab";
                    break;
                default:
                    prefix = "south-active-tab";
                }
                if (!hasElementPrefix(prefix)) {
                    prefix = "active-tab";
                }
                return prefix;
            }
            opacity: activeController.active ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: LingmoUI.Units.shortDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }

        LingmoCore.ToolTipArea {
            id: toolTip
            anchors.fill: parent
            mainText: Plasmoid.title
            subText: toolTipSubText
            textFormat: Text.PlainText
        }
    }

    Plasmoid.contextualActions: [
        LingmoCore.Action {
            text: minimizeAllController.titleInactive
            checkable: true
            checked: minimizeAllController.active
            toolTip: minimizeAllController.description
            enabled: !peekController.active
            onTriggered: minimizeAllController.toggle()
        },
        LingmoCore.Action {
            text: peekController.titleInactive
            checkable: true
            checked: peekController.active
            toolTip: peekController.description
            enabled: !minimizeAllController.active
            onTriggered: peekController.toggle()
        }
    ]
}
