-- 5.inserimentoRecord.sql
-- Dataset simulato per verificare integrità e query.
-- Va eseguito DOPO 4.Trigger.sql, così lo storico di asset
-- e servizi viene popolato automaticamente dai trigger.

-- Azienda
INSERT INTO azienda (ragione_sociale, partita_iva, cod_identificativo, email, telefono) VALUES
('Rognoni S.p.A.', '12345678999', 'ACN-2026-044', 'rognonispa@rognoni.it', '+39 012 3356677');

-- Categoria_asset
INSERT INTO categoria_asset (nome, descrizione) VALUES
('Server', 'Server fisici e virtuali'),
('Rete', 'Apparati di rete: switch, router, firewall'),
('Rete Interna', 'Apparati di rete dedicati alla LAN aziendale'),
('Endpoint', 'Postazioni di lavoro e dispositivi utente'),
('Applicativo', 'Software e applicazioni gestionali'),
('Storage', 'Sistemi di archiviazione dati');

-- Responsabile
INSERT INTO responsabile (id_azienda, nome, cognome, data_nascita, ruolo, email, telefono)
SELECT id_azienda, 'Michele', 'Rognoni', '1980-05-12', 'IT Manager', 'michele.rognoni@rognoni-cyber.it', '+39 333 1112222'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';

INSERT INTO responsabile (id_azienda, nome, cognome, data_nascita, ruolo, email, telefono)
SELECT id_azienda, 'Giorgia', 'Vai', '2007-09-23', 'Security Officer', 'giorgia.vai@rognoni-cyber.it', '+39 333 3334444'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';

INSERT INTO responsabile (id_azienda, nome, cognome, data_nascita, ruolo, email, telefono)
SELECT id_azienda, 'Chiara', 'Ferraro', '1991-02-14', 'Head of Infrastructure', 'chiara.ferraro@rognoni-cyber.it', '+39 345 1119988'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';

-- Inserimento dati nella tabella Asset (grazie ai trigger creati prima, popoleranno automaticamente storico_asset)
-- uso gli alias az/c/r per evitare ambiguità tra le tre tabelle nel FROM
INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, descrizione, criticita, stato)
SELECT az.id_azienda, c.id_categoria, r.id_responsabile,
       'Server ERP', 'Server principale del gestionale aziendale', 'CRITICA', TRUE
FROM azienda az, categoria_asset c, responsabile r
WHERE az.ragione_sociale = 'Rognoni S.p.A.' AND c.nome = 'Server'
  AND r.nome = 'Michele' AND r.cognome = 'Rognoni';

INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, descrizione, criticita, stato)
SELECT az.id_azienda, c.id_categoria, r.id_responsabile,
       'Firewall interno', 'Firewall di frontiera per la rete aziendale', 'ALTA', TRUE
FROM azienda az, categoria_asset c, responsabile r
WHERE az.ragione_sociale = 'Rognoni S.p.A.' AND c.nome = 'Rete'
  AND r.nome = 'Giorgia' AND r.cognome = 'Vai';

INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, descrizione, criticita, stato)
SELECT az.id_azienda, c.id_categoria, r.id_responsabile,
       'Portale clienti', 'Applicativo web per la gestione clienti', 'MEDIA', TRUE
FROM azienda az, categoria_asset c, responsabile r
WHERE az.ragione_sociale = 'Rognoni S.p.A.' AND c.nome = 'Applicativo'
  AND r.nome = 'Michele' AND r.cognome = 'Rognoni';

INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, descrizione, criticita, stato)
SELECT az.id_azienda, c.id_categoria, r.id_responsabile,
       'Laptop reparto IT', 'Postazioni di lavoro del team IT', 'BASSA', TRUE
FROM azienda az, categoria_asset c, responsabile r
WHERE az.ragione_sociale = 'Rognoni S.p.A.' AND c.nome = 'Endpoint'
  AND r.nome = 'Giorgia' AND r.cognome = 'Vai';

INSERT INTO asset (id_azienda, id_categoria, id_responsabile, nome, descrizione, criticita, stato)
SELECT az.id_azienda, c.id_categoria, r.id_responsabile,
       'NAS backup secondario', 'Copia di riserva dei repository di codice', 'MEDIA', TRUE
FROM azienda az, categoria_asset c, responsabile r
WHERE az.ragione_sociale = 'Rognoni S.p.A.' AND c.nome = 'Storage'
  AND r.nome = 'Chiara' AND r.cognome = 'Ferraro';

-- Inserimento dati nella tabella Servizio (grazie ai trigger creati in precedenza, popoleranno automaticamente storico_servizio)
INSERT INTO servizio (id_azienda, id_responsabile, nome, descrizione, criticita, stato)
SELECT az.id_azienda, r.id_responsabile, 'Gestione ordini', 'Servizio ERP per la gestione degli ordini', 'CRITICA', TRUE
FROM azienda az, responsabile r
WHERE az.ragione_sociale = 'Rognoni S.p.A.' AND r.nome = 'Michele' AND r.cognome = 'Rognoni';

INSERT INTO servizio (id_azienda, id_responsabile, nome, descrizione, criticita, stato)
SELECT az.id_azienda, r.id_responsabile, 'Accesso remoto sicuro', 'VPN aziendale per i collaboratori', 'ALTA', TRUE
FROM azienda az, responsabile r
WHERE az.ragione_sociale = 'Rognoni S.p.A.' AND r.nome = 'Giorgia' AND r.cognome = 'Vai';

INSERT INTO servizio (id_azienda, id_responsabile, nome, descrizione, criticita, stato)
SELECT az.id_azienda, r.id_responsabile, 'Portale self-service clienti', 'Servizio web esposto ai clienti finali', 'MEDIA', TRUE
FROM azienda az, responsabile r
WHERE az.ragione_sociale = 'Rognoni S.p.A.' AND r.nome = 'Michele' AND r.cognome = 'Rognoni';

INSERT INTO servizio (id_azienda, id_responsabile, nome, descrizione, criticita, stato)
SELECT az.id_azienda, r.id_responsabile, 'Backup automatico repository', 'Salvataggio periodico del codice sorgente', 'MEDIA', TRUE
FROM azienda az, responsabile r
WHERE az.ragione_sociale = 'Rognoni S.p.A.' AND r.nome = 'Chiara' AND r.cognome = 'Ferraro';

-- Inserimento dati nella tabella Fornitore
INSERT INTO fornitore (id_azienda, ragione_sociale, tipologia, referente, email, telefono)
SELECT id_azienda, 'CloudHost S.r.l.', 'Hosting e infrastruttura cloud', 'Luca Verdi', 'assistenza@cloudhost.it', '+39 06 9998888'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';

INSERT INTO fornitore (id_azienda, ragione_sociale, tipologia, referente, email, telefono)
SELECT id_azienda, 'ServerFarm Alpi S.p.A.', 'Hosting on-premise e colocation', 'Marco Bianchi', 'noc@serverfarmalpi.it', '+39 0461 778899'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';

-- Nuovi fornitori (mancavano gli INSERT, li aggiungo qui)
INSERT INTO fornitore (id_azienda, ragione_sociale, tipologia, referente, email, telefono)
SELECT id_azienda, 'ServerFarm Europa S.p.A.', 'Hosting e disaster recovery', 'Sonia Bonoldi', 'info@serverfarmeuropa.it', '+39 02 8887766'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';

INSERT INTO fornitore (id_azienda, ragione_sociale, tipologia, referente, email, telefono)
SELECT id_azienda, 'SecureNet Solutions', 'Servizi di sicurezza gestita (MSSP)', 'Anna Neri', 'support@securenet.it', '+39 011 4445555'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';

-- Inserimento dati nella tabella Punto_contatto
INSERT INTO punto_contatto (id_fornitore, nome, cognome, ruolo, email, telefono, tipo_contatto)
SELECT id_fornitore, 'Matteo', 'Venturini', 'Account Manager', 'matteo.venturini@cloudhost.it', '+39 06 9998889', 'Commerciale'
FROM fornitore WHERE ragione_sociale = 'CloudHost S.r.l.';

INSERT INTO punto_contatto (id_fornitore, nome, cognome, ruolo, email, telefono, tipo_contatto)
SELECT id_fornitore, 'Sonia', 'Bonoldi', 'Supporto tecnico 24/7', 'sonia.bonoldi@serverfarmeuropa.it', '+39 02 8887767', 'Tecnico'
FROM fornitore WHERE ragione_sociale = 'ServerFarm Europa S.p.A.';

INSERT INTO punto_contatto (id_fornitore, nome, cognome, ruolo, email, telefono, tipo_contatto)
SELECT id_fornitore, 'Anna', 'Neri', 'SOC Manager', 'anna.neri@securenet.it', '+39 011 4445556', 'Sicurezza'
FROM fornitore WHERE ragione_sociale = 'SecureNet Solutions';

-- Inserimento dati nella tabella Asset_servizio (N:M)
INSERT INTO asset_servizio (id_asset, id_servizio, tipo_supporto, note)
SELECT a.id_asset, s.id_servizio, 'Hosting applicativo', 'Il server ERP eroga il servizio di gestione ordini'
FROM asset a, servizio s
WHERE a.nome = 'Server ERP' AND s.nome = 'Gestione ordini';

INSERT INTO asset_servizio (id_asset, id_servizio, tipo_supporto, note)
SELECT a.id_asset, s.id_servizio, 'Protezione perimetrale', 'Il firewall protegge l''accesso remoto sicuro'
FROM asset a, servizio s
WHERE a.nome = 'Firewall interno' AND s.nome = 'Accesso remoto sicuro';

INSERT INTO asset_servizio (id_asset, id_servizio, tipo_supporto, note)
SELECT a.id_asset, s.id_servizio, 'Hosting applicativo', 'Il portale clienti eroga il servizio self-service'
FROM asset a, servizio s
WHERE a.nome = 'Portale clienti' AND s.nome = 'Portale self-service clienti';

INSERT INTO asset_servizio (id_asset, id_servizio, tipo_supporto, note)
SELECT a.id_asset, s.id_servizio, 'Archiviazione backup', 'Il NAS conserva le copie generate dal backup automatico'
FROM asset a, servizio s
WHERE a.nome = 'NAS backup secondario' AND s.nome = 'Backup automatico repository';

-- Inserimento dati nella tabella Servizio_fornitore (N:M)
INSERT INTO servizio_fornitore (id_servizio, id_fornitore, tipo_dipendenza, criticita, descrizione)
SELECT s.id_servizio, f.id_fornitore, 'Infrastruttura cloud', 'CRITICA', 'Il servizio gira su infrastruttura ospitata da CloudHost'
FROM servizio s, fornitore f
WHERE s.nome = 'Gestione ordini' AND f.ragione_sociale = 'CloudHost S.r.l.';

INSERT INTO servizio_fornitore (id_servizio, id_fornitore, tipo_dipendenza, criticita, descrizione)
SELECT s.id_servizio, f.id_fornitore, 'Monitoraggio sicurezza', 'ALTA', 'SecureNet monitora gli accessi remoti in ottica SOC'
FROM servizio s, fornitore f
WHERE s.nome = 'Accesso remoto sicuro' AND f.ragione_sociale = 'SecureNet Solutions';

INSERT INTO servizio_fornitore (id_servizio, id_fornitore, tipo_dipendenza, criticita, descrizione)
SELECT s.id_servizio, f.id_fornitore, 'Infrastruttura cloud', 'MEDIA', 'Il portale clienti gira su infrastruttura CloudHost'
FROM servizio s, fornitore f
WHERE s.nome = 'Portale self-service clienti' AND f.ragione_sociale = 'CloudHost S.r.l.';

INSERT INTO servizio_fornitore (id_servizio, id_fornitore, tipo_dipendenza, criticita, descrizione)
SELECT s.id_servizio, f.id_fornitore, 'Disaster recovery', 'MEDIA', 'ServerFarm Europa fornisce il sito di backup del repository'
FROM servizio s, fornitore f
WHERE s.nome = 'Backup automatico repository' AND f.ragione_sociale = 'ServerFarm Europa S.p.A.';

-- Inserimento dati nella tabella Metadato
INSERT INTO metadato (id_azienda, nome, valore, tipo, descrizione)
SELECT id_azienda, 'Settore ACN', 'Servizi digitali', 'TESTO', 'Settore di appartenenza secondo la classificazione ACN'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';

INSERT INTO metadato (id_azienda, nome, valore, tipo, descrizione)
SELECT id_azienda, 'Ultima revisione profilo', CURRENT_DATE::TEXT, 'DATA', 'Data dell''ultimo aggiornamento del profilo ACN'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';

INSERT INTO metadato (id_azienda, nome, valore, tipo, descrizione)
SELECT id_azienda, 'Note interne', 'Migrazione al nuovo NAS prevista entro fine anno', 'TESTO', 'Promemoria libero per il team infrastruttura'
FROM azienda WHERE ragione_sociale = 'Rognoni S.p.A.';