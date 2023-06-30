import QtQuick
import QtQuick.Controls.Material
import trans
import Qt.labs.settings
import model

MenuBar {
    id:menubar
    focusPolicy: Qt.NoFocus

    Settings{
        category: "view"
        fileName: "baiboly.ini"
        property alias currentLang:translator.lang
    }

    MTranslator{
        id:translator
        onLangChanged: {
            translator.swicthLanguage(translator.lang)
            getBook()
            sidebar.getActual()
            read()
        }
    }

    function updateRecents(){

        for(var j=0;j<recents.length;j++){
            menuRecent.removeAction(menuRecent.actionAt(j+1))
            var bookIndex = recents[j][0]==="0" ? recents[j][1] : recents[j][0]+recents[j][1]
            var chap = recents[j][2] ==="0"? recents[j][3] : recents[j][2]+recents[j][3]
            var verse = recents[j][4] ==="0"? recents[j][5] : recents[j][4]+recents[j][5]

            var component = Qt.createComponent("BAction.qml")
            var obj;
            if  (component.status === Component.Ready){
                obj = component.createObject(menuRecent,{book:bookIndex,chap:chap,verse:verse});
                menuRecent.insertAction(j+1,obj)
            }
        }

    }

    function getBook(){
        loadBook(langId)
    }

    Menu{

        title:qsTr("Menu")
        Action{text:qsTr("Search verses")}
        Menu{
            id:menuRecent
            title:qsTr("Recent verses")

            Action{
                text: qsTr("Clear story")
                onTriggered:{
                    for(var j=0;j<recents.length;j++){
                        menuRecent.removeAction(menuRecent.actionAt(j+1))
                    }
                    verseRepo.clear()
                }
            }

        }
        Menu{title:qsTr("Best verses")}
        Menu{
            title:qsTr("Language")
            ActionGroup{
                id:langGroup
            }

            Action{
                id:enAction
                text:"Engilsh"
                checkable: true
                checked:translator.lang == "en_US" ? true : false
                onTriggered:{
                    sidebar.setActual()
                    langId = 1
                    translator.lang = "en_US"
                }
                ActionGroup.group: langGroup
            }
            Action{
                id:frAction
                text:"Français"
                checkable: true
                checked:translator.lang == "fr_FR" ? true : false
                onTriggered:{
                    sidebar.setActual()
                    langId = 2
                    translator.lang = "fr_FR"
                }
                ActionGroup.group: langGroup
            }
            Action{
                id:mgAction
                text:"Malagasy"
                checkable: true
                checked:translator.lang == "mg_MG" ? true : false
                onTriggered:{
                    sidebar.setActual()
                    langId = 0
                    translator.lang = "mg_MG"
                }
                ActionGroup.group: langGroup
            }
        }

        MenuSeparator{}

        Action{
            text:qsTr("Quit")
            onTriggered: {
                Qt.exit(1)
            }
            shortcut: "Ctrl+Q"
        }

    }
    Menu{
        title:qsTr("Help")
        Action{
            text:qsTr("About Qt")
        }
        Action{
            text:qsTr("About Baiboly")
            onTriggered: {
                aboutPopup.open()
            }
        }
    }

    delegate: MenuBarItem {
        id: menuBarItem

        contentItem: Text{
            text: menuBarItem.text
            font: menuBarItem.font
            opacity: enabled ? 1.0 : 0.3
            color: menuBarItem.highlighted ? "#ffffff" : "#ffffff"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideNone

        }

        background: Rectangle {
            implicitWidth: 20
            implicitHeight: 20
            opacity: enabled ? 1 : 0.3
            color: menuBarItem.highlighted ? "#303030" : "transparent"
        }
    }

    background: Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        color: "#424242"

        BToolBar{
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

//        Button{
//            text:qsTr("Baiboly")
//            icon.source: "qrc:/assets/images/bible4.ico"
//            anchors.left: parent.left
//            flat: true
//            Material.background: "transparent"
//            icon.color: "transparent"
//        }

//        Button{
//            id:minimizeBtn
//            text:"__"
//            font.pointSize: 10
//            anchors.right: maximizeBtn.left
//            anchors.verticalCenter: parent.verticalCenter
//            Material.background: closeBtn.hovered? "#424242" : "#424242"
//            flat:true
//            onClicked: {

//                window.showMinimized()
//            }
//        }

//        Button{
//            id:maximizeBtn
//            text:window.visibility == Window.Maximized ? "] [" :"[ ]"
//            font.pointSize: 10
//            anchors.right: closeBtn.left
//            anchors.verticalCenter: parent.verticalCenter
//            Material.background: closeBtn.hovered? "#424242" : "#424242"
//            flat:true
//            onClicked: {
//                if(window.visibility == Window.Maximized) {

//                    window.showNormal()
//                }
//                else{

//                    window.showMaximized()
//                }
//            }
//        }

//        Button{
//            id:closeBtn
//            text:"X"
//            font.pointSize: 10
//            anchors.right: parent.right
//            anchors.verticalCenter: parent.verticalCenter
//            Material.background: closeBtn.hovered? "red" : "#424242"
//            flat:true
//            onClicked: {
//               Qt.exit(1)
//            }

//        }

    }


}


