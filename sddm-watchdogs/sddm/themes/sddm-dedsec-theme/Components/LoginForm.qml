// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified for DedSec theme - 3 block horizontal layout

import QtQuick 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM

RowLayout {
    id: formContainer
    spacing: 40  // Spacing antar blok
    
    SDDM.TextConstants { id: textConstants }
    
    property int p: config.ScreenPadding == "" ? 0 : config.ScreenPadding
    property string a: config.FormPosition

    // BLOK 1 - KIRI: Clock dan Header
    Clock {
        id: clock
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        Layout.preferredWidth: parent.width * 0.28  // 28% width
        Layout.leftMargin: p != "0" ? a == "left" ? -p : a == "right" ? p : 0 : 0
    }

    // BLOK 2 - TENGAH: Input Form (Username, Password, Login Button)
    ColumnLayout {
        id: loginColumn
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.preferredWidth: parent.width * 0.35  // 35% width
        spacing: 12
        
        Input {
            id: input
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: root.height / 10
            Layout.preferredWidth: parent.width
        }
    }
    
    // BLOK 3 - KANAN: Session, System Buttons, Keyboard
    ColumnLayout {
        id: controlsColumn
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        Layout.preferredWidth: parent.width * 0.25  // 25% width
        spacing: 8  // Spacing kecil untuk komponen yang berdekatan
        
        SessionButton {
            id: sessionSelect
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: root.height / 40
            Layout.maximumHeight: root.height / 40
        }
        
        VirtualKeyboardButton {
            id: virtualKeyboardButton
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: root.height / 45
            Layout.maximumHeight: root.height / 45
            Layout.topMargin: -5  // Negative margin untuk lebih dekat ke session
        }
        
        SystemButtons {
            id: systemButtons
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: root.height / 28
            Layout.maximumHeight: root.height / 28
            Layout.topMargin: 20  // Pisahkan dari keyboard/session
        }
    }
}
