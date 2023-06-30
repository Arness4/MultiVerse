#include "biblemanager.h"

BibleManager::BibleManager(QString lang,QObject *parent): QObject(parent)
{
    this->lang = lang;
    //bibleRepo::loadBook(&books,this->lang);
}

QString BibleManager::getBooks(){

    return books.at(0);
}

QString BibleManager::book(){
    return "book";
}
