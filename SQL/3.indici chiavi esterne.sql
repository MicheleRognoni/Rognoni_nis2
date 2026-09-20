--3.indici chiavi esterne

-- Responsabile 
-- Viene usato per velocizzare la ricerca dei resposabili
CREATE INDEX idx_responsabile_azienda ON responsabile (id_azienda);

-- Asset
--Indici sulle chiavi esterne, usate oer collegare agli asset alle tabelle azienda,categoria,resposabile.
CREATE INDEX idx_asset_azienda        ON asset (id_azienda);
CREATE INDEX idx_asset_categoria      ON asset (id_categoria);
CREATE INDEX idx_asset_responsabile   ON asset (id_responsabile);
CREATE INDEX idx_asset_criticita      ON asset (criticita);
CREATE INDEX idx_asset_stato          ON asset (stato);

-- Servizio
CREATE INDEX idx_servizio_azienda       ON servizio (id_azienda);
CREATE INDEX idx_servizio_responsabile  ON servizio (id_responsabile);
CREATE INDEX idx_servizio_criticita     ON servizio (criticita);
CREATE INDEX idx_servizio_stato         ON servizio (stato);

-- Fornitore
CREATE INDEX idx_fornitore_azienda ON fornitore (id_azienda);

-- Punto_contatto
CREATE INDEX idx_contatto_fornitore ON punto_contatto (id_fornitore);

-- Metadato
CREATE INDEX idx_metadato_azienda ON metadato (id_azienda);

-- Asset_servizio
-- La chiave primaria composta indicizza già la coppia
-- (id_asset, id_servizio), questo indice aggiuntivo su id_servizio
-- serve per velocizzare le ricerche degli asset che supportano un servizio
CREATE INDEX idx_asset_servizio_servizio ON asset_servizio (id_servizio);

-- Servizio_fornitore (stesso discorso detto per asset_servizio, indice sulla sola id_fornitore)
CREATE INDEX idx_servizio_fornitore_fornitore ON servizio_fornitore (id_fornitore);
CREATE INDEX idx_servizio_fornitore_criticita ON servizio_fornitore (criticita);

-- Storico_asset
CREATE INDEX idx_storico_asset_asset ON storico_asset (id_asset);

-- Storico_servizio
CREATE INDEX idx_storico_servizio_servizio ON storico_servizio (id_servizio);
