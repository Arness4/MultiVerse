import QtQuick
import QtQuick.Controls.Material 2.12
import Qt.labs.settings

Item{
    id:toolbar

    Settings{
        category: "view"
        fileName: "baiboly.ini"
        property alias fontSize: fontSizeSpinBox.value
        property alias fontFamily: fontFamilyComboBox.currentIndex
        property alias bold: boldBtn.checked
        property alias italic: italicBtn.checked
    }

    Button{
        id:boldBtn
        width: 40
        height: 40
        text:"B"
        font.family: "Arial"
        font.bold: true
        font.pointSize: 20
        checkable: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: window.width/5 + 20
        onToggled: ()=>{
                       verse_text.font.bold = boldBtn.checked
                   }
        focusPolicy: Qt.NoFocus
        //Material.accent: "blue"
    }
    Button{
        id:italicBtn
        width: 40
        height: 40
        text:"I"
        font.family: "Arial"
        font.italic: true
        font.pointSize: 20
        checkable: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: boldBtn.right
        anchors.leftMargin: 10
        onToggled: ()=>{
                       verse_text.font.italic = italicBtn.checked
                   }
        focusPolicy: Qt.NoFocus
        //Material.accent: "blue"
    }
    ComboBox{
        id:fontFamilyComboBox
        width: sidebar.width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: italicBtn.right
        anchors.leftMargin: 10
        model: Qt.fontFamilies()
        onEditTextChanged: {
            verse_text.font.family = fontFamilyComboBox.editText
        }
        focusPolicy: Qt.NoFocus
    }
    SpinBox{
        id:fontSizeSpinBox
        width: sidebar.width
        anchors.left: fontFamilyComboBox.right
        anchors.leftMargin: 10
        from: 6
        to: 100
        anchors.verticalCenter: parent.verticalCenter
        onValueChanged: {
            verse_text.font.pointSize = fontSizeSpinBox.value
        }
        value:30
        focusPolicy: Qt.NoFocus
    }

    Button{
        id:bestVerseBtn
        icon.source: "qrc:/assets/images/star.png"
        icon.color: "white"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: remoteBtn.left
        anchors.rightMargin: 20
        Material.background: "transparent"
        checkable: true
        Material.accent: "transparent"
        focusPolicy: Qt.NoFocus
    }

    Button{
        id: remoteBtn
        text: qsTr("Remote")
        checkable: true
        checked: remoteDialog.started
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: liveBtn.left
        anchors.rightMargin: 10
        onClicked: {
            remoteBtn.checked
            remoteDialog.show()

        }
        focusPolicy: Qt.NoFocus
        //Material.accent: "blue"
    }


    Button{
        id: liveBtn
        property bool isChecked: false
        icon.source: "qrc:/assets/images/live_off.png"
        icon.color: "transparent"
        text: qsTr("Live")
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        enabled: Application.screens.length > 1 ? true : false
        onClicked: {
            isChecked = !isChecked
            if(isChecked){

                for(var i=1;i<Application.screens.length;i++){
                    var component = Qt.createComponent("../windows/Live.qml")
                    var obj;
                    if  (component.status === Component.Ready){
                        obj = component.createObject(window,{screen:Application.screens[i]})
                    }
                    lives.push(obj)
                    obj.visibility = Window.FullScreen
                    var sc = Application.screens[i]
                    updateBg()
                    obj.setGeometry(sc.virtualX,sc.virtualY,sc.width,sc.height)
                    liveAnim.start()
                }
            }else{
                liveAnim.stop()
                var s=lives.length-1;
                while(lives.length !==0){
                    lives[s].close()
                    lives.length-=1
                    s-=1
                }
            }
        }
        focusPolicy: Qt.NoFocus

        SequentialAnimation{
            id:liveAnim
            loops: Animation.Infinite
            PropertyAnimation {
                target: liveBtn
                property: "icon.source"
                from: "qrc:/assets/images/live.png"
                to: "qrc:/assets/images/live_off.png"
                duration:500
            }
            PropertyAnimation {
                target: liveBtn
                property: "icon.source"
                to: "qrc:/assets/images/live.png"
                from: "qrc:/assets/images/live_off.png"
                duration:500
            }
        }

    }
}
