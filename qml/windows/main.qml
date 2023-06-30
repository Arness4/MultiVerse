import QtQuick.Controls.Material
import QtQuick
import QtMultimedia
import Qt.labs.settings
import QtQuick.Dialogs
import "../component"
import "qrc:/assets/js/values.js" as Values
import model

ApplicationWindow {
    id:window
    minimumWidth: 1000
    minimumHeight: 650
    visible: true
    visibility: Window.Maximized
    title: qsTr("MultiVerse")
    Material.theme: Material.Dark
    Material.accent: "yellow"
    menuBar: BMenuBar{id:menubar}
    property string bgSrc
    property var books
    property int langId
    property list<Live> lives
    property var recents : verseRepo.getAll()
    property var ba: BAction{}

    FileDialog{
        id:mediaChooserDialog
        acceptLabel: qsTr("Choose background")
        rejectLabel: qsTr("Cancel")
        nameFilters: [qsTr("Media Files (*.mp4 *.avi *.jpg *.jpeg *.png)")]
        options: FileDialog.ReadOnly
        fileMode: FileDialog.OpenFile
        onAccepted: {
            bgSrc = selectedFile
            updateBg()
        }
    }


    onRecentsChanged: {
        menubar.updateRecents()
    }

    VerseRepo{
        id:verseRepo
    }

    Popup{
        id:aboutPopup
        width: 300
        height:300
        Text{
            text:qsTr("Baiboly")
            font.pointSize: 20
            anchors.centerIn: parent
        }
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: parent
    }

    MessageDialog{
        id:messageDialog
        buttons: MessageDialog.Ok
    }

    MessageDialog{
        id:errorMesg
        buttons:MessageDialog.Close
        onRejected: {
            Qt.exit(-1)
        }
        title:qsTr("Error")
        text: qsTr("Cannot execute code, bible.db is not found")
        informativeText: qsTr("Reinstalling the program may fix this error")
    }

    BibleRepo{
        id:bibleRepo
    }

    function loadBook(id){
        books = bibleRepo.loadBook(Values.tableNames[id])
    }


    function showMessage(text){
        messageDialog.text = text
        messageDialog.open()
    }

//    Live{
//        id:liveWindow
//        visible: false
//    }

    Settings{
        id:set
        category: "view"
        fileName: "baiboly.ini"
        property alias videoSrc: window.bgSrc
        property alias bold: verse_text.font.bold
        property alias italic: verse_text.font.italic
        property alias fgColor: verse_text.color
        property alias windowVisibility: window.visibility
        property alias langId: window.langId
    }

    function updateBg(){
        var ext = bgSrc.charAt(bgSrc.length-1)

        if(ext === "4" | ext==="i"){
            player.source = bgSrc
            bgImage.visible = false
            sidebar.showVideo()
            if(sidebar.showMedia){
                player.play()
                for(var i=0;i<lives.length;i++){
                    lives[i].playVideo()
                }
            }else{
                for(var j=0;j<lives.length;j++){
                    lives[j].stopVideo()
                }
                player.stop()
            }
        }else{
            sidebar.showImage()
            player.stop()
            bgImage.source = bgSrc
            bgImage.visible = sidebar.showMedia
        }
    }

    function read(){
        sidebar.read()
    }

    RemoteDialog{
        id:remoteDialog
    }


    Item{
        id:container
        anchors.fill: parent
        focus: true

        Keys.onPressed:(event) => {
            if(event.key === Qt.Key_Right){
                              sidebar.readNext();
                           }
            if(event.key === Qt.Key_Left){
                               sidebar.readPrev();
                           }
        }

        Component.onCompleted: {
            if(!bibleRepo.initDb()){
                errorMesg.open()
            }else{
                menubar.getBook()
                sidebar.getLast()
                updateBg()
                recents = verseRepo.getAll()
            }
        }


//        BToolBar{
//            id:toolbar
//            anchors.left: sidebar.right
//            anchors.top: parent.top
//            anchors.right: parent.right
//            anchors.topMargin: 10
//        }

        Sidebar{
            id:sidebar
            anchors.top: parent.top
            anchors.topMargin: 10
        }


        Rectangle{
            id:video_container

            anchors.right: parent.right
            anchors.left: sidebar.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Image {
                id: bgImage
                anchors.fill: parent
                visible: false
                fillMode: Image.Stretch
            }

            Video{
                id:player
                loops:MediaPlayer.Infinite
                muted:true
                anchors.fill: parent
                fillMode: VideoOutput.Stretch
                onErrorOccurred:(error,errorString)=> {
                    showMessage(errorString)
                }
            }
            ScrollView{
                anchors.fill: parent
                ScrollBar.vertical.policy:ScrollBar.AlwaysOn
                ScrollBar.horizontal.policy:ScrollBar.AlwaysOff
                contentWidth: availableWidth

                Text{
                    id:verse_text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.styleName: "Normal"
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    textFormat: Text.RichText
                    anchors.fill: parent
                    padding: 50
                    font.pointSize: 20
                    style:Text.Outline | Text.Raised
                    styleColor: video_container.color
                    //readOnly: true
                }
            }

        }

    }
    MessageDialog{
        id:closeDialog
        title:window.title
        text:qsTr("Are you sure to leave this app?")
        buttons:MessageDialog.Ok | MessageDialog.Cancel
        onAccepted: {
            Qt.exit(1)
        }

    }

    onClosing:(event)=> {
        event.accepted = false
        closeDialog.open()
    }

}
