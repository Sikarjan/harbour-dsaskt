/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

import "../js/storage.js" as Storage

Page {
    id: firstPage

    onStatusChanged: {
        if(status === PageStatus.Activating) {
            heroModel.clear()
            Storage.getHeros()
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Add Hero")
                onClicked: pageStack.push(Qt.resolvedUrl("AddPage.qml"))
            }
        }

        SilicaListView {
            id: heroList
            anchors.fill: parent
            model: heroModel
            VerticalScrollDecorator {}

            header: PageHeader {
                id: header
                title: qsTr("DSA SKT")
            }

            ViewPlaceholder {
                enabled: heroList.count === 0
                text: qsTr("Dear Traveller

Add a new Hero via the pull down menu. See the about page for more instructions.")
            }

            delegate: ListItem {
                id: heroItem
                menu: contextMenu
                contentHeight: Theme.itemSizeMedium // two line delegate
                ListView.onRemove: animateRemoval(heroItem)

                function remove() {
                    remorseAction(qsTr("Deleting hero"), function() {
                        Storage.deleteHero(uid)
                        heroList.model.remove(index)
                    });
                }

                onClicked: {
                    hero.heroID = uid
                    hero.heroChanged = true
                    pageStack.push(Qt.resolvedUrl("UpgradePage.qml"))
                }

                Label {
                    id: nameLabel
                    anchors {
                        left: parent.left
                        leftMargin: Theme.paddingLarge
                    }
                    text: heroName
                    font.pixelSize: Theme.fontSizeLarge
//                    color: heroItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Label {
                    anchors {
                        right: parent.right
                        rightMargin: Theme.paddingLarge
                    }
                    text: rules == 0 ? "4.1":"5.0"
                    font.pixelSize: Theme.fontSizeSmall
//                    color: heroItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Label {
                    anchors {
                        top: nameLabel.bottom
                        left: parent.left
                        leftMargin: Theme.paddingLarge
                    }
                    text: qsTr("Experience")+": "+ap
                    font.pixelSize: Theme.fontSizeMedium
 //                   color: heroItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Label {
                    anchors {
                        top: nameLabel.bottom
                        right: parent.right
                        rightMargin: Theme.paddingLarge
                    }
                    text: qsTr("Used")+": "+usedAp
                    font.pixelSize: Theme.fontSizeMedium
 //                   color: heroItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Component{
                    id: contextMenu
                    ContextMenu {
                        MenuItem {
                            text: qsTr("Delete hero")
                            onClicked: remove()
                        }
                    }
                }
            }
        }
    }
}

