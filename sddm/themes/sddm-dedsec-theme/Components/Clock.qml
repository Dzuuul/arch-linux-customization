// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified for DedSec theme - Horizontal layout align left

import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: clock
    width: parent.width
    spacing: 8
    
    // Align semua ke kiri untuk Watch Dogs 2 style
    
    Label {
        id: headerTextLabel
        anchors.left: parent.left
        font.pointSize: root.font.pointSize * 1.5
        color: config.HeaderTextColor
        renderType: Text.QtRendering
        text: config.HeaderText
    }

    Label {
        id: timeLabel
        anchors.left: parent.left
        font.pointSize: root.font.pointSize * 6
        font.bold: true
        color: config.TimeTextColor
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(config.Locale), config.HourFormat == "long" ? Locale.LongFormat : config.HourFormat !== "" ? config.HourFormat : Locale.ShortFormat)
        }
    }

    Label {
        id: dateLabel
        anchors.left: parent.left
        
        color: config.DateTextColor
        font.pointSize: root.font.pointSize * 1.2
        font.bold: true
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toLocaleDateString(Qt.locale(config.Locale), config.DateFormat == "short" ? Locale.ShortFormat : config.DateFormat !== "" ? config.DateFormat : Locale.LongFormat)
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}
