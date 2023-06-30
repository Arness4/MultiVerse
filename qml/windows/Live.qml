import QtQuick
import QtQuick.Controls.Material
import Qt.labs.settings
import QtMultimedia

Window {
    flags: Qt.Popup
    function playVideo(){
        livePlayer.play()
    }

    function stopVideo(){
        livePlayer.stop()
    }


    Rectangle{
        id:live_video_container
        color:video_container.color
        anchors.fill: parent

        Video{
            id:livePlayer
            loops:MediaPlayer.Infinite
            muted:true
            anchors.fill: parent
            source:player.source
            onErrorOccurred:(error,errorString)=> {
                showMessage(errorString)
            }
            fillMode: VideoOutput.Stretch
        }

        Image {
            id: liveBgImage
            anchors.fill: parent
            visible: bgImage.visible
            source:bgImage.source
            fillMode: Image.Stretch
        }

        Text{
            text:verse_text.text
            id:liveVerse
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: verse_text.font.pointSize
            font.bold: verse_text.font.bold
            font.italic: verse_text.font.italic
            font.family: verse_text.font.family
            fontSizeMode: Text.Fit
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            anchors.fill: parent
            padding: 50
            color:verse_text.color
            style:Text.Outline | Text.Raised
            styleColor: live_video_container.color
        }

//        ScrollView{
//            anchors.fill: parent
//            ScrollBar.vertical.policy:ScrollBar.AsNeeded
//            ScrollBar.horizontal.policy:ScrollBar.AlwaysOff
//            contentWidth: availableWidth

//            Text{
//                text:verse_text.text
//                id:liveVerse
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//                font.pointSize: verse_text.font.pointSize
//                font.bold: verse_text.font.bold
//                font.italic: verse_text.font.italic
//                font.family: verse_text.font.family
//                fontSizeMode: Text.Fit
//                wrapMode: Text.WordWrap
//                textFormat: Text.RichText
//                anchors.fill: parent
//                padding: 50
//                color:verse_text.color
//            }
//        }
    }
}
