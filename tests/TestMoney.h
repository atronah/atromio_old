#ifndef TESTMONEY_H
#define TESTMONEY_H

#include <QObject>
#include <AutoTest.h>

class TestMoney : public QObject {
    Q_OBJECT
    private slots:
        void constructor_data();
        void constructor();

        void comparing();
        void arithmetic();
        void toString_data();
        void toString();
};

DECLARE_TEST(TestMoney)

#endif // TESTMONEY_H
