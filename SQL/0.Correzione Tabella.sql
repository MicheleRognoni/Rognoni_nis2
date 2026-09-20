-- Correzione: questo programma serve per correggere un errore creato in fasi progettazione
-- le chiavi esterne di storico_asset e storico_servizio verso
-- asset/servizio erano ON DELETE CASCADE, il che cancellerebbe
-- lo storico se un asset/servizio venisse eliminato fisicamente,
-- questo programma fa un UPDATE e cambia l'indice da CASCADE a RESTRICT, 

ALTER TABLE storico_asset
    DROP CONSTRAINT storico_asset_id_asset_fkey,
    ADD CONSTRAINT storico_asset_id_asset_fkey
        FOREIGN KEY (id_asset) REFERENCES asset (id_asset)
        ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE storico_servizio
    DROP CONSTRAINT storico_servizio_id_servizio_fkey,
    ADD CONSTRAINT storico_servizio_id_servizio_fkey
        FOREIGN KEY (id_servizio) REFERENCES servizio (id_servizio)
        ON UPDATE CASCADE ON DELETE RESTRICT;
