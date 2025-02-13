/*
    SPDX-FileCopyrightText: 2013 Aurélien Gâteau <agateau@kde.org>
    SPDX-FileCopyrightText: 2014-2015 Eike Hein <hein@kde.org>
    SPDX-FileCopyrightText: 2021 Mikel Johnson <mikel5764@gmail.com>
    SPDX-FileCopyrightText: 2021 Noah Davis <noahadvs@gmail.com>
    SPDX-FileCopyrightText: 2024 ivan tkachenko <me@ratijas.tk>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound
pragma Singleton // NOTE: Singletons are shared between all instances of a plasmoid

import QtQuick
import org.kde.lingmo.core as LingmoCore
import org.kde.lingmo.plasmoid
import org.kde.lingmo.extras as LingmoExtras
import "code/tools.js" as Tools

Item {
    id: root

    property var actionList: null

    // Only one action menu can be open at a time, so this should be safe to use.
    property PlasmoidItem plasmoid: null

    // Not a QQC1 Menu. It's actually a custom QObject that uses a QMenu.
    readonly property LingmoExtras.Menu menu: LingmoExtras.Menu {
        id: menu

        visualParent: null
        placement: LingmoExtras.Menu.BottomPosedLeftAlignedPopup
    }

    visible: false

    Instantiator {
        active: root.actionList !== null
        model: root.actionList
        delegate: menuItemComponent
        onObjectAdded: (index, object) => menu.addMenuItem(object)
        onObjectRemoved: (index, object) => menu.removeMenuItem(object)
    }

    Component {
        id: menuComponent

        LingmoExtras.Menu {}
    }

    Component {
        id: menuItemComponent

        LingmoExtras.MenuItem {
            id: menuItem

            required property var modelData
            readonly property LingmoExtras.Menu subMenu: modelData.subActions
                ? menuComponent.createObject(this, { visualParent: action })
                : null

            text: modelData.text ?? ""
            enabled: modelData.type !== "title" && (modelData.enabled ?? true)
            separator: modelData.type === "separator"
            section: modelData.type === "title"
            icon: modelData.icon ?? null
            checkable: modelData.checkable ?? false
            checked: modelData.checked ?? false

            readonly property Instantiator __instantiator: Instantiator {
                active: menuItem.subMenu !== null
                model: menuItem.modelData.subActions
                delegate: menuItemComponent
                onObjectAdded: (index, object) => menuItem.subMenu.addMenuItem(object)
                onObjectRemoved: (index, object) => menuItem.subMenu.removeMenuItem(object)
            }

            onClicked: {
                const modelActionTriggered = Tools.triggerAction(
                    menu.visualParent.view.model,
                    menu.visualParent.index,
                    modelData.actionId,
                    modelData.actionArgument
                )
                if (modelActionTriggered) {
                    kickoff.expanded = false
                }
            }
        }
    }
}
