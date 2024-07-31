/*
    SPDX-FileCopyrightText: 2024 Evgeny Chesnokov <echesnokov@astralinux.ru>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.lingmoui as LingmoUI
import org.kde.kitemmodels as KItemModels
import org.kde.kcmutils as KCM

ColumnLayout {
    spacing: LingmoUI.Units.smallSpacing

    Connections {
        target: kcm.xkbOptionsModel

        function onNavigateTo(index): void {
            let modelIndex = xkbOptionsProxy.mapFromSource(index)
            treeView.expand(modelIndex.row)
            treeView.positionViewAtIndex(modelIndex, Qt.AlignCenter)
            treeView.forceActiveFocus()
        }
    }

    KItemModels.KSortFilterProxyModel {
        id: xkbOptionsProxy
        sourceModel: kcm?.xkbOptionsModel ?? undefined

        sortRoleName: "display"
        sortOrder: Qt.AscendingOrder
    }

    QQC2.CheckBox {
        id: configureOptionsCheckbox

        text: i18nc("@option:checkbox", "Configure keyboard options")
        checked: kcm.keyboardSettings.resetOldXkbOptions
        onToggled: kcm.keyboardSettings.resetOldXkbOptions = checked

        KCM.SettingStateBinding {
            configObject: kcm.keyboardSettings
            settingName: "resetOldXkbOptions"
        }
    }

    QQC2.ScrollView {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Component.onCompleted: {
            if (background) {
                background.visible = true
            }
        }

        TreeView {
            id: treeView
            boundsBehavior: Flickable.StopAtBounds
            alternatingRows: false
            clip: true
            enabled: configureOptionsCheckbox.checked

            onEnabledChanged: {
                if (!enabled) {
                    for (let i in rows) {
                        collapse(i)
                    }
                }
            }

            columnWidthProvider: column => {
                switch (column) {
                case 0:
                    return width;
                default:
                    return 0;
                }
            }

            model: xkbOptionsProxy

            delegate: QQC2.TreeViewDelegate {
                id: delegate

                // you can't use a CheckDelegate as a TreeViewDelegate. This nests the buttons and is pretty bad for accessible
                contentItem: RowLayout {
                    spacing: LingmoUI.Units.smallSpacing

                    QQC2.CheckBox {
                        id: checkbox
                        tristate: delegate.isTreeNode && delegate.hasChildren
                        checkState: model.checkState
                        onToggled: model.checkState = checkState

                        KCM.SettingHighlighter {
                            highlight: model.checkState !== Qt.Unchecked
                        }
                    }

                    QQC2.Label {
                        Layout.fillWidth: true
                        text: model.display
                    }
                }

                onClicked: {
                    if (delegate.isTreeNode && delegate.hasChildren) {
                        treeView.toggleExpanded(row)
                    } else {
                        model.checkState = checkbox.checkState === Qt.Checked ? Qt.Unchecked : Qt.Checked
                    }
                }
            }
        }
    }
}
