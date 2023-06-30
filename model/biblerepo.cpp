#include "biblerepo.h"
#include "model.h"

QSqlError bibleRepo::loadBook(QStringList *books,QString lang){

     QSqlQuery q;
     QString sql  = QString("SELECT DISTINCT book FROM %1 order by verseid").arg(lang);

     if(!q.exec(sql))
         return q.lastError();
     while(q.next())
     {
         QString book = q.value("book").toString();
         books->append(book);
     }
     return QSqlError();
}

QSqlError bibleRepo::chapNb(QString book, int *nb,QString lang){
    QSqlQuery q;
    QString sql = QString("SELECT DISTINCT(chapternum) AS nb from %1 where book=?").arg(lang);
    q.prepare(sql);
    q.addBindValue(book);
    if(!q.exec())
        return q.lastError();
    int i=0;
    while(q.next())
        i++;
    *nb = i;
    return QSqlError();
}

QSqlError bibleRepo::verseNb(QString book, int chap, int *nb,QString lang){
    QSqlQuery q;
    QString sql = QString("SELECT DISTINCT(versenum) AS nb from %1 where book=? AND chapternum=?").arg(lang);
    q.prepare(sql);
    q.addBindValue(book);
    q.addBindValue(chap);
    if(!q.exec())
        return q.lastError();
    int i=0;
    while(q.next())
        i++;
    *nb = i;
    return QSqlError();
}


QSqlError bibleRepo::loadVerse(QString book, int chap, int verse,QString *title,QString *v,QString lang){
    QSqlQuery q;
    QString sql = QString("SELECT * FROM %1 where book=? and chapternum=? and versenum=?").arg(lang);
    q.prepare(sql);
    q.addBindValue(book);
    q.addBindValue(chap);
    q.addBindValue(verse);
    if(!q.exec())
       q.lastError();
    if(q.next())
    {
        if(!q.value("titles").isNull()){
            *title = q.value("titles").toString();
        }
        *v = q.value("verse").toString();
    }
    return QSqlError();
}

QStringList bibleRepo::loadChap(QString book,int chap,QString lang){
    QSqlQuery q;
    QStringList c;
    QString sql = QString("SELECT * from %1 where book=? and chapternum=?").arg(lang);
    q.prepare(sql);
    q.addBindValue(book);
    q.addBindValue(chap);
    if(q.exec()){
        while(q.next()){
            QString v;
            v.append(q.value("verse").toString());
            c.append(v);

        }
    }
    return c;
}

QString bibleRepo::verseRef(int bookIndex,int chap, int verse){
    QString ref;

    if(bookIndex < 10){
        ref.append("0");
    }
    ref.append(QString::number(bookIndex));
    if(chap < 10){
        ref.append("0");
    }
    ref.append(QString::number(chap));
    if(verse < 10){
        ref.append("0");
    }
    ref.append(QString::number(verse));
    return ref;
}

QString bibleRepo::verseName(QString book,int chapternum,int versenum){
    QString v;
    v.append("(");
    v.append(book);
    v.append(" ");
    v.append(QString::number(chapternum));
    v.append(":");
    v.append(QString::number(versenum));
    v.append(")");
    return v;
}

QList<Verse> bibleRepo::search(QString keyword, QString lang){
    QList<Verse> verses;
    QSqlQuery q;
    QString sql = QString("SELECT * from %1 where verse like '%%2%'").arg(lang,keyword);
    q.prepare(sql);

    if(q.exec()){
        while(q.next()){
        Verse v;
        v.book = q.value("book").toString();
        v.chapternum = q.value("chapternum").toInt();
        v.versenum = q.value("versenum").toInt();
        v.text = q.value("verse").toString();
        verses.append(v);
    }
    }
    return verses;
}
