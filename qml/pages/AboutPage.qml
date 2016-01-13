import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    Column {
        id: column

        anchors {
            fill: parent
            margins: Theme.paddingLarge
        }
        spacing: Theme.paddingLarge
        PageHeader {
            title: qsTr("About DSA SKT")
        }

        Label {
            text: "Version: 0.2"
        }

        Text {
            font.pixelSize: Theme.fontSizeSmall
            width: column.width
            color: Theme.primaryColor
            wrapMode: Text.Wrap
            text: qsTr("This app calculates the APs required to upgrade a skill, spell or attribute. The used cost table is based on the the rule set 4.1.

To undo and upgrade delete the upgarde from the log list.")
        }

        Text {
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            textFormat: Text.RichText
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
            text: qsTr("Please send me an email for feedback or improvement ideas:")
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("Get in touch");
            onClicked: {
                Qt.openUrlExternally("mailto:store@innobiz.de");
            }
        }
    }
}
