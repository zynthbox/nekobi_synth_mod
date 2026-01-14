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
import io.zynthbox.ui 1.0 as Zynthian
import "." as Here
import QtGraphicalEffects 1.15

Zynthian.AbstractController {
    id: root

    property alias control: switchControl

    implicitWidth: 45
    implicitHeight: 45

    property color highlightColor : "#5765f2"
    property color backgroundColor: "#fafafa"
    property color foregroundColor: "#fafafa"
    property color alternativeColor :  "#16171C"
    property Item knobControl: switchControl
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

        QQC2.AbstractButton {
            id: switchControl
            anchors.fill: parent
            checkable: true
            checked: root.controller.ctrl && root.controller.ctrl.value !== root.controller.ctrl.value0
            onClicked: root.controller.ctrl.value = checked ? root.controller.ctrl.max_value : root.controller.ctrl.value0
            // Explicitly set indicator implicitWidth otherwise the switch size is too small
            padding: 0
            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0
            background: Item{

                Image {
                    source: "slider.png"
                    x: -10
                    y: switchControl.checked ? parent.height-height +10 : -10
                }

            }


            function increase() {
                root.controller.ctrl.value = root.controller.ctrl.max_value
            }

            function decrease() {
                root.controller.ctrl.value = root.controller.ctrl.value0
            }
        }
    }

}
