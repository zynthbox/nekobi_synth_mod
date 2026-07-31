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

import "." as Here
import QtGraphicalEffects 1.15
import QtQml 2.15
import QtQuick 2.10
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Layouts 1.4
import io.zynthbox.ui 1.0 as Zynthian
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    property bool debugMode: false
    property int knobSize: 120
    property int focusIndex: 0
    readonly property var focusOrder: [control1, control2, control3, control4, control5, control6, control7]

    // ── Both-encoder support (endless encoders + the Z2_V5B fixed pots) ───────────────
    // kit_version isn't exposed to QML, so we detect fixed pots by receiving a KNOB*_ABSOLUTE
    // event (only Z2_V5B sends those). Used only to decide whether to show the pick-up diamond.
    property bool hasFixedEncoders: false
    // The Controls page reads a mod's `seekValues` to drive Relative/Jump/Pick-up. seekValues[0] =
    // the focused control's position (KNOB0's target); knobs 1/2 unused (-1 = Jump). Refresh on
    // focus change (the CONTROL changing), not on value change.
    property var seekValues: []
    onFocusIndexChanged: refreshSeek()
    function refreshSeek() {
        var c = focusOrder[focusIndex]
        var v0 = (c && c.seekNormalised !== undefined) ? c.seekNormalised : undefined
        root.seekValues = [v0, -1, -1]
    }
    // Physical KNOB0 position for the control at focus index `idx` (or -1 to hide its diamond).
    function knobPosFor(idx) {
        return (root.focusIndex === idx && root.hasFixedEncoders
                && zynqtgui.globalKnobs && zynqtgui.globalKnobs.length > 0)
            ? zynqtgui.globalKnobs[0].valueNormalised : -1
    }

    property var cuiaCallback: function cuiaCallback(cuia, originId, track, slot, value) {
        switch (cuia) {
        case "SELECT_UP":
        case "SELECT_DOWN":
            if (focusIndex === focusOrder.length - 1)
                focusIndex = 0;
            else
                focusIndex++;
            return true;
        case "NAVIGATE_LEFT":
        case "NAVIGATE_RIGHT":
            if (focusIndex === 0)
                focusIndex = focusOrder.length - 1;
            else
                focusIndex--;
            return true;
        case "KNOB0_UP":
            // focusOrder[focusIndex].increaseValue()
            focusOrder[focusIndex].knobControl.increase();
            return true;
        case "KNOB0_DOWN":
            // focusOrder[focusIndex].decreaseValue()
            focusOrder[focusIndex].knobControl.decrease();
            return true;
        // Fixed pot (Z2_V5B): absolute position → mapped onto the focused control's range.
        case "KNOB0_ABSOLUTE":
            root.hasFixedEncoders = true;
            focusOrder[focusIndex].setValueAbsolute(value);
            return true;
        case "KNOB1_ABSOLUTE":
        case "KNOB2_ABSOLUTE":
            root.hasFixedEncoders = true;
            return true;
        case "KNOB1_UP":
        case "KNOB1_DOWN":
        case "KNOB2_UP":
        case "KNOB2_DOWN":
            return true;
        case "KNOB3_UP":
            if (focusIndex === focusOrder.length - 1)
                focusIndex = 0;
            else
                focusIndex++;
            focusOrder[focusIndex].forceActiveFocus();
            return true;
        case "KNOB3_DOWN":
            if (focusIndex === 0)
                focusIndex = focusOrder.length - 1;
            else
                focusIndex--;
            focusOrder[focusIndex].forceActiveFocus();
            return true;
        case "SWITCH_SELECT_SHORT":
        case "SWITCH_SELECT_BOLD":
            return true;
        default:
            return false;
        }
    }

    Component.onCompleted: { focusOrder[focusIndex].forceActiveFocus(); refreshSeek() }

    Image {
        source: "tail.png"
        anchors.bottom: _control.top
        anchors.right: _control.right
        anchors.rightMargin: 20
        anchors.bottomMargin: -6
    }

    QQC2.Control {
        id: _control

        enabled: zynqtgui.curlayerEngineId != null
        height: _imgBg.paintedHeight
        width: _imgBg.paintedWidth
        anchors.centerIn: parent
        padding: 0

        background: Item {
            Image {
                id: _imgBg

                source: "background.png"
                // width: parent.width
                fillMode: Image.PreserveAspectFit
            }
        }

        contentItem: Item {
            Here.DialControl {
                id: control1

                x: 44
                y: 45
                width: 45
                height: 45
                onTapped: {
                    focusIndex = 0;
                    focusOrder[focusIndex].forceActiveFocus();
                }

                knobPositionNormalised: root.knobPosFor(0)
                controller {
                    symbol: "tuning"
                }
            }

            Here.SwitchControl {
                id: control2

                x: 143
                y: 50
                width: 19
                height: 45

                controller {
                    symbol: "waveform"
                }

            }

            Here.DialControl {
                id: control3

                x: 187
                y: 45
                height: 45
                width: 45

                knobPositionNormalised: root.knobPosFor(2)
                controller {
                    symbol: "cutoff"
                }

            }

            Here.DialControl {
                id: control4

                x: 259
                y: 45
                height: 45
                width: 45

                knobPositionNormalised: root.knobPosFor(3)
                controller {
                    symbol: "resonance"
                }

            }

            Here.DialControl {
                id: control5

                x: 331
                y: 45
                height: 45
                width: 45

                knobPositionNormalised: root.knobPosFor(4)
                controller {
                    symbol: "env_mod"
                }

            }

            Here.DialControl {
                id: control6

                x: 403
                y: 45
                height: 45
                width: 45

                knobPositionNormalised: root.knobPosFor(5)
                controller {
                    symbol: "decay"
                }

            }

            Here.DialControl {
                id: control7

                x: 475
                y: 45
                height: 45
                width: 45

                knobPositionNormalised: root.knobPosFor(6)
                controller {
                    symbol: "accent"
                }

            }

        }

    }

}
