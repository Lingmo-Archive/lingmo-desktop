/*
    SPDX-FileCopyrightText: 2019 Aleix Pol Gonzalez <aleixpol@kde.org>

    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
*/

import QtQuick
import QtQuick.Layouts
import org.kde.lingmoui as LingmoUI
import QtQuick.Controls as QQC2
import org.kde.lingmo.emoji

LingmoUI.ScrollablePage {
    id: view

    property alias model: emojiModel.sourceModel
    property string searchText: ""
    property alias category: filter.category
    property bool showSearch: false
    property bool showClearHistoryButton: false

    leftPadding: undefined
    rightPadding: undefined
    horizontalPadding: 0

    Keys.onPressed: event => {
        if (event.key == Qt.Key_Escape) {
            Qt.quit()
        }
        if (event.text.length > 0 && !view.showSearch && event.modifiers === Qt.NoModifier) {
            // We want to prevent unprintable characters like backspace
            model = emoji
            searchText += /[\x00-\x1F\x7F]/.test(event.text) ? "" : event.text
            showSearch = true
            title = i18n("Search")
            category = ""
        }
    }

    titleDelegate: RowLayout {
        Layout.fillWidth: true
        Layout.preferredWidth: view.width

        LingmoUI.Heading {
            text: view.title
            textFormat: Text.PlainText
            Layout.fillWidth: true
        }

        LingmoUI.SearchField {
            id: searchField
            Layout.fillWidth: true
            text: view.searchText
            visible: view.showSearch
            inputMethodHints: Qt.ImhNoPredictiveText

            Keys.onEnterPressed: event => Keys.returnPressed(event)
            Keys.onReturnPressed: event => {
                if (emojiView.count > 0) {
                    emojiView.itemAtIndex(0).Keys.returnPressed(event);
                }
            }
            onTextChanged: {
                forceActiveFocus()
                emojiModel.search = text
                if (emojiView.currentIndex < 0) {
                    Qt.callLater(function() {
                        emojiView.currentIndex = 0
                    })
                }
            }
            Component.onCompleted: {
                if (visible) {
                    Qt.callLater(forceActiveFocus);
                }
            }
            Keys.onEscapePressed: event => {
                if (text) {
                    clear()
                } else {
                    Qt.quit()
                }
            }
            Keys.forwardTo: emojiView
        }

        QQC2.ToolButton {
            visible: view.showClearHistoryButton
            text: i18n("Clear History")
            icon.name: "edit-clear-history"
            onClicked: {
                recentEmojiModel.clearHistory();
            }
        }
    }

    Shortcut {
        sequences: [StandardKey.Copy]
        enabled: emojiView.currentItem
        onActivated: {
            emojiView.currentItem.Keys.returnPressed(null)
        }
    }

    Component {
        id: menuComponent

        QQC2.Menu {
            required property Text label

            onClosed: destroy()

            QQC2.MenuItem {
                icon.name: "edit-copy"
                text: i18nc("@item:inmenu", "Copy Character")
                onClicked: {
                    CopyHelper.copyTextToClipboard(label.text);
                    window.showPassiveNotification(i18n("%1 copied to the clipboard", label.text));
                }
            }
            QQC2.MenuItem {
                icon.name: "edit-copy"
                text: i18nc("@item:inmenu", "Copy Description")
                onClicked: {
                    CopyHelper.copyTextToClipboard(label.QQC2.ToolTip.text);
                    window.showPassiveNotification(i18n("%1 copied to the clipboard", label.QQC2.ToolTip.text));
                }
            }
        }
    }

    GridView {
        id: emojiView

        readonly property real desiredSize: LingmoUI.Units.gridUnit * 3
        readonly property int columnsToHave: Math.ceil(width / desiredSize)
        readonly property int delayInterval: Math.min(300, columnsToHave * 10)

        cellWidth: width / columnsToHave
        cellHeight: desiredSize

        model: CategoryModelFilter {
            id: filter
            sourceModel: SearchModelFilter {
                id: emojiModel
            }
        }

        currentIndex: -1
        reuseItems: true

        delegate: QQC2.Label {
            id: emojiLabel

            width: emojiView.cellWidth
            height: emojiView.cellHeight

            font.pointSize: 25
            font.family: 'emoji' // Avoid monochrome fonts like DejaVu Sans
            fontSizeMode: model.display.length > 5 ? Text.Fit : Text.FixedSize
            minimumPointSize: 10
            text: model.display
            textFormat: Text.PlainText
            horizontalAlignment: Text.AlignHCenter

            Accessible.name: model.toolTip
            Accessible.onPressAction: tapHandler.tapped(null, null)

            QQC2.ToolTip.delay: LingmoUI.Units.toolTipDelay
            QQC2.ToolTip.text: model.toolTip
            QQC2.ToolTip.visible: hoverHandler.hovered

            opacity: hoverHandler.hovered ? 0.7 : 1
            scale: tapHandler.pressed ? 0.6 : 1

            Keys.onMenuPressed: event => contextMenuHandler.tapped(null, null)
            Keys.onReturnPressed: event => tapHandler.tapped(null, null)

            HoverHandler {
                id: hoverHandler
            }

            TapHandler {
                id: tapHandler
                onTapped: (eventPoint, button) => {
                    window.report(model.display, model.toolTip);
                }
            }

            TapHandler {
                acceptedButtons: Qt.LeftButton
                acceptedDevices: PointerDevice.TouchScreen | PointerDevice.Stylus
                onLongPressed: contextMenuHandler.tapped(null, null)
            }

            TapHandler {
                id: contextMenuHandler
                acceptedButtons: Qt.RightButton
                onTapped: (eventPoint, button) => {
                    const menu = menuComponent.createObject(emojiLabel, {
                        "label": emojiLabel,
                    });
                    menu.popup();
                }
            }

            Behavior on opacity {
                OpacityAnimator {
                    duration: LingmoUI.Units.longDuration
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: LingmoUI.Units.longDuration
                }
            }
        }

        LingmoUI.PlaceholderMessage {
            anchors.centerIn: parent
            width: parent.width - (LingmoUI.Units.largeSpacing * 8)
            text: i18n("No recent Emojis")
            visible: emojiView.count === 0 && view.showClearHistoryButton
        }
    }
}
