import QtQuick
import QtQuick.Controls

Window {
    id: window
    width:400
    height:400
    flags: Qt.Dialog
    title: qsTr("Remote controller")


    property bool started



    Button {
        id: closeRemoteDialogBtn

        width:75
        height:50
        text: qsTr("Close")
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        Material.background: "red"
        Material.foreground: "white"
        font.pointSize: 10
        onClicked: {
            window.close()
        }
    }

    Button{
        id:toggleRemoteBtn
        width:75
        height:50
        text: toggleRemoteBtn.checked? qsTr("Stop") : qsTr("Start")
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        font.pointSize: 10
        checkable: true
        Material.accent: "blue"
        onClicked: {
            started = toggleRemoteBtn.checked
        }
    }

    Grid {
        id: grid
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        rows: 2
        columns: 2
        spacing: 10
        padding: 20

        Button{
            text:qsTr("Ip Address:")
            font.pointSize: 15
        }

        Button{
            id:ipTextField
            text:"192.168.167.1"
            font.pointSize: 15
        }
        Button{
            text:qsTr("Port")
            font.pointSize: 15
        }

        TextField{
            id:portTextField
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 15
            layer.enabled: false

        }
    }


}
