-- 4.Trigger 
-- Il compito principale serve per la gestione automatica dello storico delle entità Asset e Servizo
-- Ad ogni INSERT o UPDATE viene creata una nuova riga in Storico_asset / Storico_servizio; 
-- la versione in modo che lo storico venga tracciato fin dal primo inserimento

-- Funzione + trigger per Asset
CREATE OR REPLACE FUNCTION fn_storico_asset() RETURNS TRIGGER AS $$
DECLARE
    v_versione INTEGER;
BEGIN
    IF TG_OP = 'INSERT' THEN -- TG_OP indica l'operazione che si intende effettuare in questo caso 'INSERT'
                             -- Viene usato 'INSERT quando vogliamo inserire un nuovo recordo
        INSERT INTO storico_asset
            (id_asset, versione, nome, descrizione, criticita, stato, data_inizio, data_fine, utente_modifica, tipo_operazione)
        VALUES
            (NEW.id_asset, 1, NEW.nome, NEW.descrizione, NEW.criticita, NEW.stato, CURRENT_DATE, NULL, CURRENT_USER, 'INSERT'); --indica con NEW dati nuovi del record
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN --In questo caso quando viene usato 'UPDATE' viene modificato l'asset
        -- chiude la versione corrente (quella con data_fine ancora NULL)
        UPDATE storico_asset
           SET data_fine = CURRENT_DATE
         WHERE id_asset = OLD.id_asset AND data_fine IS NULL; --OLD contiene i dati del record prima della modifica

        SELECT COALESCE(MAX(versione), 0) + 1 INTO v_versione --MAX(versione) recupera la versione più alta esistente
                                                              --COALESCE serve ad evitare problemi in caso non esistesse alcuna versione, si aggiunge +1 come in un contatore
          FROM storico_asset WHERE id_asset = NEW.id_asset;

        INSERT INTO storico_asset
            (id_asset, versione, nome, descrizione, criticita, stato, data_inizio, data_fine, utente_modifica, tipo_operazione)
        VALUES
            (NEW.id_asset, v_versione, NEW.nome, NEW.descrizione, NEW.criticita, NEW.stato, CURRENT_DATE, NULL, CURRENT_USER, 'UPDATE');
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_storico_asset ON asset;
CREATE TRIGGER trg_storico_asset
AFTER INSERT OR UPDATE ON asset
FOR EACH ROW EXECUTE FUNCTION fn_storico_asset();

-- Funzione + trigger per Servizio (stessa logica)
CREATE OR REPLACE FUNCTION fn_storico_servizio() RETURNS TRIGGER AS $$
DECLARE
    v_versione INTEGER;
BEGIN
    IF TG_OP = 'INSERT' THEN --In questo caso quando viene usato 'INSERT' viene aggiunto l'asset
        INSERT INTO storico_servizio
            (id_servizio, versione, nome, descrizione, criticita, stato, data_inizio, data_fine, utente_modifica, tipo_operazione)
        VALUES
            (NEW.id_servizio, 1, NEW.nome, NEW.descrizione, NEW.criticita, NEW.stato, CURRENT_DATE, NULL, CURRENT_USER, 'INSERT');
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN --In questo caso quando viene usato 'UPDATE' viene modificato il servizio
        UPDATE storico_servizio
           SET data_fine = CURRENT_DATE
         WHERE id_servizio = OLD.id_servizio AND data_fine IS NULL;

        SELECT COALESCE(MAX(versione), 0) + 1 INTO v_versione
          FROM storico_servizio WHERE id_servizio = NEW.id_servizio;

        INSERT INTO storico_servizio
            (id_servizio, versione, nome, descrizione, criticita, stato, data_inizio, data_fine, utente_modifica, tipo_operazione)
        VALUES
            (NEW.id_servizio, v_versione, NEW.nome, NEW.descrizione, NEW.criticita, NEW.stato, CURRENT_DATE, NULL, CURRENT_USER, 'UPDATE');
        RETURN NEW;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_storico_servizio ON servizio;
CREATE TRIGGER trg_storico_servizio
AFTER INSERT OR UPDATE ON servizio
FOR EACH ROW EXECUTE FUNCTION fn_storico_servizio();


