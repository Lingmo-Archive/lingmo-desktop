/*
    SPDX-FileCopyrightText: 2022 Méven Car <meven@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.lingmoui as LingmoUI
import org.kde.kcmutils as KCM

LingmoUI.OverlaySheet {
    id: root

    property QtObject componentChooser

    // type: list<string>
    property var unsupportedMimeTypes: componentChooser?.unsupportedMimeTypes ?? []
    // type: list<{ first, second }>
    property var mimeTypesNotAssociated: componentChooser?.mimeTypesNotAssociated ?? []

    function sanitize(input: string): string {
        // Based on QQuickStyledTextPrivate::parseEntity
        const table = {
            '>': '&gt;',
            '<': '&lt;',
            '&': '&amp;',
            "'": '&apos;',
            '"': '&quot;',
            '\u00a0': '&nbsp;',
        };
        return input.replace(/[<>&'"\u00a0]/g, c => table[c]);
    }

    function formatListItem(item: string): string {
        return "<li>" + sanitize(item) + "</li>";
    }

    function formatHtmlUnorderedStringList(list: list<string>): string {
        return "<ul>" + list.map(formatListItem).join("\n") + "</ul>";
    }

    onOpened: {
        focus = true;
    }

    onClosed: {
        componentChooser = null;
    }

    title: i18n("Details")

    modal: true
    QQC2.Overlay.modal: KcmPopupModal {}

    ColumnLayout {
        enabled: root.componentChooser !== null
        spacing: LingmoUI.Units.smallSpacing
        Layout.preferredWidth: LingmoUI.Units.gridUnit * 25

        RowLayout {
            Layout.fillWidth: true
            spacing: LingmoUI.Units.largeSpacing

            LingmoUI.Icon {
                Layout.preferredWidth: LingmoUI.Units.iconSizes.large
                Layout.preferredHeight: LingmoUI.Units.iconSizes.large
                source: root.componentChooser?.applicationIcon()
            }

            LingmoUI.Heading {
                text: root.componentChooser?.applicationName() ?? ""
                textFormat: Text.PlainText
                level: 1
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }
        }

        LingmoUI.Heading {
            text: i18n("This application can also open these file types:")
            textFormat: Text.PlainText
            visible: root.mimeTypesNotAssociated.length > 0
            level: 3
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.bottomMargin: LingmoUI.Units.largeSpacing
        }
        LingmoUI.SelectableLabel {
            visible: root.mimeTypesNotAssociated.length > 0
            text: root.formatHtmlUnorderedStringList(
                root.mimeTypesNotAssociated.map(
                    ({first, second}) => i18nc(
                        "@label %1 is a MIME type and %2 is an application name",
                        "%1 (Currently opens in %2)",
                        second,
                        first,
                    )
                )
            )
            Layout.fillWidth: true
        }
        QQC2.Button {
            visible: root.mimeTypesNotAssociated.length > 0
            icon.name: root.componentChooser?.applicationIcon() ?? ""
            text: i18nc(
                "@action:button %1 is an application name",
                "Open All in %1",
                root.componentChooser?.applicationName() ?? ""
            )
            Layout.topMargin: LingmoUI.Units.largeSpacing
            onClicked: {
                root.close();
                root.componentChooser.saveMimeTypesNotAssociated();
            }
        }

        LingmoUI.Separator {
            // extra double-spacing
            Layout.fillWidth: true
            Layout.margins: LingmoUI.Units.largeSpacing
            visible: root.unsupportedMimeTypes.length > 0
                && root.mimeTypesNotAssociated.length > 0
        }

        LingmoUI.Heading {
            text: i18n("This application does not advertise support for the following file types, but may be able to open them anyway:")
            textFormat: Text.PlainText
            visible: root.unsupportedMimeTypes.length > 0
            level: 3
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.bottomMargin: LingmoUI.Units.largeSpacing
        }
        LingmoUI.SelectableLabel {
            visible: root.unsupportedMimeTypes.length > 0
            text: root.formatHtmlUnorderedStringList(root.unsupportedMimeTypes)
            Layout.fillWidth: true
        }
        QQC2.Button {
            visible: root.unsupportedMimeTypes.length > 0
            icon.name: root.componentChooser?.applicationIcon() ?? ""
            text: root.componentChooser
                ? i18nc("@action:button", "Force All to Open in %1", root.componentChooser.applicationName())
                : ""
            Layout.topMargin: LingmoUI.Units.largeSpacing
            onClicked: {
                root.close();
                root.componentChooser.saveAssociationUnsuportedMimeTypes();
            }
        }

        QQC2.Button {
            Layout.topMargin: LingmoUI.Units.largeSpacing
            icon.name: "configure-symbolic"
            text: i18n("Configure Manually…")
            visible: root.componentChooser !== null
            onClicked: {
                root.close();
                KCM.KCMLauncher.openSystemSettings("kcm_filetypes");
            }
        }
    }
}
