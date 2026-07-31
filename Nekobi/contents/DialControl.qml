/* -*- coding: utf-8 -*-
******************************************************************************
ZYNTHIAN PROJECT: Zynthian Qt GUI

Main Class and Program for Zynthian GUI

Copyright (C) 2021 Marco Martin <mart@kde.org>

******************************************************************************

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of
the License, or any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

For a full copy of the GNU General Public License see the LICENSE.txt file.

******************************************************************************
*/

import QtQuick 2.15
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.4 as Kirigami
import io.zynthbox.ui 1.0 as ZUI2
import "." as Here
import QtGraphicalEffects 1.15

ZUI2.AbstractController {
    id: root

    // property alias valueLabel: valueLabel.text
    property alias value: dial.value
    property alias from: dial.from
    property alias to: dial.to
    property alias stepSize: dial.stepSize
    property alias snapMode: dial.snapMode
    property alias dial: dial
    property Item knobControl: dial
    property bool highlighted : false

    // Physical KNOB0 position 0..1 for the pick-up diamond (fixed-pot hardware only); -1 hides it.
    property real knobPositionNormalised: -1
    // Current value as a 0..1 fraction (the knob's "seek" target for the pick-up system).
    readonly property real seekNormalised: (controller.ctrl && controller.ctrl.max_value > controller.ctrl.value0)
        ? (controller.ctrl.value - controller.ctrl.value0) / (controller.ctrl.max_value - controller.ctrl.value0) : 0
    // Fixed pot (Z2_V5B): map a 0..1 absolute position onto the parameter's range.
    function setValueAbsolute(v) {
        if (controller.ctrl)
            controller.ctrl.value = controller.ctrl.value0
                + Math.max(0, Math.min(1, v)) * (controller.ctrl.max_value - controller.ctrl.value0)
    }

    implicitWidth: 45
    implicitHeight: 45

    property color highlightColor : "#5765f2"
    property color backgroundColor: "#fafafa"
    property color foregroundColor: "#fafafa"
    property color alternativeColor :  "#16171C"

    signal tapped()


    background: Item {


        TapHandler {
            onTapped: root.tapped()
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -4
            color: "transparent"
            border.color: "white"
            border.width: 2
            visible: root.activeFocus
        }
    }

    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    contentItem:  Item {

        QQC2.Dial {
            id: dial

            anchors.fill: parent
            inputMode: QQC2.Dial.Vertical
            stepSize: root.controller.ctrl ? (root.controller.ctrl.step_size === 0 ? 1 : root.controller.ctrl.step_size) : 0
            from: root.controller.ctrl ? root.controller.ctrl.value0 : 0
            to: root.controller.ctrl ? root.controller.ctrl.max_value : 0

            property bool shouldClick: false
            property var mostRecentClickTime: 0
            onMoved: {
                shouldClick = false;
                if (root.controller && root.controller.ctrl) {
                    root.controller.ctrl.value = value;
                }
            }
            onPressedChanged: {
                if (pressed) {
                    shouldClick = true;
                } else {
                    shouldClick = false;
                    let thisClickTime = Date.now();
                    if (thisClickTime - mostRecentClickTime < 300) {
                        if (root.controller && root.controller.ctrl) {
                            root.controller.ctrl.value = root.controller.ctrl.value_default;
                        }
                        root.doubleClicked();
                    } else {
                        root.clicked();
                    }
                    mostRecentClickTime = thisClickTime;
                }
                root.pressedChanged(pressed);
            }

            handle: Rectangle {
                id: handleItem
                x: dial.background.x + dial.background.width / 2 - width / 2
                y: dial.background.y + dial.background.height / 2 - height / 2
                width: 6
                height: 16
                color: dial.pressed ? root.highlightColor : root.foregroundColor
                border.color: Qt.darker(root.alternativeColor, 2)
                radius: 8
                antialiasing: true
                opacity: dial.enabled ? 1 : 0.3
                transform: [
                    Translate {
                        y: -Math.min(dial.background.width, dial.background.height) * 0.4 + handleItem.height / 2
                    },
                    Rotation {
                        angle: dial.angle
                        origin.x: handleItem.width / 2
                        origin.y: handleItem.height / 2
                    }
                ]
            }

            background: Item {}
        }


        Binding {
            target: dial
            property: "value"
            value: root.controller.ctrl ? root.controller.ctrl.value : 0
        }

        // Pick-up diamond: physical KNOB0 position on the dial arc (fixed-pot hardware only).
        // QQC2.Dial spans -140°..+140° (default); 0° = up, clockwise positive.
        Rectangle {
            visible: root.knobPositionNormalised >= 0
            width: 9; height: 9; radius: 2; rotation: 45
            antialiasing: true
            color: "white"
            border.color: root.highlightColor; border.width: 2
            z: 10
            readonly property real ang: (-140 + root.knobPositionNormalised * 280) * Math.PI / 180
            readonly property real rad: Math.min(dial.width, dial.height) * 0.4
            x: dial.width / 2  + rad * Math.sin(ang) - width / 2
            y: dial.height / 2 - rad * Math.cos(ang) - height / 2
        }
    }

}
