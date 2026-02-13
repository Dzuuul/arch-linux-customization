// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html
// Modified for DedSec theme - Form positioned at bottom center

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtMultimedia

import "Components"

Pane {
    id: root

    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.ScreenWidth
    padding: config.ScreenPadding

    LayoutMirroring.enabled: config.RightToLeftLayout == "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    palette.window: config.BackgroundColor
    palette.highlight: config.HighlightBackgroundColor
    palette.highlightedText: config.HighlightTextColor
    palette.buttonText: config.HoverSystemButtonsIconsColor

    font.family: config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80) || 13
    
    focus: true

    property bool leftleft: config.HaveFormBackground == "true" &&
                            config.PartialBlur == "false" &&
                            config.FormPosition == "left" &&
                            config.BackgroundHorizontalAlignment == "left"

    property bool leftcenter: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "left" &&
                              config.BackgroundHorizontalAlignment == "center"

    property bool rightright: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "right" &&
                              config.BackgroundHorizontalAlignment == "right"

    property bool rightcenter: config.HaveFormBackground == "true" &&
                               config.PartialBlur == "false" &&
                               config.FormPosition == "right" &&
                               config.BackgroundHorizontalAlignment == "center"

    Item {
        id: sizeHelper

        height: parent.height
        width: parent.width
        anchors.fill: parent
        
        Rectangle {
            id: tintLayer

            height: parent.height
            width: parent.width
            anchors.fill: parent
            z: 1
            color: config.DimBackgroundColor
            opacity: config.DimBackground
        }

        Rectangle {
            id: formBackground

            anchors.fill: form
            anchors.centerIn: form
            z: 1

            color: config.FormBackgroundColor
            visible: config.HaveFormBackground == "true" ? true : false
            opacity: config.PartialBlur == "true" ? 0.3 : 1
        }

        LoginForm {
            id: form

            // MODIFIED: 3 block horizontal layout - lebih lebar
            height: parent.height * 0.22  // 22% tinggi untuk compact
            width: parent.width * 0.92    // 92% width untuk 3 blok horizontal
            
            // Position di bottom dengan full width spread
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 45  // Margin dari bawah
            
            z: 1
        }

        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"

            // x * 0.4 = x / 2.5
            width: config.KeyboardSize == "" ? parent.width * 0.4 : parent.width * config.KeyboardSize
            anchors.bottom: parent.bottom
            anchors.left: config.VirtualKeyboardPosition == "left" ? parent.left : undefined;
            anchors.horizontalCenter: config.VirtualKeyboardPosition == "center" ? parent.horizontalCenter : undefined;
            anchors.right: config.VirtualKeyboardPosition == "right" ? parent.right : undefined;
            z: 1
            
            state: "hidden"
            property bool keyboardActive: item ? item.active : false

            function switchState() { state = state == "hidden" ? "visible" : "hidden"}
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - virtualKeyboard.height
                        opacity: 1
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - root.height/4
                        opacity: 0
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"
                    to: "visible"
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = true;
                                Qt.inputMethod.show();
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                },
                Transition {
                    from: "visible"
                    to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                        }
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = false;
                                Qt.inputMethod.hide();
                            }
                        }
                    }
                }
            ]
        }
        
        Image {
            id: backgroundPlaceholderImage
            z: 10
            source: config.BackgroundPlaceholder
            visible: false
        }

        // Qt6 MediaPlayer untuk video
        MediaPlayer {
            id: mediaPlayer
            
            source: {
                var fileType = config.Background.substring(config.Background.lastIndexOf(".") + 1).toLowerCase()
                const videoFileTypes = ["mp4", "avi", "mov", "mkv", "m4v", "webm"]
                return videoFileTypes.includes(fileType) ? Qt.resolvedUrl(config.Background) : ""
            }
            
            loops: MediaPlayer.Infinite
            audioOutput: AudioOutput { muted: true }
            videoOutput: videoOutput
            
            Component.onCompleted: {
                if (source != "") {
                    play()
                }
            }
        }
        
        VideoOutput {
            id: videoOutput
            
            height: parent.height
            width: parent.width
            anchors.fill: parent
            
            fillMode: config.CropBackground == "true" ? VideoOutput.PreserveAspectCrop : VideoOutput.PreserveAspectFit
            
            visible: {
                var fileType = config.Background.substring(config.Background.lastIndexOf(".") + 1).toLowerCase()
                const videoFileTypes = ["mp4", "avi", "mov", "mkv", "m4v", "webm"]
                return videoFileTypes.includes(fileType)
            }
        }

        // AnimatedImage untuk GIF dan static images
        AnimatedImage {
            id: backgroundImage

            height: parent.height
            width: parent.width
            anchors.fill: parent

            source: config.Background
            
            visible: {
                var fileType = config.Background.substring(config.Background.lastIndexOf(".") + 1).toLowerCase()
                const videoFileTypes = ["mp4", "avi", "mov", "mkv", "m4v", "webm"]
                return !videoFileTypes.includes(fileType)
            }
            
            horizontalAlignment: config.BackgroundHorizontalAlignment == "left" ?
                                 Image.AlignLeft :
                                 config.BackgroundHorizontalAlignment == "right" ?
                                 Image.AlignRight : Image.AlignHCenter

            verticalAlignment: config.BackgroundVerticalAlignment == "top" ?
                               Image.AlignTop :
                               config.BackgroundVerticalAlignment == "bottom" ?
                               Image.AlignBottom : Image.AlignVCenter

            speed: config.BackgroundSpeed == "" ? 1.0 : config.BackgroundSpeed
            paused: config.PauseBackground == "true" ? 1 : 0
            fillMode: config.CropBackground == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: true
            clip: true
            mipmap: true
            playing: true
        }

        MouseArea {
            anchors.fill: parent
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask

            height: parent.height
            width: form.width
            anchors.centerIn: form

            sourceItem: videoOutput.visible ? videoOutput : backgroundImage
            sourceRect: Qt.rect(x,y,width,height)
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }

        FastBlur {
            id: blur
            
            height: parent.height

            // MODIFIED: Blur adjustment untuk bottom positioned form
            width: config.FullBlur == "true" ? parent.width : form.width 
            anchors.centerIn: config.FullBlur == "true" ? (videoOutput.visible ? videoOutput : backgroundImage) : form

            source: config.FullBlur == "true" ? (videoOutput.visible ? videoOutput : backgroundImage) : blurMask
            radius: config.BlurMax == "" ? 48 : config.BlurMax
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }
    }
}
