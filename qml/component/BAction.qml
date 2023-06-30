import QtQuick.Controls.Material


Action {
    property int verse
    property int chap
    property int book
    text: bibleRepo.verseName(books[book],chap,verse)

    onTriggered: {
        sidebar.load(book,chap,verse)
    }
}
