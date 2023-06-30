#ifndef VERSE_H
#define VERSE_H

#include <QString>
#include <QDateTime>

class Verse
{
    //Q_OBJECT
    //Q_PROPERTY(QString book READ book WRITE setBook NOTIFY bookChanged)
public:
    Verse();
    QString book,text;
    int bookIndex, chapternum,versenum;
    QDateTime opening_time;
};

#endif // VERSE_H
