#ifndef CONFIG_H
#define CONFIG_H

#include <QColor>

class Config
{
public:
    Config();
    QString getLang();
    QString getFont();
    int fontSize();
    bool isItalic();
    bool isBold();
    QColor getBg();
    QColor getFg();

};

#endif // CONFIG_H
