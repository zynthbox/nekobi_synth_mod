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

import QtQuick 2.10
import QtQml 2.15
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.2 as QQC2
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import "." as Here
import Zynthian 1.0 as Zynthian
import QtGraphicalEffects 1.15

Item {
    id: root
    property bool debugMode: false
    property int knobSize: 120

    Here.DialControl {
        anchors.fill: parent
        controller {
            symbol: "tunning"
        }
    }

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
                x: 44
                y: 45
                width: 45
                height: 45
                controller {
                    symbol: "tuning"
                }
            }


            Here.SwitchControl {
                x: 143
                y: 50
                width: 19
                height:45

                controller {
                    symbol: "waveform"
                }
            }

            Here.DialControl {
                x: 187
                y: 45
                height: 45
                width: 45
                controller {
                    symbol: "cutoff"
                }
            }

            Here.DialControl {
                x: 259
                y: 45
                height: 45
                width: 45
                controller {
                    symbol: "resonance"
                }
            }

            Here.DialControl {
                x: 331
                y: 45
                height: 45
                width: 45
                controller {
                    symbol: "env_mod"
                }
            }


            Here.DialControl {
                x: 403
                y: 45
                height: 45
                width: 45
                controller {
                    symbol: "decay"
                }
            }


            Here.DialControl {
                x: 475
                y: 45
                height: 45
                width: 45
                controller {
                    symbol: "accent"
                }
            }
        }
    }
}


