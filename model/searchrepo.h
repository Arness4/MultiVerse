#ifndef SEARCHREPO_H
#define SEARCHREPO_H

#include <QtSql>

namespace SearchRepo {
 QSqlError add(QString keyword,QString lang);
 QSqlError remove(QString keyword,QString lang);
 QStringList get(QString lang);
 bool exists(QString keyword,QString lang);
}

#endif // SEARCHREPO_H
