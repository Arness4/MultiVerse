#ifndef BIBLEREPO_H
#define BIBLEREPO_H


#include <QSqlError>
#include <QFile>
#include "verse.h"
#include "model.h"

namespace bibleRepo{
    QSqlError loadBook(QStringList *books,QString lang=QString("malagasy"));
    QSqlError chapNb(QString book,int *nb,QString lang=QString("malagasy"));
    QSqlError verseNb(QString book, int chap, int *nb,QString lang=QString("malagasy"));
    QSqlError loadVerse(QString book,int chap, int verse,QString *title,QString *v,QString lang=QString("malagasy"));
    QStringList loadChap(QString book,int chap,QString lang=QString("malagasy"));
    QString verseName(QString book,int chapternum,int versenum);
    QString verseRef(int bookIndex,int chap,int verse);
    QList<Verse> search(QString keyword,QString lang);
}

class BibleRepo : public QObject{
        Q_OBJECT
public:
    explicit BibleRepo(){};
    Q_INVOKABLE QStringList loadBook(QString lang=QString("malagasy")){
        QStringList books;
        bibleRepo::loadBook(&books,lang);
        return books;
    }
    Q_INVOKABLE int chapNb(QString book, QString lang=QString("malagasy")){
        int nb;
        bibleRepo::chapNb(book,&nb,lang);
        return nb;
    }
    Q_INVOKABLE int verseNb(QString book, int chap, QString lang=QString("malagasy")){
        int nb;
        bibleRepo::verseNb(book,chap,&nb,lang);
        return nb;
    }
    Q_INVOKABLE QStringList loadVerse(QString book, int chap, int verse, QString lang=QString("malagasy")){
        QString v, title;
        bibleRepo::loadVerse(book, chap, verse, &title, &v, lang);
        QStringList l;
        l.append(title);
        l.append(v);
        return l;
    }
    Q_INVOKABLE QStringList loadChap(QString book, int chap, QString lang=QString("malagasy")){
        return bibleRepo::loadChap(book,chap,lang);
    }
    Q_INVOKABLE QString verseName(QString book, int chapternum, int versenum){
        return bibleRepo::verseName(book,chapternum,versenum);
    }

    Q_INVOKABLE QList<Verse> search(QString keyword, QString lang){
        return bibleRepo::search(keyword, lang);
    }
    Q_INVOKABLE bool initDb(){
        if(!QFile::exists("bible.db"))
            return false;
        model::initDb();
        return true;
    }
    Q_INVOKABLE bool removeDb(){
        return QFile::remove("bible.db");
    }
};

#endif // BIBLEREPO_H

