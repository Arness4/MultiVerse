#include "searchrepo.h"

QSqlError SearchRepo::remove(QString keyword,QString lang){
    QSqlQuery q;
    QString sql = QString("delete from search where keyword=? and lang=?");
    q.prepare(sql);
    q.addBindValue(keyword);
    q.addBindValue(lang);
    if(!q.exec())
        return q.lastError();
    return QSqlError();
}

QStringList SearchRepo::get(QString lang){
    QSqlQuery q;
    QStringList s;
    QString sql;
     sql = QString("select * from search where lang=?"
                "order by search_date desc limit 5");
    q.prepare(sql);
    q.addBindValue(lang);
    if(!q.exec())
        return s;
    while(q.next()){
        s.append(q.value("keyword").toString());
    }
    return s;
}

QSqlError SearchRepo::add(QString keyword, QString lang){
    QSqlError err ;
    if(exists(keyword,lang))
        err = remove(keyword,lang);
    if(err.type() != QSqlError::NoError)
        return err;
    QSqlQuery q;
    q.prepare("insert into search(keyword,lang,search_date) values(?,?,?)");
    q.addBindValue(keyword);
    q.addBindValue(lang);
    q.addBindValue(QDateTime::currentDateTime());
    if(!q.exec())
        return q.lastError();

    return QSqlError();
}

bool SearchRepo::exists(QString keyword, QString lang){
    QString sql("select * from search where lang=? and keyword=?");
    QSqlQuery q;
    q.prepare(sql);
    q.addBindValue(lang);
    q.addBindValue(keyword);
    q.exec();
    if(q.next()){
        return true;
    }
    return false;
}
