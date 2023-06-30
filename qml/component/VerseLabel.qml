import QtQuick
import QtQuick.Controls.Material
import model

Item {
    required property string book
    required property int chap
    required property int verse
    property var title_verse:  bibleRepo.loadVerse(book,chap,verse)
    property string text:  title_verse[0]+"\n"+title_verse[1]

    BibleRepo{
        id:bibleRepo
    }

    Text{
        text:text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 52
        font.styleName: "Normal"
        fontSizeMode: Text.Fit
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        anchors.centerIn: parent
    }

}
