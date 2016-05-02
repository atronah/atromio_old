#include <QApplication>
#include <QQmlApplicationEngine>

#ifdef A_TEST_DEL
    #include <math.h>
    #include <QDebug>
    #include <Currency.h>
    #include <QList>
    #include <Money.h>
#endif

#include <Controller.h>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    #ifdef A_TEST_DEL
        qWarning() << lldiv(11234, 100).rem;
    #endif

    Controller c;
    c.init_database();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
