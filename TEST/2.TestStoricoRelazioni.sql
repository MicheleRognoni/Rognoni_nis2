-- 2.TestStoricoRelazioni.sql 
-- Verifica il funzionamento dei trigger di storico, delle relazioni molti-a-molti e della protezione dalla cancellazione
-- fisica di asset/servizi con storico associato.
-- Ogni test ripulisce i dati che crea, per non alterare il dataset di riferimento.


--TEST 1:Verifica che dopo l'inserimento di un asset, il trigger crei automaticamente nla prima versione ella tabella storico
DO $$
DECLARE
    v_id_asset INTEGER;
    v_count    INTEGER;
BEGIN
    INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, criticita)
    SELECT id_azienda, 1, 1, 'Asset test storico insert', 'BASSA'
    FROM azienda LIMIT 1
    RETURNING id_asset INTO v_id_asset;

    SELECT COUNT(*) INTO v_count
    FROM storico_asset
    WHERE id_asset = v_id_asset AND versione = 1 AND tipo_operazione = 'INSERT' AND data_fine IS NULL;

    IF v_count = 1 THEN
        RAISE NOTICE 'PASS: il trigger ha correttamente creato la versione 1 nello storico dopo l''INSERT';
    ELSE
        RAISE NOTICE 'FAIL: nessuna riga di storico creata (o non conforme) dopo l''INSERT';
    END IF;

    -- pulizia
    DELETE FROM storico_asset WHERE id_asset = v_id_asset;
    DELETE FROM asset WHERE id_asset = v_id_asset;
END $$;

-- TEST 2: Verifica che, dopo la modifica di un asset, la versione precedente venga chiusa e viene creata una nuova 
DECLARE
    v_id_asset      INTEGER;
    v_versioni      INTEGER;
    v_v1_chiusa     BOOLEAN;
BEGIN
    INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, criticita)
    SELECT id_azienda, 1, 1, 'Asset test storico update', 'BASSA'
    FROM azienda LIMIT 1
    RETURNING id_asset INTO v_id_asset;

    UPDATE asset SET criticita = 'ALTA' WHERE id_asset = v_id_asset;

    SELECT COUNT(*) INTO v_versioni FROM storico_asset WHERE id_asset = v_id_asset;
    SELECT (data_fine IS NOT NULL) INTO v_v1_chiusa FROM storico_asset WHERE id_asset = v_id_asset AND versione = 1;

    IF v_versioni = 2 AND v_v1_chiusa THEN
        RAISE NOTICE 'PASS: l''UPDATE ha chiuso la versione 1 e creato correttamente la versione 2';
    ELSE
        RAISE NOTICE 'FAIL: comportamento dello storico dopo UPDATE non conforme (versioni trovate: %)', v_versioni;
    END IF;

    DELETE FROM storico_asset WHERE id_asset = v_id_asset;
    DELETE FROM asset WHERE id_asset = v_id_asset;
END $$;

-- TEST 3: Verifica la relazione N:M tra Asset e Servizio: lo stesso asset deve poter essere associato a più servizi
DO $$
DECLARE
    v_id_asset     INTEGER;
    v_id_serv_1    INTEGER;
    v_id_serv_2    INTEGER;
    v_count        INTEGER;
BEGIN
    INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, criticita)
    SELECT id_azienda, 1, 1, 'Asset test N:M', 'BASSA'
    FROM azienda LIMIT 1
    RETURNING id_asset INTO v_id_asset;

    INSERT INTO servizio (id_azienda, id_responsabile, nome, criticita)
    SELECT id_azienda, 1, 'Servizio test N:M 1', 'BASSA' FROM azienda LIMIT 1
    RETURNING id_servizio INTO v_id_serv_1;

    INSERT INTO servizio (id_azienda, id_responsabile, nome, criticita)
    SELECT id_azienda, 1, 'Servizio test N:M 2', 'BASSA' FROM azienda LIMIT 1
    RETURNING id_servizio INTO v_id_serv_2;

    INSERT INTO asset_servizio (id_asset, id_servizio) VALUES (v_id_asset, v_id_serv_1);  --Creiamo due collegamenti nella tabella associativa (asset_servizio)
    INSERT INTO asset_servizio (id_asset, id_servizio) VALUES (v_id_asset, v_id_serv_2);

    SELECT COUNT(*) INTO v_count FROM asset_servizio WHERE id_asset = v_id_asset;

    IF v_count = 2 THEN
        RAISE NOTICE 'PASS: lo stesso asset è stato collegato correttamente a 2 servizi diversi (N:M)';
    ELSE
        RAISE NOTICE 'FAIL: relazione N:M Asset_servizio non conforme (trovate % righe)', v_count;
    END IF;

    -- pulizia 
    DELETE FROM asset_servizio WHERE id_asset = v_id_asset;
    DELETE FROM storico_servizio WHERE id_servizio IN (v_id_serv_1, v_id_serv_2);
    DELETE FROM servizio WHERE id_servizio IN (v_id_serv_1, v_id_serv_2);
    DELETE FROM storico_asset WHERE id_asset = v_id_asset;
    DELETE FROM asset WHERE id_asset = v_id_asset;
END $$;