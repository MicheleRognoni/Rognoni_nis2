--6.QueryACN.sql
-- Questo crea una view che può richiamare come se fosse una tabella. 
--Serve a otterre un unica estrazione di tutte le informazioni presenti per il profilo ACN
--(azienda,asset,servizi,resposabile,fornitori)

CREATE OR REPLACE VIEW viewProfilo_acn AS --CREATE or REPLEACE, se la view esiste già viene aggioranta senza doverla eliminare
SELECT                                    -- viewProfilo_acn è il nome della view che trovi in datagrip in public-->view-->viewProfilo_acn
    az.ragione_sociale          AS azienda, --qui creiamo per comodità degli alias
    a.nome                      AS asset,
    a.criticita                 AS criticita_asset,
    s.nome                      AS servizio,
    s.criticita                 AS criticita_servizio,
    r.nome || ' ' || r.cognome  AS responsabile,
    f.ragione_sociale           AS fornitore,
    sf.tipo_dipendenza          AS tipo_dipendenza,
    sf.criticita                AS criticita_dipendenza,
    pc.nome || ' ' || pc.cognome AS punto_contatto,
    pc.email                    AS email_contatto
FROM azienda az
JOIN asset a               ON a.id_azienda = az.id_azienda
JOIN asset_servizio asv     ON asv.id_asset = a.id_asset
JOIN servizio s             ON s.id_servizio = asv.id_servizio
JOIN responsabile r         ON r.id_responsabile = s.id_responsabile
LEFT JOIN servizio_fornitore sf ON sf.id_servizio = s.id_servizio --usiamo LEFT JOIN perchè se un servizio non ha ancora un fornitore associato 
LEFT JOIN fornitore f            ON f.id_fornitore = sf.id_fornitore  --continuerà comunque a comparire nella view creata.
LEFT JOIN punto_contatto pc      ON pc.id_fornitore = f.id_fornitore; --mentre i campi del fortiore risulteranno vuoti.

-- Esempio di utilizzo, filtrato per una singola azienda:
-- SELECT * FROM viewProfilo_acn WHERE azienda = 'Nome Azienda SpA';

-- Query di supporto già previste inserite anche nella documentazione

-- Elenco asset per azienda
-- SELECT * FROM asset WHERE id_azienda = :id_azienda;

-- Asset critici per azienda
-- SELECT * FROM asset WHERE id_azienda = :id_azienda AND criticita IN ('ALTA','CRITICA');

-- Servizi erogati per azienda
-- SELECT * FROM servizio WHERE id_azienda = :id_azienda;

-- Dipendenze da fornitori per azienda
-- SELECT s.nome AS servizio, f.ragione_sociale AS fornitore, sf.tipo_dipendenza, sf.criticita
-- FROM servizio s
-- JOIN servizio_fornitore sf ON sf.id_servizio = s.id_servizio
-- JOIN fornitore f ON f.id_fornitore = sf.id_fornitore
-- WHERE s.id_azienda = :id_azienda;
