/*   vim:set foldmethod=marker:

    SPDX-FileCopyrightText: 2014 Ivan Cukic <ivan.cukic(at)kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.2
import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.activities 0.1 as Activities

import org.kde.lingmo.activityswitcher as ActivitySwitcher

Flickable {
    id: root

    // contentWidth: content.width
    contentHeight: content.height

    property var    model: ActivitySwitcher.Backend.runningActivitiesModel()
    property string filterString: ""
    property bool   showSwitcherOnly: false

    property int itemsWidth: 0

    property int selectedIndex: -1

    function _selectRelativeToCurrent(distance)
    {
        var startingWithSelected = selectedIndex;

        do {
            selectedIndex += distance;

            if (selectedIndex >= activitiesList.count) {
                selectedIndex = 0;
            }

            if (selectedIndex < 0) {
                selectedIndex = activitiesList.count - 1;
            }

            // Searching for the first item that is visible, or back to the one
            // that we started with
        } while (!activitiesList.itemAt(selectedIndex).visible
                        && startingWithSelected !== selectedIndex);

        _updateSelectedItem();

    }

    function selectNext()
    {
        _selectRelativeToCurrent(1);
    }

    function selectPrevious()
    {
        _selectRelativeToCurrent(-1);
    }

    function _updateSelectedItem()
    {
        for (var i = 0; i < activitiesList.count; i++) {
            activitiesList.itemAt(i).selected = (i === selectedIndex);
        }
    }

    function openSelected()
    {
        var selectedItem = null;

        if (selectedIndex >= 0 && selectedIndex < activitiesList.count) {
            selectedItem = activitiesList.itemAt(selectedIndex);

        } else if (root.filterString != "") {
            // If we have only one item shown, activate it. It doesn't matter
            // that it is not really selected

            for (var i = 0; i < activitiesList.count; i++) {
                var item = activitiesList.itemAt(i);

                if (item.visible) {
                    selectedItem = item;
                    break;
                }
            }
        }

        if (selectedItem !== null) {
            ActivitySwitcher.Backend.setCurrentActivity(selectedItem.activityId);
        }
    }

    Column {
        id: content

        // width: root.width - (root.width % 10)
        width: root.itemsWidth
        spacing: LingmoUI.Units.smallSpacing * 2

        // Running activities

        Repeater {
            id: activitiesList

            model: ActivitySwitcher.Backend.runningActivitiesModel()

            ActivityItem {

                width:  content.width

                visible      : (root.filterString == "") ||
                               (title.toLowerCase().indexOf(root.filterString) != -1)

                activityId   : model.id
                title        : model.name
                icon         : model.iconSource
                background   : model.background
                current      : model.isCurrent
                hasWindows   : model.hasWindows
                innerPadding : 2 * LingmoUI.Units.smallSpacing
                stoppable    : activitiesList.count > 1

                onClicked    : {
                    ActivitySwitcher.Backend.setCurrentActivity(model.id);
                }
            }
        }

        // Stopped activities

        Item {
            // spacer
            width  : parent.width
            height : LingmoUI.Units.gridUnit
        }

        LingmoUI.Heading {
            id: stoppedActivitiesHeading

            text: i18nd("lingmo_shell_org.kde.lingmo.desktop", "Stopped activities:")
            textFormat: Text.PlainText
            level: 3
            visible: !root.showSwitcherOnly && stoppedActivitiesList.count > 0
        }

        Repeater {
            id: stoppedActivitiesList

            model: root.showSwitcherOnly ? null : ActivitySwitcher.Backend.stoppedActivitiesModel()

            delegate: StoppedActivityItem {
                id: stoppedActivityItem

                width:  parent.width

                visible      : (root.filterString == "") ||
                               (title.toLowerCase().indexOf(root.filterString) != -1)

                activityId   : model.id
                title        : model.name
                icon         : model.iconSource
                innerPadding : 2 * LingmoUI.Units.smallSpacing

                onClicked: {
                    ActivitySwitcher.Backend.setCurrentActivity(model.id)
                }
            }
        }

        Item {
            // spacer
            width  : parent.width
            height : LingmoUI.Units.gridUnit * 2

            visible: stoppedActivitiesHeading.visible
        }

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: -100
                duration: LingmoUI.Units.shortDuration
            }
        }

        move: Transition {
            NumberAnimation {
                id: animation
                properties: "y"
                duration: LingmoUI.Units.longDuration
            }
        }
    }
}

