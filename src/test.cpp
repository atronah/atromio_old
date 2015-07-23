#include <iostream>

#include <QCommandLineParser>
#include <QtSql/QSqlDatabase>
#include <QSharedPointer>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QFileInfo>
#include <QTextStream>
#include <QDebug>

namespace test{

    class CSimpleException{
        const QString m_message;
    public:
        CSimpleException(const QString &message) throw() : m_message(message) {}
        const QString & message() const {return m_message;}
    };

    class CDatabaseError{
        QSharedPointer<QSqlError> m_dbError;
    public:
        CDatabaseError(const QSqlError &dbError) throw() : m_dbError(new QSqlError(dbError)) {}
    };

    void initSQLiteDatabase(QString fileName){
        QStringList statements;
        statements << "CREATE TABLE Currency(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "iso4217 VARCHAR(3) NOT NULL,\n"
                      "name VARCHAR(32)\n"
                      ");"
                   << "CREATE TABLE Unit(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "label VARCHAR(16),\n"
                      "description VARCHAR(255)\n"
                      ");"
                   << "CREATE TABLE Category(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "name VARCHAR(32),\n"
                      "parent_id INTEGER DEFAULT NULL REFERENCES Category(id) ON DELETE CASCADE\n"
                      ");"
                   << "CREATE TABLE Product(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "code VARCHAR(64), -- barcode and the like\n"
                      "name VARCHAR(64),\n"
                      "description VARCHAR(255),\n"
                      "category_id INTEGER DEFAULT NULL REFERENCES Category(id) ON DELETE SET DEFAULT\n"
                      ");"
                   << "CREATE TABLE Service(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "name VARCHAR(64),\n"
                      "description VARCHAR(255),\n"
                      "category_id INTEGER DEFAULT NULL REFERENCES Category(id) ON DELETE SET DEFAULT\n"
                      ");"
                   << "CREATE TABLE AccountType(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "name VARCHAR(32)\n"
                      "isCash BOOL DEFAULT 0, -- cash or cashless type\n"
                      ");"
                   << "CREATE TABLE Person(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "shortName VARCHAR(32) DEFAULT '<noname>',\n"
                      "fullName VARCHAR(32) DEFAULT '<noname>'\n"
                      ");"
                   << "CREATE TABLE Account(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,\n"
                      "opened DATETIME DEFAULT CURRENT_TIMESTAMP,\n"
                      "closed DATETIME DEFAULT NULL,\n"
                      "name VARCHAR(64),\n"
                      "description TEXT,\n"
                      "type_id INTEGER NOT NULL REFERENCES AccountType(id) ON DELETE RESTRICT,\n"
                      "owner_id INTEGER DEFAULT NULL REFERENCES Person(id) ON DELETE SET DEFAULT,\n"
                      "provider_id INTEGER DEFAULT NULL REFERENCES Person(id) ON DELETE SET DEFAULT\n"
                      ");"
                   << "CREATE TABLE Balance(\n"
                      "     -- balance snapshot on <checked> datetime\timestamp for account-currency pair\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "account_id INTEGER NOT NULL REFERENCES Account(id) ON DELETE CASCADE,\n"
                      "currency_id INTEGER NOT NULL REFERENCES Currency(id) ON DELETE RESTRICT,\n"
                      "checked DATETIME DEFAULT CURRENT_TIMESTAMP,\n"
                      "amount DECIMAL(12,3) NOT NULL\n"
                      ");"
                   << "CREATE TABLE 'Transaction'(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "account_id INTEGER NOT NULL REFERENCES Account(id) ON DELETE CASCADE,\n"
                      "type TINYINT NOT NULL, -- 0-goods payment, 1-refund, 2-correction, 3-transfer, 4-loan\n"
                      "created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,\n"
                      "performed DATETIME NOT NULL,\n"
                      "canceled DATETIME NOT NULL, -- posible only before balance check,otherwise new transaction\n"
                      "amount DECIMAL(12,3) NOT NULL,\n"
                      "isIncome BOOL NOT NULL DEFAULT 0,\n"
                      "note TEXT,\n"
                      "performer_id INTEGER DEFAULT NULL REFERENCES Person(id) ON DELETE SET DEFAULT,\n"
                      "currency_id INTEGER NOT NULL REFERENCES Currency(id) ON DELETE RESTRICT\n"
                      ");"
                   << "CREATE TABLE Transfer(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "source_id INTEGER NOT NULL UNIQUE REFERENCES 'Transaction'(id) ON DELETE CASCADE,\n"
                      "destination_id INTEGER NOT NULL UNIQUE REFERENCES 'Transaction'(id) ON DELETE CASCADE,\n"
                      "note TEXT\n"
                      ");"
                   << "CREATE TABLE Purpose(\n"
                      "     -- order for what? (sport, leisure, education, subsistence\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "name VARCHAR(32),\n"
                      "description VARCHAR(255),\n"
                      "necessityLevel SMALLINT DEFAULT 0, -- 0-unnecessary, 1-low necessity, ...\n"
                      "parent_id INTEGER DEFAULT NULL REFERENCES Purpose(id) ON DELETE CASCADE\n"
                      ");"
                   << "CREATE TABLE 'Order'(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,\n"
                      "completed DATETIME DEFAULT NULL,\n"
                      "expired DATETIME DEFAULT NULL,\n"
                      "type SMALLINT, --0..n: loan, goods, price monitoring, planning \n"
                      "note TEXT,\n"
                      "parent_id INTEGER DEFAULT NULL REFERENCES 'Order'(id) ON DELETE CASCADE, -- for complex order (eg, loan + purchase)\n"
                      "purpose_id INTEGER DEFAULT NULL REFERENCES Purpose(id) ON DELETE SET DEFAULT,\n"
                      "supplier_id INTEGER DEFAULT NULL REFERENCES Person(id) ON DELETE SET DEFAULT, -- provider or seller or lender\n"
                      "consumer_id INTEGER DEFAULT NULL REFERENCES Person(id) ON DELETE SET DEFAULT -- goods recipient or borrower or client\n"
                      ");"
                   << "CREATE TABLE Purchase(\n"
                      "id INTEGER PRIMARY KEY AUTOINCREMENT,\n"
                      "order_id INTEGER NOT NULL REFERENCES 'Order'(id) ON DELETE CASCADE,\n"
                      "price DECIMAL(12, 3) NOT NULL DEFAULT 0,\n"
                      "quantity DOUBLE DEFAULT 0.0, -- quantity of units (pieces, weight, etc)\n"
                      "unit_id INTEGER DEFAULT NULL REFERENCES Unit(id) ON DELETE RESTRICT, -- null equivalent pieces unit\n"
                      "product_id INTEGER DEFAULT NULL REFERENCES Product(id) ON DELETE RESTRICT,\n"
                      "service_id INTEGER DEFAULT NULL REFERENCES Service(id) ON DELETE RESTRICT,\n"
                      "supplier_id INTEGER DEFAULT NULL REFERENCES Person(id) ON DELETE SET DEFAULT, -- provider or seller or lender\n"
                      "consumer_id INTEGER DEFAULT NULL REFERENCES Person(id) ON DELETE SET DEFAULT -- goods recipient or borrower or client\n"
                      ");"
                   << "CREATE TABLE Payment(\n"
                      "         -- for N:M relation between Order and Transaction\n"
                      "order_id INTEGER NOT NULL UNIQUE REFERENCES 'Order'(id) ON DELETE CASCADE,\n"
                      "transaction_id INTEGER NOT NULL UNIQUE REFERENCES 'Transaction'(id) ON DELETE CASCADE,\n"
                      "PRIMARY KEY (order_id, transaction_id)\n"
                      ");"
                      ;

        if(QFileInfo(fileName).exists()){
            throw CSimpleException(QCoreApplication::translate("errors",
                                                               "database file already exists"));
        }

        QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", "main-db");
        db.setDatabaseName(fileName);
        if(!db.open()){
            throw CDatabaseError(db.lastError());
        }

        foreach (const QString &statement, statements) {
            QSqlQuery query(statement, db);
            if (query.lastError().isValid()){
                qDebug() << ">>>> error:" << endl << query.lastQuery() << endl << query.lastError().text() << endl << endl;
                throw CDatabaseError(query.lastError());
            }
        }


    }

    void processAttributes(){
        QCommandLineParser parser;
        parser.addHelpOption();
        parser.addVersionOption();

        QCommandLineOption initDatabase
                = QCommandLineOption("init-db",
                                     QCoreApplication::translate("command-line-opt",
                                                                 "initialize SQLite database in specified <file>"),
                                     QCoreApplication::translate("command-line-opt", "filename"));
        parser.addOption(initDatabase);

        parser.process(*qApp);

        if(parser.isSet(initDatabase)){
            initSQLiteDatabase(parser.value(initDatabase));
        }
    }


    int test(){
        qApp->setApplicationVersion(A_APP_VERSION_STR);

        processAttributes();

        return 0;
    }
}



