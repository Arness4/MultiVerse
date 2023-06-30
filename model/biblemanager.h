#ifndef BIBLEMANAGER_H
#define BIBLEMANAGER_H

#include "biblerepo.h"
#include <QObject>
#include <QDebug>

class BibleManager : public QObject
{
    Q_OBJECT

public:
    explicit BibleManager(QString lang="malagasy",QObject *parent=0);
    QString book();
public slots:
    QString getBooks();
private:
    QStringList books;
    QString lang;
};

#endif // BIBLEMANAGER_H
