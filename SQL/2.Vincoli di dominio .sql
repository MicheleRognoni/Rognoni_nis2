--2.Vincoli di dominio.sql
--Inseriamo per ogni Tabella i vincoli di dominio scritti precedentemente nel word della documentazione tecnica.

--Azienda
ALTER TABLE azienda
    ADD CONSTRAINT uq_azienda_partita_iva UNIQUE (partita_iva),
    ADD CONSTRAINT uq_azienda_cod_identificativo UNIQUE (cod_identificativo),
    ADD CONSTRAINT ck_azienda_partita_iva CHECK (partita_iva ~ '^[0-9]{11}$'),
    ADD CONSTRAINT ck_azienda_email CHECK (email IS NULL OR email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    ADD CONSTRAINT ck_azienda_telefono CHECK (telefono IS NULL OR telefono ~ '^[+]?[0-9 ()\-]{6,20}$');
--Responsabile
ALTER TABLE responsabile
    ADD CONSTRAINT ck_responsabile_data_nascita CHECK (data_nascita IS NULL OR data_nascita > DATE '1900-01-01'),
    ADD CONSTRAINT ck_responsabile_email CHECK (email IS NULL OR email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    ADD CONSTRAINT ck_responsabile_telefono CHECK (telefono IS NULL OR telefono ~ '^[+]?[0-9 ()\-]{6,20}$');
--Asset
ALTER TABLE asset
    ADD CONSTRAINT ck_asset_criticita CHECK (criticita IN ('BASSA', 'MEDIA', 'ALTA', 'CRITICA')),
    ADD CONSTRAINT ck_asset_data_creazione CHECK (data_creazione > DATE '1900-01-01'),
    ADD CONSTRAINT ck_asset_data_aggiornamento CHECK (data_aggiornamento >= data_creazione);
--Servizio
ALTER TABLE servizio
    ADD CONSTRAINT ck_servizio_criticita CHECK (criticita IN ('BASSA', 'MEDIA', 'ALTA', 'CRITICA')),
    ADD CONSTRAINT ck_servizio_data_creazione CHECK (data_creazione > DATE '1900-01-01'),
    ADD CONSTRAINT ck_servizio_data_aggiornamento CHECK (data_aggiornamento >= data_creazione);
--Forntitore
ALTER TABLE fornitore
    ADD CONSTRAINT ck_fornitore_email CHECK (email IS NULL OR email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    ADD CONSTRAINT ck_fornitore_telefono CHECK (telefono IS NULL OR telefono ~ '^[+]?[0-9 ()\-]{6,20}$');
--punto_contatto
ALTER TABLE punto_contatto
    ADD CONSTRAINT ck_contatto_email CHECK (email IS NULL OR email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    ADD CONSTRAINT ck_contatto_telefono CHECK (telefono IS NULL OR telefono ~ '^[+]?[0-9 ()\-]{6,20}$');
--servizio_fortnitore
ALTER TABLE servizio_fornitore
    ADD CONSTRAINT ck_servizio_fornitore_criticita CHECK (criticita IN ('BASSA', 'MEDIA', 'ALTA', 'CRITICA'));
--storico_asset
ALTER TABLE storico_asset
    ADD CONSTRAINT ck_storico_asset_versione CHECK (versione > 0),
    ADD CONSTRAINT ck_storico_asset_criticita CHECK (criticita IS NULL OR criticita IN ('BASSA', 'MEDIA', 'ALTA', 'CRITICA')),
    ADD CONSTRAINT ck_storico_asset_data_inizio CHECK (data_inizio > DATE '1900-01-01'),
    ADD CONSTRAINT ck_storico_asset_data_fine CHECK (data_fine IS NULL OR data_fine >= data_inizio),
    ADD CONSTRAINT ck_storico_asset_tipo_operazione CHECK (tipo_operazione IN ('INSERT', 'UPDATE', 'DELETE')),
    ADD CONSTRAINT uq_storico_asset_versione UNIQUE (id_asset, versione);
--storico_servizio
ALTER TABLE storico_servizio
    ADD CONSTRAINT ck_storico_servizio_versione CHECK (versione > 0),
    ADD CONSTRAINT ck_storico_servizio_criticita CHECK (criticita IS NULL OR criticita IN ('BASSA', 'MEDIA', 'ALTA', 'CRITICA')),
    ADD CONSTRAINT ck_storico_servizio_data_inizio CHECK (data_inizio > DATE '1900-01-01'),
    ADD CONSTRAINT ck_storico_servizio_data_fine CHECK (data_fine IS NULL OR data_fine >= data_inizio),
    ADD CONSTRAINT ck_storico_servizio_tipo_operazione CHECK (tipo_operazione IN ('INSERT', 'UPDATE', 'DELETE')),
   ADD CONSTRAINT uq_storico_servizio_versione UNIQUE (id_servizio, versione);
