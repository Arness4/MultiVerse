#include "verserepo.h"


void verseRepo::removeRecent(Verse r){
    QSqlQuery q;
    q.prepare("delete from recent where bookIndex=? and chapnum=? and versenum=?");
    q.addBindValue(r.bookIndex);
    q.addBindValue(r.chapternum);
    q.addBindValue(r.versenum);
    q.exec();

}

bool verseRepo::recentExists(Verse r){
    QSqlQuery q;
    q.prepare("select * from recent where bookIndex=? and chapnum=? and versenum=?");
    q.addBindValue(r.bookIndex);
    q.addBindValue(r.chapternum);
    q.addBindValue(r.versenum);
    if(q.exec())
    {
        if(q.next()){
            return true;
        }
    }
    return false;
}

QSqlError verseRepo::addRecent(Verse r){
    if(verseRepo::recentExists(r)){
        verseRepo::removeRecent(r);
    }
    QSqlQuery q;
    q.prepare(QLatin1String("insert into recent(book,bookIndex,chapnum,versenum,opening_time) values(?,?,?,?,?)"));
    q.addBindValue(r.book);
    q.addBindValue(r.bookIndex);
    q.addBindValue(r.chapternum);
    q.addBindValue(r.versenum);
    q.addBindValue(QDateTime::currentDateTime());

    if(!q.exec()){
        qDebug()<<q.lastError();
        return q.lastError();
    }
    return QSqlError();
}

QSqlError verseRepo::getLast(Verse *r){
    QSqlQuery q;
    if(!q.exec(QLatin1String(
                      "select * from recent order by opening_time desc limit 1")))

        return q.lastError();

    if(q.next())
    {
        r->book = q.value("book").toString();
        r->bookIndex = q.value("bookIndex").toInt();
        r->chapternum = q.value("chapnum").toInt();
        r->versenum = q.value("versenum").toInt();

    }else{
        r->chapternum = 0;
    }


    return QSqlError();
}

QSqlError verseRepo::clear(){
    QSqlQuery q;
    if(!q.exec("delete from recent where 1"))
        return q.lastError();

    return QSqlError();
}

QSqlError verseRepo::getAll(QList<Verse> *verses){
    QSqlQuery q;
    Verse r;
    if(!q.exec(QLatin1String(
                      "select * from recent order by opening_time desc")))
        return q.lastError();

    while(q.next())
    {
        r.book = q.value("book").toString();
        r.bookIndex = q.value("bookIndex").toInt();
        r.chapternum = q.value("chapnum").toInt();
        r.versenum = q.value("versenum").toInt();
        r.opening_time = q.value("opening_time").toDateTime();
        verses->append(r);
    }
    q.clear();

    return QSqlError();
}
