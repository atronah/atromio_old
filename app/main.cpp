#include <QApplication>
#include <QQmlApplicationEngine>

#ifdef A_TEST_DEL
    #include <math.h>
    #include <QDebug>
    #include <Currency.h>
    #include <QList>
    #include <Money.h>
#endif

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    #ifdef A_TEST_DEL
        Money m = -123.45f;
        QList<Money> l;
        l << -123.45f;
        qWarning() << m.integral() << m.fractional();
        qWarning() << l.at(0).integral() << l.at(0).fractional();
    #endif

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
