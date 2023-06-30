#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QTranslator>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QLocale>
#include <QQmlContext>
#include <QSettings>

class MTranslator : public QObject{
    Q_OBJECT
    Q_PROPERTY(QString lang READ lang WRITE setLang NOTIFY langChanged)
public:
    explicit MTranslator(QObject *parent=nullptr):QObject(parent){
            QSettings settings("baiboly.ini",QSettings::IniFormat);
            settings.beginGroup("view");

            setLang(settings.value("currentLang",QLocale::system().name()).toString());
            settings.endGroup();
    }

    Q_INVOKABLE void swicthLanguage(QString lang){
        QTranslator *translator = new QTranslator(qGuiApp);
        setLang(lang);
        QLocale locale(lang);
        QLocale::setDefault(locale);
        if(m_previousTranslator){
            qGuiApp->removeTranslator(m_previousTranslator);
            m_previousTranslator->deleteLater();
            m_previousTranslator = nullptr;
        }
        if(translator->load(QString(":/i18n/baiboly_%1").arg(lang))){
            m_previousTranslator = translator;
            qGuiApp->installTranslator(translator);
            QQmlEngine *engine = QQmlEngine::contextForObject(this)->engine();
            engine->retranslate();
        }else{
            qDebug()<<"error";
        }

    }

    void setLang(const QString &lang){
        if(m_lang != lang){
            m_lang = lang;
            emit langChanged();
        }
    }
    QString lang() const{
        return m_lang;
    }

signals:
    void langChanged();
private:
    QString m_lang;
    QTranslator *m_previousTranslator = nullptr;


};

#endif // TRANSLATOR_H
