#include "model.h"

QSqlError model::initDb(){
    QSqlDatabase database = QSqlDatabase::addDatabase("QSQLITE");
    database.setDatabaseName("bible.db");

    if(!database.open())
        return database.lastError();

    return QSqlError();
}
