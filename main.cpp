#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QLocale>
#include <QTranslator>
#include <QQuickStyle>

#include "model/biblerepo.h"
#include "model/verserepo.h"
#include "translator.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QTranslator translator;
    MTranslator mtranslator;

    qmlRegisterType<BibleRepo>("model",1,0,"BibleRepo");
    qmlRegisterType<VerseRepo>("model",1,0,"VerseRepo");
    qmlRegisterType<MTranslator>("trans",1,0,"MTranslator");
    qmlRegisterType<Verse>("model",1,0,"Verse");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/MultiVerse/qml/windows/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
