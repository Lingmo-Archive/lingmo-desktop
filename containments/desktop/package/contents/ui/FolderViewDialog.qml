/*
    SPDX-FileCopyrightText: 2014-2015 Eike Hein <hein@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15

import org.kde.lingmo.plasmoid 2.0
import org.kde.lingmo.core as LingmoCore
import org.kde.lingmoui 2.20 as LingmoUI

import org.kde.private.desktopcontainment.folder 0.1 as Folder

Folder.SubDialog {
    id: dialog

    visible: false

    property bool containsDrag: {
        if (folderViewDropArea.containsDrag) {
            return true;
        }

        if (folderView.hoveredItem && folderView.hoveredItem.popupDialog) {
            return folderView.hoveredItem.popupDialog.containsDrag;
        }

        return false;
    }

    property QtObject closeTimer: closeTimer
    property QtObject childDialog: (folderView.hoveredItem !== null) ? folderView.hoveredItem.popupDialog : null
    property bool containsMouse: folderView.containsMouse || (childDialog !== null && childDialog.containsMouse)

    property alias url: folderView.url

    location: LingmoCore.Types.Floating
    hideOnWindowDeactivate: (childDialog === null)

    onContainsMouseChanged: {
        if (containsMouse) {
            closeTimer.stop();
        } else {
            closeTimer.start();
        }
    }

    mainItem: FolderViewDropArea {
        id: folderViewDropArea

        width: folderView.cellWidth * 3 + LingmoUI.Units.gridUnit // FIXME HACK: Use actual scrollbar width.
        height: folderView.cellHeight * 2

        folderView: folderView

        FolderView {
            id: folderView

            anchors.fill: parent

            isRootView: false
            dialog: dialog

            locked: true

            sortMode: ((Plasmoid.configuration.sortMode === 0) ? 1 : Plasmoid.configuration.sortMode)
            filterMode: 0

            // TODO: Bidi.
            flow: GridView.FlowLeftToRight
            layoutDirection: Qt.LeftToRight

            onDragInProgressAnywhereChanged: {
                if (!dragInProgressAnywhere && !dialog.visible) {
                    dialog.destroy();
                }
            }
        }
    }

    data: [
        Timer {
            id: closeTimer

            interval: LingmoUI.Units.longDuration * 2

            onTriggered: {
                if (childDialog !== null) {
                    childDialog.closeTimer.stop();
                    childDialog.visible = false;
                }

                dialog.visible = false;
                delayedDestroy();
            }
        }
    ]

    function requestDestroy() {
        if (folderView.dragInProgressAnywhere) {
            visible = false;
        } else {
            destroy();
        }
    }

    function delayedDestroy() {
        Qt.callLater(() => itemDialog.destroy());
    }

    Component.onDestruction: {
        closeTimer.stop();
    }
}
