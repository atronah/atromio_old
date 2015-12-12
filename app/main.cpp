#include <QApplication>
#include <QQmlApplicationEngine>

#include <Currency.h>
#include <QDebug>
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qWarning() << Currency("EuR", "test currency", 1).fractionSize();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
