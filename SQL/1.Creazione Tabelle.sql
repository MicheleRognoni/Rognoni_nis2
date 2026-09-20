-- 1.Creazione tabelle
-- Progetto: Base dati relazionale per catalogazione asset, servizi, dipendenze e responsabilità 

-- Azienda
CREATE TABLE azienda (
    id_azienda          SERIAL PRIMARY KEY,
    ragione_sociale      VARCHAR(150) NOT NULL,
    partita_iva          VARCHAR(11)  NOT NULL,
    cod_identificativo    VARCHAR(100) NOT NULL,
    email                VARCHAR(254),
    telefono             VARCHAR(20)
);

-- Categoria_asset
CREATE TABLE categoria_asset (
    id_categoria     SERIAL PRIMARY KEY,
    nome             VARCHAR(100) NOT NULL,
    descrizione      VARCHAR(400)
);

-- Responsabile
CREATE TABLE responsabile (
    id_responsabile   SERIAL PRIMARY KEY,
    id_azienda        INTEGER NOT NULL
                       REFERENCES azienda (id_azienda)
                       ON UPDATE CASCADE ON DELETE RESTRICT, --corretto in un secondo momento da CASCADE a RESTRICT
    nome              VARCHAR(50) NOT NULL,
    cognome           VARCHAR(50) NOT NULL,
    data_nascita       DATE,
    ruolo             VARCHAR(100),
    email             VARCHAR(254),
    telefono          VARCHAR(20)
);

-- Asset
CREATE TABLE asset (
    id_asset            SERIAL PRIMARY KEY,
    id_azienda          INTEGER NOT NULL
                         REFERENCES azienda (id_azienda)
                         ON UPDATE CASCADE ON DELETE RESTRICT,
    id_categoria        INTEGER NOT NULL
                         REFERENCES categoria_asset (id_categoria)
                         ON UPDATE CASCADE ON DELETE RESTRICT,
    id_responsabile     INTEGER NOT NULL
                         REFERENCES responsabile (id_responsabile)
                         ON UPDATE CASCADE ON DELETE RESTRICT,
    nome                VARCHAR(100) NOT NULL,
    descrizione         VARCHAR(400),
    criticita           VARCHAR(20)  NOT NULL,
    stato               BOOLEAN      NOT NULL DEFAULT TRUE,
    data_creazione       DATE         NOT NULL DEFAULT CURRENT_DATE,
    data_aggiornamento   DATE         NOT NULL DEFAULT CURRENT_DATE
);

-- Servizio
CREATE TABLE servizio (
    id_servizio          SERIAL PRIMARY KEY,
    id_azienda           INTEGER NOT NULL
                         REFERENCES azienda (id_azienda)
                         ON UPDATE CASCADE ON DELETE RESTRICT,
    id_responsabile      INTEGER NOT NULL
                         REFERENCES responsabile (id_responsabile)
                         ON UPDATE CASCADE ON DELETE RESTRICT,
    nome                 VARCHAR(100) NOT NULL,
    descrizione          VARCHAR(400),
    criticita            VARCHAR(20)  NOT NULL,
    stato                BOOLEAN      NOT NULL DEFAULT TRUE,
    data_creazione        DATE         NOT NULL DEFAULT CURRENT_DATE,
    data_aggiornamento    DATE         NOT NULL DEFAULT CURRENT_DATE
);

-- Fornitore
CREATE TABLE fornitore (
    id_fornitore     SERIAL PRIMARY KEY,
    id_azienda       INTEGER NOT NULL
                     REFERENCES azienda (id_azienda)
                     ON UPDATE CASCADE ON DELETE RESTRICT,
    ragione_sociale  VARCHAR(150) NOT NULL,
    tipologia        VARCHAR(100),
    referente        VARCHAR(100),
    email            VARCHAR(254),
    telefono         VARCHAR(20)
);
-- Punto_contatto
CREATE TABLE punto_contatto (
    id_contatto      SERIAL PRIMARY KEY,
    id_fornitore     INTEGER NOT NULL
                     REFERENCES fornitore (id_fornitore)
                     ON UPDATE CASCADE ON DELETE CASCADE,
    nome             VARCHAR(50),
    cognome          VARCHAR(50),
    ruolo            VARCHAR(100),
    email            VARCHAR(254),
    telefono         VARCHAR(20),
    tipo_contatto    VARCHAR(50)
);
-- Metadato
CREATE TABLE metadato (
    id_metadato      SERIAL PRIMARY KEY,
    id_azienda       INTEGER NOT NULL
                     REFERENCES azienda (id_azienda)
                     ON UPDATE CASCADE ON DELETE CASCADE,
    nome             VARCHAR(100) NOT NULL,
    valore           VARCHAR(400),
    tipo             VARCHAR(50),
    descrizione      VARCHAR(400)
);
-- Asset_servizio (tabella associativa N:M Asset <-> Servizio)
CREATE TABLE asset_servizio (
    id_asset       INTEGER NOT NULL
                   REFERENCES asset (id_asset)
                   ON UPDATE CASCADE ON DELETE CASCADE,
    id_servizio    INTEGER NOT NULL
                   REFERENCES servizio (id_servizio)
                   ON UPDATE CASCADE ON DELETE CASCADE,
    tipo_supporto  VARCHAR(100),
    note           VARCHAR(400),
    PRIMARY KEY (id_asset, id_servizio)
);
-- Servizio_fornitore (tabella associativa N:M Servizio <-> Fornitore)
CREATE TABLE servizio_fornitore (
    id_servizio      INTEGER NOT NULL
                     REFERENCES servizio (id_servizio)
                     ON UPDATE CASCADE ON DELETE CASCADE,
    id_fornitore     INTEGER NOT NULL
                     REFERENCES fornitore (id_fornitore)
                     ON UPDATE CASCADE ON DELETE CASCADE,
    tipo_dipendenza  VARCHAR(100),
    criticita        VARCHAR(20) NOT NULL,
    descrizione      VARCHAR(400),
    PRIMARY KEY (id_servizio, id_fornitore)
);
-- Storico_asset
CREATE TABLE storico_asset (
    id_versione       SERIAL PRIMARY KEY,
    id_asset          INTEGER NOT NULL
                      REFERENCES asset (id_asset)
                      ON UPDATE CASCADE ON DELETE RESTRICT,
    versione          INTEGER NOT NULL,
    nome              VARCHAR(100),
    descrizione       VARCHAR(400),
    criticita         VARCHAR(20),
    stato             BOOLEAN,
    data_inizio        DATE NOT NULL,
    data_fine          DATE,
    utente_modifica    VARCHAR(100),
    tipo_operazione    VARCHAR(20) NOT NULL
);
-- Storico_servizio
CREATE TABLE storico_servizio (
    id_versione       SERIAL PRIMARY KEY,
    id_servizio       INTEGER NOT NULL
                      REFERENCES servizio (id_servizio)
                      ON UPDATE CASCADE ON DELETE RESTRICT,
    versione          INTEGER NOT NULL,
    nome              VARCHAR(100),
    descrizione       VARCHAR(400),
    criticita         VARCHAR(20),
    stato             BOOLEAN,
    data_inizio        DATE NOT NULL,
    data_fine          DATE,
    utente_modifica    VARCHAR(100),
    tipo_operazione    VARCHAR(20) NOT NULL
);
