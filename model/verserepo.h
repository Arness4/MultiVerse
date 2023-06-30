#ifndef VERSEREPO_H
#define VERSEREPO_H

#include "verse.h"
#include "biblerepo.h"
#include <QtSql>
namespace verseRepo{
    QSqlError addRecent(Verse r);
    void removeRecent(Verse r);
    bool recentExists(Verse r);
    QSqlError getLast(Verse *r);
    QSqlError getAll(QList<Verse> *verses);
    QSqlError clear();
}

class VerseRepo: public QObject{
    Q_OBJECT
public:
    explicit VerseRepo(){};

    Q_INVOKABLE QStringList getLast(){
        Verse v;
        verseRepo::getLast(&v);
        QStringList list;
        list.append(QString::number(v.bookIndex));
        list.append(QString::number(v.chapternum));
        list.append(QString::number(v.versenum));
        return list;
    }
    Q_INVOKABLE void addRecent(int bookIndex, int chap, int verse){
        Verse v;
        v.bookIndex = bookIndex;v.chapternum=chap;v.versenum=verse;
        verseRepo::addRecent(v);
    }
    Q_INVOKABLE QStringList getAll(){
        QList<Verse> verses;
        QStringList recents;
        verseRepo::getAll(&verses);
        foreach (Verse v, verses) {
            recents.append(bibleRepo::verseRef(v.bookIndex,v.chapternum,v.versenum));
        }

        return recents;
    }
    Q_INVOKABLE void clear(){
        verseRepo::clear();
    }
};

#endif // VERSEREPO_H
