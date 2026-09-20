-- 1.TestVincoliDominio.sql
-- Verifica automatica dei vincoli di dominio e di integrità referenziale. 
-- Ogni test tenta un'operazione che DEVE fallire; se fallisce nel modo atteso
-- il vincolo funziona correttamente (PASS). 
-- Se l'operazione va a buon fine, il vincolo NON sta funzionando come previsto (FAIL).

-- All'inizio e alla fine di ogni test troviamo DO$$/END$$ questo permmette di eserguire un piccolo blocco, senza dover creare una vera e propria funzione

--TEST 1 controllo criticità
DO $$ 
BEGIN
    INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, criticita)
    SELECT id_azienda, 1, 1, 'Asset di test criticita', 'ALTISSIMA'
    FROM azienda LIMIT 1;

    RAISE NOTICE 'TEST 1 FAIL: inserito un asset con criticita non valida (ALTISSIMA)';
    DELETE FROM asset WHERE nome = 'Asset di test criticita';
EXCEPTION  --EXCEPTION intercetta l'errore previsto, serve per non interrompere lo script e proseguire al test successivo
    WHEN check_violation THEN
        RAISE NOTICE 'il CHECK su Asset.criticita ha correttamente rifiutato il valore non valido';
END $$;

--TEST 2 controllo del formato azienda.partita_iva
DO $$
BEGIN
    INSERT INTO azienda (ragione_sociale, partita_iva, cod_identificativo)
    VALUES ('Azienda Test PIVA', '123', 'TEST-PIVA-001');

    RAISE NOTICE 'TEST 2 FAIL: inserita una partita IVA non valida (123)';
    DELETE FROM azienda WHERE ragione_sociale = 'Azienda Test PIVA';
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'il CHECK sul formato di Azienda.partita_iva ha funzionato correttamente';
END $$;

--TEST 3 controllo UNIQUE
DO $$
DECLARE
    v_piva VARCHAR(11);
BEGIN
    SELECT partita_iva INTO v_piva FROM azienda LIMIT 1;

    INSERT INTO azienda (ragione_sociale, partita_iva, cod_identificativo)
    VALUES ('Azienda Duplicata', v_piva, 'TEST-DUP-001');

    RAISE NOTICE 'TEST 3 FAIL: inserita una partita IVA duplicata';
    DELETE FROM azienda WHERE ragione_sociale = 'Azienda Duplicata';
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'il vincolo UNIQUE su Azienda.partita_iva ha funzionato correttamente';
END $$;


--TEST 4: controllo chiave esterna FK
DO $$
BEGIN
    INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, criticita)
    VALUES (999999, 1, 1, 'Asset con azienda inesistente', 'BASSA');

    RAISE NOTICE 'TEST 4 FAIL: inserito un asset con id_azienda inesistente';
    DELETE FROM asset WHERE nome = 'Asset con azienda inesistente';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'la FK Asset.id_azienda ha correttamente rifiutato il riferimento inesistente';
END $$;

--TEST 5: Asset.data_aggiornamenti non può essere precedente a data_creazione
DO $$
BEGIN
    INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, criticita, data_creazione, data_aggiornamento)
    SELECT id_azienda, 1, 1, 'Asset con date incoerenti', 'BASSA', CURRENT_DATE, CURRENT_DATE - INTERVAL '10 days'
    FROM azienda LIMIT 1;

    RAISE NOTICE 'inserito un asset con data_aggiornamento precedente a data_creazione';
    DELETE FROM asset WHERE nome = 'Asset con date incoerenti';
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'il CHECK sulla coerenza delle date ha funzionato correttamente';
END $$;