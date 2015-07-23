#define A_TEST_MODE

#ifdef A_TEST_MODE
#include "test.cpp"
#endif

#ifdef A_USE_GUI

#include <QApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}

#else

#include <QCoreApplication>

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
#ifdef A_TEST_MODE
    return test::test();
#else
    return app.exec();
#endif
}

#endif
