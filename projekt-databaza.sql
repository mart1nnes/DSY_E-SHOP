CREATE DATABASE EshopElektronika;
GO

USE EshopElektronika;
GO



-- tabulky

CREATE TABLE Typy_produktov
(
    id_typ          INT IDENTITY(1,1) PRIMARY KEY,
    nazov_typu      VARCHAR(100) NOT NULL,
    popis           VARCHAR(255)
);



CREATE TABLE Znacky
(
    id_znacka       INT IDENTITY(1,1) PRIMARY KEY,
    nazov_znacky    VARCHAR(100) NOT NULL,
    krajina         VARCHAR(100) NOT NULL
);



CREATE TABLE Modelove_serie
(
    id_serie        INT IDENTITY(1,1) PRIMARY KEY,
    nazov_serie     VARCHAR(100) NOT NULL,

    id_znacka       INT NOT NULL,

    CONSTRAINT FK_serie_znacka
        FOREIGN KEY (id_znacka)
        REFERENCES Znacky(id_znacka)
        ON DELETE CASCADE
);



CREATE TABLE Modely
(
    id_model        INT IDENTITY(1,1) PRIMARY KEY,
    nazov_modelu    VARCHAR(100) NOT NULL,
    parametre       VARCHAR(255),
    popis           VARCHAR(255),

    id_serie        INT NOT NULL,

    CONSTRAINT FK_model_serie
        FOREIGN KEY (id_serie)
        REFERENCES Modelove_serie(id_serie)
        ON DELETE CASCADE
);



CREATE TABLE Produkty
(
    id_produkt          INT IDENTITY(1,1) PRIMARY KEY,
    nazov               VARCHAR(200) NOT NULL,
    cena                DECIMAL(10,2) NOT NULL CHECK (cena >= 0),
    sklad_mnozstvo      INT NOT NULL CHECK (sklad_mnozstvo >= 0),
    popis               VARCHAR(255) DEFAULT '',

    id_typ              INT NULL,
    id_znacka           INT NULL,
    id_model            INT NULL,

    CONSTRAINT FK_produkt_typ
        FOREIGN KEY (id_typ)
        REFERENCES Typy_produktov(id_typ)
        ON DELETE SET NULL,

    CONSTRAINT FK_produkt_znacka
        FOREIGN KEY (id_znacka)
        REFERENCES Znacky(id_znacka)
        ON DELETE SET NULL,

    CONSTRAINT FK_produkt_model
        FOREIGN KEY (id_model)
        REFERENCES Modely(id_model)
        ON DELETE SET NULL
);

CREATE TABLE Pouzivatelia
(
    id_pouzivatel       INT IDENTITY(1,1) PRIMARY KEY,
    meno                VARCHAR(100) NOT NULL,
    priezvisko          VARCHAR(100) NOT NULL,
    email               VARCHAR(150) NOT NULL UNIQUE,
    heslo               VARBINARY(255) NOT NULL,
    datum_registracie   DATETIME NOT NULL DEFAULT GETDATE()
);



CREATE TABLE Kosik
(
    id_kosik            INT IDENTITY(1,1) PRIMARY KEY,
    id_pouzivatel       INT NOT NULL,
    datum_vytvorenia    DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_kosik_pouzivatel
        FOREIGN KEY (id_pouzivatel)
        REFERENCES Pouzivatelia(id_pouzivatel)
        ON DELETE CASCADE
);



CREATE TABLE Polozky_kosika
(
    id_polozka      INT IDENTITY(1,1) PRIMARY KEY,
    id_kosik        INT NOT NULL,
    id_produkt      INT NOT NULL,
    mnozstvo        INT NOT NULL CHECK (mnozstvo > 0),

    CONSTRAINT FK_polozka_kosik
        FOREIGN KEY (id_kosik)
        REFERENCES Kosik(id_kosik)
        ON DELETE CASCADE,

    CONSTRAINT FK_polozka_produkt
        FOREIGN KEY (id_produkt)
        REFERENCES Produkty(id_produkt)
        ON DELETE CASCADE
);




-- inserty

INSERT INTO Typy_produktov (nazov_typu, popis) VALUES
('Biela elektronika','Domáce spotrebiče'),
('Čierna elektronika','TV, počítače a audio technika');



INSERT INTO Znacky (nazov_znacky, krajina) VALUES
('Samsung','Južná Kórea'),
('LG','Južná Kórea'),
('Bosch','Nemecko'),
('Sony','Japonsko'),
('Lenovo','Čína'),
('Whirlpool','USA'),
('Philips','Holandsko');



INSERT INTO Modelove_serie (nazov_serie,id_znacka) VALUES
('Galaxy',1),
('Bravia',4),
('IdeaPad',5),
('Serie 4',3),
('FreshCare',6);



INSERT INTO Modely (nazov_modelu,parametre,popis,id_serie) VALUES
('Galaxy S24','256GB AMOLED','Smartfón Samsung',1),
('Bravia XR55','55 OLED 4K','Smart televízor Sony',2),
('IdeaPad 5','16GB RAM 512GB SSD','Notebook Lenovo',3),
('Bosch WAN24260','1200 otáčok','Automatická práčka',4),
('Whirlpool FFWDD','Práčka so sušičkou','FreshCare technológia',5);



INSERT INTO Produkty (nazov,cena,sklad_mnozstvo,popis,id_typ,id_znacka,id_model) VALUES
('Samsung Galaxy S24',899.99,20,'Smartfón',2,1,1),
('Sony Bravia XR55 TV',1499.90,8,'4K OLED televízor',2,4,2),
('Lenovo IdeaPad 5',799.00,15,'Notebook pre prácu a školu',2,5,3),
('Bosch WAN24260 práčka',549.00,10,'Automatická práčka',1,3,4),
('Whirlpool FreshCare práčka',499.90,7,'Práčka so sušičkou',1,6,5),
('Philips parná žehlička',129.90,25,'Domáca parná žehlička',1,7,NULL);



INSERT INTO Pouzivatelia (meno,priezvisko,email,heslo) VALUES
('Martin','Szmolka','martin@email.com',HASHBYTES('SHA2_256','heslo123')),
('Peter','Novak','peter@email.com',HASHBYTES('SHA2_256','tajneheslo')),
('Jana','Kovacova','jana@email.com',HASHBYTES('SHA2_256','mojeheslo'));



INSERT INTO Kosik (id_pouzivatel) VALUES
(1),
(2);



INSERT INTO Polozky_kosika (id_kosik,id_produkt,mnozstvo) VALUES
(1,1,1),
(1,3,1),
(2,2,1);




--select dotazy

-- vsetky produkty
SELECT
        p.nazov,
        p.cena,
        p.sklad_mnozstvo
FROM
        Produkty p;



-- produkty podla typu
SELECT
        p.nazov,
        p.cena,
        t.nazov_typu
FROM
        Produkty p
            JOIN Typy_produktov t
                ON p.id_typ = t.id_typ
WHERE
        t.nazov_typu = 'Čierna elektronika';



-- produkty podla ceny
SELECT
        nazov,
        cena
FROM
        Produkty
WHERE
        cena < 800;



-- obsah kosika
SELECT
        u.meno,
        u.priezvisko,
        p.nazov,
        pk.mnozstvo
FROM
        Pouzivatelia u
            JOIN Kosik k
                ON u.id_pouzivatel = k.id_pouzivatel
            JOIN Polozky_kosika pk
                ON k.id_kosik = pk.id_kosik
            JOIN Produkty p
                ON pk.id_produkt = p.id_produkt;




-- crud operacie

-- pridanie produktu
INSERT INTO Produkty
(
    nazov,
    cena,
    sklad_mnozstvo,
    popis,
    id_typ,
    id_znacka
)
VALUES
(
    'LG OLED55 TV',
    1299.90,
    5,
    'OLED televízor',
    2,
    2
);



-- uprava ceny produktu
UPDATE
        Produkty
SET
        cena = 849.90
WHERE
        id_produkt = 3;



-- zmazanie produktu
DELETE FROM
        Produkty
WHERE
        id_produkt = 6;