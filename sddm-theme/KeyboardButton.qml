/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2022 Aleix Pol Gonzalez <aleixpol@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.15

import org.kde.lingmo.components 3.0 as LingmoComponents
import org.kde.lingmoui 2.20 as LingmoUI

LingmoComponents.ToolButton {
    id: root

    property int currentIndex: keyboard.currentLayout
    onCurrentIndexChanged: keyboard.currentLayout = currentIndex

    text: i18nd("lingmo-desktop-sddm-theme", "Keyboard Layout: %1", keyboard.layouts[currentIndex]?.longName ?? "")
    visible: keyboard.layouts.length > 1

    checkable: true
    checked: menu.opened
    onToggled: {
        if (checked) {
            menu.popup(root, 0, 0)
        } else {
            menu.dismiss()
        }
    }

    signal keyboardLayoutChanged()

    LingmoComponents.Menu {
        id: menu
        LingmoUI.Theme.colorSet: LingmoUI.Theme.Window
        LingmoUI.Theme.inherit: false

        onAboutToShow: {
            if (instantiator.model === null) {
                let layouts = keyboard.layouts;
                layouts.sort((a, b) => a.longName.localeCompare(b.longName));
                instantiator.model = layouts;
            }
        }

        Instantiator {
            id: instantiator
            model: null
            onObjectAdded: (index, object) => menu.insertItem(index, object)
            onObjectRemoved: (index, object) => menu.removeItem(object)
            delegate: LingmoComponents.MenuItem {
                text: modelData.longName
                onTriggered: {
                    keyboard.currentLayout = keyboard.layouts.indexOf(modelData)
                    root.keyboardLayoutChanged()
                }
            }
        }
    }
}
