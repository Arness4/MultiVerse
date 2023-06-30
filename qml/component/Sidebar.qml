import QtQuick 2.15
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.settings
import QtMultimedia
import "qrc:/assets/js/values.js" as Values

Column {
    id: side
    width: parent.width/5
    spacing: 10

    property int actualVerse
    property int actualChap
    property int actualBook

    property int verseNb: bibleRepo.verseNb(bookComboBox.editText,chapSpinBox.value,Values.tableNames[langId])
    property int chapNb: bibleRepo.chapNb(bookComboBox.editText,Values.tableNames[langId])
    property color bgColor
    property color fgColor
    property bool showMedia : mediaBgCheckBox.checked

    Settings{
        category:"view"
        fileName: "baiboly.ini"
        property alias bgColor: bgColorDialog.selectedColor
        property alias fgColor: fgColorDialog.selectedColor
        property alias showMedia: mediaBgCheckBox.checked
    }


    function showVideo(){
        previewImage.visible = false
        previewVideo.play()
    }
    function showImage(){
        previewVideo.stop()
        previewImage.visible = true
    }

    function readNext(){
        if(verseSpinBox.value < verseNb){
            verseSpinBox.value += 1
        }else{
            if(chapSpinBox.value < chapNb){
                chapSpinBox.value += 1
                verseSpinBox.value = 1
            }
        }
        read()
    }

    function readPrev(){
        if(verseSpinBox.value > 1){
            verseSpinBox.value -= 1
        }else{
            if(chapSpinBox.value > 1){
                chapSpinBox.value -= 1
                verseSpinBox.value = verseNb
            }
        }
        read()
    }

    function read(){
        var title_verse = bibleRepo.loadVerse(bookComboBox.editText,chapSpinBox.value,verseSpinBox.value,Values.tableNames[langId])
        var title = title_verse[0]
        var verse = title_verse[1]
        var verseName = bibleRepo.verseName(bookComboBox.editText,chapSpinBox.value,verseSpinBox.value)

        verse_text.text =  "<i style='font-family:comic sans ms'>"+
                title_verse[0]+"</i><br>"+title_verse[1]+"<br><i style='font-family:comic sans ms'>"+
                verseName+"</i>"

    }

    function getLast(){
        var lastVerse = verseRepo.getLast();
        if(lastVerse[1]!=='0'){
            bookComboBox.currentIndex = lastVerse[0]
            chapSpinBox.value = lastVerse[1]
            verseSpinBox.value = lastVerse[2]
        }
        read()
    }

    function load(b,c,v){
        bookComboBox.currentIndex = b
        chapSpinBox.value = c
        verseSpinBox.value = v

        read()
        addToRecent()
    }

    function addToRecent(){
        verseRepo.addRecent(bookComboBox.currentIndex,chapSpinBox.value,verseSpinBox.value)
        recents = verseRepo.getAll()
    }

    function setActual(){
        actualBook = bookComboBox.currentIndex
        actualVerse = verseSpinBox.value
        actualChap = chapSpinBox.value
    }

    function getActual(){
        bookComboBox.currentIndex = actualBook
        chapSpinBox.value = actualChap
        verseSpinBox.value = actualVerse
    }

//    BibleRepo{
//        id:bibleRepo
//    }


    ColorDialog{
        id:fgColorDialog
        property int times: 0
        onAccepted: {
            verse_text.color = fgColorDialog.selectedColor
        }
        onSelectedColorChanged: {
            if(times==0){
                verse_text.color = fgColorDialog.selectedColor
                times=1
            }
        }
    }

    ColorDialog{
        id:bgColorDialog
        property int times: 0
        onAccepted: {
            video_container.color = bgColorDialog.selectedColor
        }
        onSelectedColorChanged: {
            if(times==0){
                video_container.color = bgColorDialog.selectedColor
                times=1
            }
        }
    }


        ComboBox{
            id:bookComboBox
            width:side.width - 10
            height:50
            model: books
            editable: false
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Grid{
            id:chapGrid
            columns: 2
            rows: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: bookComboBox.bottom
            Text{
                id:chapText
                text: qsTr("Chapter")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
                width:side.width/2
                font:bookComboBox.font
            }
            SpinBox{
                id: chapSpinBox
                editable: true
                width:side.width/2
                from:1
                to: chapNb
                value: 1
            }
            Text{
                id:verseText
                text: qsTr("Verse")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
                width:side.width/2
                font:bookComboBox.font
            }
            SpinBox{
                id: verseSpinBox
                editable: true
                width: side.width/2
                from:1
                to: verseNb
                value:1
            }

        }


        Button{
            id: readBtn
            text: qsTr("Read")
            width: side.width-10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:chapGrid.bottom
            anchors.topMargin: 10
            onClicked: {
                read()
                addToRecent()
            }
            icon.source: "qrc:/assets/images/book02.ico"
            icon.color: "transparent"
        }
        Rectangle{
            id:sep
            width: side.width - 10
            anchors.horizontalCenter: parent.horizontalCenter
            height: 5
            anchors.top: readBtn.bottom
            anchors.topMargin: 10
        }

        Button{
            id:textColorBtn
            text: qsTr("Text color")
            width:side.width - 10
            anchors.horizontalCenter: parent.horizontalCenter
//            Material.foreground: fgColorDialog.selectedColor
//            Material.background: bgColorDialog.selectedColor
            icon.source: "qrc:/assets/images/live.png"
            icon.color: fgColorDialog.selectedColor
            onClicked: {
                fgColorDialog.open()
            }
            anchors.top: sep.bottom
            anchors.topMargin: 10
        }
        Button{
            id:bgColorBtn
            text: qsTr("Background color")
            width:side.width - 10
            anchors.horizontalCenter: parent.horizontalCenter
            icon.source: "qrc:/assets/images/live.png"
            icon.color: bgColorDialog.selectedColor
            onClicked: {
                bgColorDialog.open()
            }
            anchors.top: textColorBtn.bottom
            anchors.topMargin: 10
        }

        Row{
            id:rowMed
            anchors.top: bgColorBtn.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 20

            CheckBox{
                id:mediaBgCheckBox
                text:qsTr("Media background")
                onToggled: {
                    updateBg()
                }
            }
            Button{
                id:browseMediaBtn
                text:qsTr("Browse")
                onClicked: {
                    mediaChooserDialog.open()
                }
            }
        }

        Rectangle{
            id:previewMediaRect
            anchors.top: rowMed.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            width:bookComboBox.width/(1.5)
            height:window.height/4
            Image {
                id: previewImage
                source:bgImage.source
                visible: true
                anchors.fill: parent
            }
            Video{
                id:previewVideo
                loops:MediaPlayer.Infinite
                muted:true
                anchors.fill: parent
                source:player.source
                onErrorOccurred:(error,errorString)=> {
                    showMessage(errorString)
                }
            }
        }

}
