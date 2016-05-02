-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ../changelog/dev-changelog.xml
-- Ran at: 02.05.16 23:45
-- Against: null@jdbc:sqlite:data.db
-- Liquibase version: 3.4.2
-- *********************************************************************

-- Create Database Lock Table
CREATE TABLE DATABASECHANGELOGLOCK (ID INTEGER NOT NULL, LOCKED BOOLEAN NOT NULL, LOCKGRANTED TEXT, LOCKEDBY VARCHAR(255), CONSTRAINT PK_DATABASECHANGELOGLOCK PRIMARY KEY (ID));

-- Initialize Database Lock Table
DELETE FROM DATABASECHANGELOGLOCK;

INSERT INTO DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0);

-- Lock Database
UPDATE DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = 'A-UB-WIN7 (192.168.116.18)', LOCKGRANTED = '2016-05-02 23:45:09.398' WHERE ID = 1 AND LOCKED = 0;

-- Create Database Change Log Table
CREATE TABLE DATABASECHANGELOG (ID VARCHAR(255) NOT NULL, AUTHOR VARCHAR(255) NOT NULL, FILENAME VARCHAR(255) NOT NULL, DATEEXECUTED TEXT NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR(10) NOT NULL, MD5SUM VARCHAR(35), DESCRIPTION VARCHAR(255), COMMENTS VARCHAR(255), TAG VARCHAR(255), LIQUIBASE VARCHAR(20), CONTEXTS VARCHAR(255), LABELS VARCHAR(255));

-- Changeset ../changelog/init/create-Refbooks.xml::createRefbooks::atronah
CREATE TABLE Unit (id INTEGER CONSTRAINT PK_UNIT PRIMARY KEY AUTOINCREMENT NOT NULL, designation VARCHAR(8) NOT NULL, name VARCHAR(64) NOT NULL, description VARCHAR(255) NOT NULL);

CREATE TABLE Currency (id INTEGER CONSTRAINT PK_CURRENCY PRIMARY KEY AUTOINCREMENT NOT NULL, code VARCHAR(3) NOT NULL, idx SMALLINT DEFAULT 0 NOT NULL, name VARCHAR(64) NOT NULL, symbol VARCHAR(1) NOT NULL, fractionSize SMALLINT DEFAULT 2 NOT NULL, UNIQUE (code), UNIQUE (symbol));

CREATE TABLE Category (id INTEGER CONSTRAINT PK_CATEGORY PRIMARY KEY AUTOINCREMENT NOT NULL, type SMALLINT DEFAULT 0 NOT NULL, name VARCHAR(64) NOT NULL, parent_id INTEGER, CONSTRAINT fk_Category_Parent_Category FOREIGN KEY (parent_id) REFERENCES Category(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createRefbooks', 'atronah', '../changelog/init/create-Refbooks.xml', CURRENT_TIMESTAMP, 1, '7:f5f02eb9ce5e9f0f9b609226fd557e17', 'createTable (x3)', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-Person.xml::createPerson::atronah
CREATE TABLE Person (id INTEGER CONSTRAINT PK_PERSON PRIMARY KEY AUTOINCREMENT NOT NULL, shortName VARCHAR(32) NOT NULL, fullName VARCHAR(255) DEFAULT '' NOT NULL, type SMALLINT DEFAULT 0 NOT NULL);

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createPerson', 'atronah', '../changelog/init/create-Person.xml', CURRENT_TIMESTAMP, 2, '7:f306c70399888d21da712e1ddea47483', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-User.xml::createUser::atronah
CREATE TABLE User (id INTEGER CONSTRAINT PK_USER PRIMARY KEY AUTOINCREMENT NOT NULL, login VARCHAR(32) NOT NULL, password VARCHAR(255) NOT NULL, person_id INTEGER NOT NULL, CONSTRAINT fk_User_Person FOREIGN KEY (person_id) REFERENCES Person(id), UNIQUE (login));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createUser', 'atronah', '../changelog/init/create-User.xml', CURRENT_TIMESTAMP, 3, '7:79f72b1e1ebcb384f79d101d9bc32a35', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-Product.xml::createProduct::atronah
CREATE TABLE Product (id INTEGER CONSTRAINT PK_PRODUCT PRIMARY KEY AUTOINCREMENT NOT NULL, code VARCHAR(128) DEFAULT '' NOT NULL, name VARCHAR(64) NOT NULL, maker_id INTEGER, category_id INTEGER, CONSTRAINT fk_Product_Maker_Person FOREIGN KEY (maker_id) REFERENCES Person(id), CONSTRAINT fk_Product_Category FOREIGN KEY (category_id) REFERENCES Category(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createProduct', 'atronah', '../changelog/init/create-Product.xml', CURRENT_TIMESTAMP, 4, '7:98426c73089cfe26f1f70a3ed0790cae', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-Invoice.xml::createInvoice::atronah
CREATE TABLE Invoice (id INTEGER CONSTRAINT PK_INVOICE PRIMARY KEY AUTOINCREMENT NOT NULL, created TEXT NOT NULL, completed TEXT, expired TEXT, type SMALLINT DEFAULT 0 NOT NULL, name VARCHAR(64) NOT NULL, amount BIGINT NOT NULL, currency_id INTEGER, discount BIGINT DEFAULT 0 NOT NULL, tax BIGINT DEFAULT 0 NOT NULL, note TEXT DEFAULT '' NOT NULL, refInvoice_id INTEGER, refType SMALLINT DEFAULT 0 NOT NULL, supplier_id INTEGER, customer_id INTEGER, CONSTRAINT fk_Invoice_Currency FOREIGN KEY (currency_id) REFERENCES Currency(id), CONSTRAINT fk_Invoice_Invoice FOREIGN KEY (refInvoice_id) REFERENCES Invoice(id), CONSTRAINT fk_Invoice_Customer_Person FOREIGN KEY (customer_id) REFERENCES Person(id), CONSTRAINT fk_Invoice_Supplier_Person FOREIGN KEY (supplier_id) REFERENCES Person(id));

CREATE TABLE Purchase (id INTEGER CONSTRAINT PK_PURCHASE PRIMARY KEY AUTOINCREMENT NOT NULL, invoice_id INTEGER NOT NULL, quantity DECIMAL(15, 5) DEFAULT 1.0 NOT NULL, unit_id INTEGER, price BIGINT NOT NULL, discount BIGINT DEFAULT 0 NOT NULL, tax BIGINT DEFAULT 0 NOT NULL, isAproximate SMALLINT DEFAULT 0 NOT NULL, CONSTRAINT fk_Purchase_Invoice FOREIGN KEY (invoice_id) REFERENCES Invoice(id), CONSTRAINT fk_Purchase_Unit FOREIGN KEY (unit_id) REFERENCES Unit(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createInvoice', 'atronah', '../changelog/init/create-Invoice.xml', CURRENT_TIMESTAMP, 5, '7:4a4b7b47071d1391ef471cfe93a5d2d8', 'createTable (x2)', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-Account.xml::createAccount::atronah
CREATE TABLE AccountType (id INTEGER CONSTRAINT PK_ACCOUNTTYPE PRIMARY KEY AUTOINCREMENT NOT NULL, name VARCHAR(64) NOT NULL, isCash SMALLINT DEFAULT 0 NOT NULL);

CREATE TABLE Account (id INTEGER CONSTRAINT PK_ACCOUNT PRIMARY KEY AUTOINCREMENT NOT NULL, created TEXT DEFAULT current_timestamp NOT NULL, opened TEXT, closed TEXT, name VARCHAR(64) NOT NULL, description VARCHAR(255) DEFAULT '' NOT NULL, type_id INTEGER NOT NULL, owner_id INTEGER NOT NULL, CONSTRAINT fk_Account_Owner_Person FOREIGN KEY (owner_id) REFERENCES Person(id), CONSTRAINT fk_Account_Type FOREIGN KEY (type_id) REFERENCES AccountType(id));

CREATE TABLE Balance (id INTEGER CONSTRAINT PK_BALANCE PRIMARY KEY AUTOINCREMENT NOT NULL, account_id INTEGER NOT NULL, checked TEXT NOT NULL, amount BIGINT NOT NULL, currency_id INTEGER, CONSTRAINT fk_Balance_Account FOREIGN KEY (account_id) REFERENCES Account(id), CONSTRAINT fk_Balance_Currency FOREIGN KEY (currency_id) REFERENCES Currency(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createAccount', 'atronah', '../changelog/init/create-Account.xml', CURRENT_TIMESTAMP, 6, '7:82a23e26daa4b99d31884b6f9b4b52a3', 'createTable (x3)', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-Operation.xml::createOperation::atronah
CREATE TABLE Operation (id INTEGER CONSTRAINT PK_OPERATION PRIMARY KEY AUTOINCREMENT NOT NULL, account_id INTEGER NOT NULL, created TEXT DEFAULT current_timestamp NOT NULL, performed TEXT, canceled TEXT, amount BIGINT NOT NULL, currency_id INTEGER NOT NULL, direction SMALLINT DEFAULT 0 NOT NULL, performer_id INTEGER NOT NULL, invoice_id INTEGER, CONSTRAINT fk_Operation_Currency_id FOREIGN KEY (currency_id) REFERENCES Currency(id), CONSTRAINT fk_Operation_Account_id FOREIGN KEY (account_id) REFERENCES Account(id), CONSTRAINT fk_Operation_Perform_Person_id FOREIGN KEY (performer_id) REFERENCES Person(id), CONSTRAINT fk_Operation_Invoice_id FOREIGN KEY (invoice_id) REFERENCES Invoice(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createOperation', 'atronah', '../changelog/init/create-Operation.xml', CURRENT_TIMESTAMP, 7, '7:996bcb105e4de157c2b800d8997c8253', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/data/insert-primary-currency.xml::RUR::atronah
INSERT INTO Currency (code, idx, name, symbol, fractionSize) VALUES ('RUR', '0', 'Российский рубль', '₽', '2');

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('RUR', 'atronah', '../changelog/data/insert-primary-currency.xml', CURRENT_TIMESTAMP, 8, '7:f89340b549b57a2d05d3fd785af08429', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/data/insert-primary-currency.xml::USD::atronah
INSERT INTO Currency (code, idx, name, symbol, fractionSize) VALUES ('USD', '1', 'Доллар США', '$', '2');

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('USD', 'atronah', '../changelog/data/insert-primary-currency.xml', CURRENT_TIMESTAMP, 9, '7:e2a809de169513a3716a9ae42210d1ff', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/data/insert-primary-currency.xml::EUR::atronah
INSERT INTO Currency (code, idx, name, symbol, fractionSize) VALUES ('EUR', '2', 'Евро', '€', '2');

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('EUR', 'atronah', '../changelog/data/insert-primary-currency.xml', CURRENT_TIMESTAMP, 10, '7:6e3572ed415cf8ca20ab84c21658cb2f', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/data/insert-primary-currency.xml::TRY::atronah
INSERT INTO Currency (code, idx, name, symbol, fractionSize) VALUES ('TRY', '3', 'Турецкая лира', '₺', '2');

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('TRY', 'atronah', '../changelog/data/insert-primary-currency.xml', CURRENT_TIMESTAMP, 11, '7:2655b732922411fa9279786b73988680', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Release Database Lock
UPDATE DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;

