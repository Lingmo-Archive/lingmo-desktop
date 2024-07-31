/*
    SPDX-FileCopyrightText: 2020 David Redondo <david@david-redondo.de>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.lingmoui as LingmoUI
import org.kde.kquickcontrols
import org.kde.kcmutils as KCM

QQC2.ItemDelegate {
    id: root

    property bool showExpandButton: true

    readonly property bool selected: highlighted || down

    highlighted: false
    // If it's the only one in the list, clicking it won't do anything, so don't provide any visual feedback.
    hoverEnabled: showExpandButton
    down: showExpandButton ? undefined : false

    width: shortcutsList.width
    action: QQC2.Action {
        id: expandAction
        onTriggered: {
            shortcutsList.selectedIndex = (root.state === "expanded") ? -1 : index;
        }
    }
    Accessible.name: root.state === "expanded" ? i18n("Editing shortcut: %1", displayLabel.text) : displayLabel.text + keySequenceList.text
    contentItem: ColumnLayout {
        clip: true

        LingmoUI.Theme.textColor: root.selected ? root.LingmoUI.Theme.highlightedTextColor : undefined
        LingmoUI.Theme.inherit: !root.selected

        spacing: LingmoUI.Units.smallSpacing

        Item {
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: topRow.implicitHeight
            Layout.fillWidth: true
            RowLayout {
                id: topRow
                anchors.fill: parent
                spacing: LingmoUI.Units.smallSpacing
                LingmoUI.Heading {
                    id: displayLabel
                    text: i18nc("%1 is the name action that is triggered by the key sequences following after :", "%1:", model.display)
                    textFormat: Text.PlainText
                    level: 5
                }
                QQC2.Label {
                    id: keySequenceList
                    Layout.fillWidth: true

                    color: {
                        if (root.selected) {
                            return LingmoUI.Theme.highlightedTextColor;
                        } else if (model?.activeShortcuts?.length !== 0) {
                            return LingmoUI.Theme.textColor;
                        } else {
                            return LingmoUI.Theme.disabledTextColor;
                        }
                    }

                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignRight
                    text: {
                        if (model?.activeShortcuts?.length !== 0) {
                            return model?.activeShortcuts?.map(s => kcm.keySequenceToString(s)).join(", ")
                        } else {
                            return i18n("No active shortcuts")
                        }
                    }
                    textFormat: Text.PlainText
                }
                Rectangle {
                    id: defaultIndicator
                    radius: width * 0.5
                    implicitWidth: LingmoUI.Units.largeSpacing
                    implicitHeight: LingmoUI.Units.largeSpacing
                    visible: kcm.defaultsIndicatorsVisible
                    opacity: !model.isDefault
                    color: LingmoUI.Theme.neutralTextColor
                }
                QQC2.ToolButton {
                    Layout.alignment: Qt.AlignRight
                    id: expandButton
                    visible: root.showExpandButton
                    icon.name: "expand"
                    activeFocusOnTab: false
                    onClicked: expandAction.trigger()
                }
            }
        }
        Loader {
            id: editLoader
            active: false
            visible: false
            Layout.fillWidth: true
            sourceComponent: RowLayout {
                readonly property var originalIndex : {
                    const concatenatedIndex = kcm.filteredModel.mapToSource(dm.modelIndex(index))
                    return kcm.shortcutsModel.mapToSource(concatenatedIndex)
                }
                spacing: 0

                ColumnLayout {
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: parent.width * 0.5
                    spacing: LingmoUI.Units.smallSpacing
                    LingmoUI.Heading {
                        level: 4
                        text: model.defaultShortcuts &&  model.defaultShortcuts.length !== 0 ?
                            i18ncp("%1 decides if singular or plural will be used", "Default shortcut",
                            "Default shortcuts", model.defaultShortcuts.length) :
                            i18n("No default shortcuts")
                        textFormat: Text.PlainText
                    }
                    LingmoUI.Separator {
                        Layout.fillWidth: true
                    }
                    Repeater {
                        model: defaultShortcuts
                        QQC2.CheckBox {
                            Accessible.name: checked ? i18n("Default shortcut %1 is enabled.", modelData) : i18n("Default shortcut %1 is disabled.", modelData)
                            checked: activeShortcuts.indexOf(modelData) !== -1
                            text: modelData
                            onToggled: {
                                if (checked) {
                                     kcm.requestKeySequence(this, originalIndex, modelData)
                                } else {
                                    originalIndex.model.disableShortcut(originalIndex, modelData)
                                }
                            }
                            KCM.SettingHighlighter {
                                highlight: !checked
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignTop | Qt.AlignRight
                    spacing: LingmoUI.Units.smallSpacing
                    LingmoUI.Heading {
                        level: 4
                        Layout.alignment: Qt.AlignRight
                        text: i18n("Custom shortcuts")
                        textFormat: Text.PlainText
                    }
                    LingmoUI.Separator {
                        Layout.fillWidth: true
                    }
                    Repeater {
                        model: customShortcuts
                        RowLayout {
                            spacing: LingmoUI.Units.smallSpacing
                            Layout.alignment: Qt.AlignRight
                            KeySequenceItem {
                                Layout.alignment: Qt.AlignRight
                                keySequence: modelData
                                showClearButton: false
                                modifierOnlyAllowed: true
                                multiKeyShortcutsAllowed: supportsMultipleKeys
                                checkForConflictsAgainst: ShortcutType.None
                                onCaptureFinished: {
                                    kcm.requestKeySequence(this, originalIndex, keySequence, modelData)
                                }
                                KCM.SettingHighlighter {
                                    highlight: true
                                }
                            }
                            QQC2.Button {
                                Accessible.name: i18nc("@action:button accessible", "Delete shortcut")
                                icon.name: "edit-delete"
                                onClicked: originalIndex.model.disableShortcut(originalIndex, modelData)
                                QQC2.ToolTip {
                                    text: i18nc("@info:tooltip", "Delete this shortcut")
                                }
                            }
                        }
                    }
                    QQC2.Button {
                        text: i18nc("@action:button Add custom shortcut", "Add…")
                        Accessible.name: i18nc("@action:button accessible", "Add custom shortcut")
                        icon.name: "list-add-symbolic"
                        Layout.alignment: Qt.AlignRight
                        onClicked: {
                            this.visible = false
                            var newKeySequenceItem = newKeySequenceComponent.createObject(parent)
                            for (var i = 0; i < newKeySequenceItem.children.length; i++) {
                                if (newKeySequenceItem.children[i] instanceof KeySequenceItem) {
                                    var keySequenceItem = newKeySequenceItem.children[i]
                                }
                            }
                            newKeySequenceItem.finished.connect(() => {
                                newKeySequenceItem.destroy()
                                this.visible = true
                            })
                            keySequenceItem.startCapturing()
                        }
                    }
                    Component {
                        id: newKeySequenceComponent
                        RowLayout {
                            signal finished
                            Layout.alignment: Qt.AlignRight
                            spacing: LingmoUI.Units.smallSpacing
                            KeySequenceItem {
                                showClearButton: false
                                modifierOnlyAllowed: true
                                multiKeyShortcutsAllowed: model.supportsMultipleKeys
                                checkForConflictsAgainst: ShortcutType.None
                                onCaptureFinished: {
                                    kcm.requestKeySequence(this, originalIndex, keySequence)
                                    parent.finished()
                                }
                            }
                            QQC2.Button {
                                Accessible.name: i18nc("@action:button accessible", "Cancel capturing shortcut")
                                icon.name: "dialog-cancel"
                                onClicked: parent.finished()
                                QQC2.ToolTip {
                                    text: i18nc("@info:tooltip", "Cancel capturing of new shortcut")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    states: [
        State {
            name: "expanded"
            when: shortcutsList.selectedIndex === index || shortcutsList.count == 1
            PropertyChanges {
                target: root
                hoverEnabled: false
            }
            PropertyChanges {
                target: displayLabel
                level: 3
                Layout.fillWidth: true
            }
            PropertyChanges {
                target: keySequenceList
                visible: false
            }
            PropertyChanges {
                target: expandButton
                icon.name: "collapse"
            }
            PropertyChanges {
                target: editLoader
                active: true
                visible: true
            }
        }
    ]
    Behavior on height {
        NumberAnimation {
            properties: "height"
            duration: LingmoUI.Units.shortDuration
        }
    }
}
