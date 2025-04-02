------------------------------------------------------------------------
-- Active le mode script Oracle s’il faut
------------------------------------------------------------------------
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

------------------------------------------------------------------------
-- VUES MATERIALISEES
------------------------------------------------------------------------

-- 1) TICKETS_GLOBAL
CREATE MATERIALIZED VIEW CYPI_PAU.TICKETS_GLOBAL
AS
SELECT
    E.ville AS emplacement,
    T.id_ticket,
    T.titre,
    U.nom || ' ' || U.prenom AS cree_par,
    U.email AS email_createur,
    ASS.utilisateurs_attribues AS attribue_a,
    ASS.emails_attribues AS emails_attribues,
    OBS.utilisateurs_observateurs AS observateurs,
    OBS.emails_observateurs AS emails_observateurs,
    TT."type" AS type,
    P."priorite" AS priorite,
    T."description",
    T.date_creation,
    T.date_modification,
    T.date_resolution,
    T.note_resolution,
    T.date_cloture,
    S.statut AS statut,
    C."categorie" AS categorie,
    M."nom" || ', ' || M."modele" || ', ' || M.marque || ', ' || TO_CHAR(M.date_achat, 'DD-MON-YYYY') AS materiel,
    G."groupe" AS groupe_attribue,
    LC1.id_commentaire AS "Dernier Commentaire ID",
    LC1."contenu" AS "Dernier Commentaire",
    LC2.id_commentaire AS "Avant-Dernier Commentaire ID",
    LC2."contenu" AS "Avant-Dernier Commentaire"
FROM CYPI_PAU.TICKETS T
JOIN CYPI_PAU.UTILISATEURS U ON T.fk_createur = U.id_utilisateur
JOIN CYPI_PAU.PRIORITES_TICKETS P ON T.fk_priorite = P.id_priorite
JOIN CYPI_PAU.TYPES_TICKETS TT ON T.fk_type = TT.id_type
JOIN CYPI_PAU.EMPLACEMENTS E ON T.fk_emplacement = E.id_emplacement
JOIN CYPI_PAU.CATEGORIES_TICKETS C ON T.fk_categorie = C.id_categorie
JOIN CYPI_PAU.STATUTS_TICKETS S ON T.fk_statut = S.id_statut
LEFT JOIN CYPI_PAU.MATERIELS M ON T.fk_materiel = M.id_materiel
LEFT JOIN CYPI_PAU.GROUPES_UTILISATEURS G ON T.fk_groupe_attribue = G.id_groupe
LEFT JOIN (
    SELECT fk_ticket, id_commentaire, "contenu", 
           ROW_NUMBER() OVER(PARTITION BY fk_ticket ORDER BY date_creation DESC) AS rn
    FROM CYPI_PAU.COMMENTAIRES_TICKETS
) LC1 ON T.id_ticket = LC1.fk_ticket AND LC1.rn = 1
LEFT JOIN (
    SELECT fk_ticket, id_commentaire, "contenu", 
           ROW_NUMBER() OVER(PARTITION BY fk_ticket ORDER BY date_creation DESC) AS rn
    FROM CYPI_PAU.COMMENTAIRES_TICKETS
) LC2 ON T.id_ticket = LC2.fk_ticket AND LC2.rn = 2
LEFT JOIN (
    SELECT
        T.id_ticket,
        LISTAGG(U.nom || ' ' || U.prenom || ' ; ') WITHIN GROUP (ORDER BY AT.fk_utilisateur) AS utilisateurs_attribues,
        LISTAGG(U.email || ' ; ') WITHIN GROUP (ORDER BY AT.fk_utilisateur) AS emails_attribues
    FROM CYPI_PAU.TICKETS T
    JOIN CYPI_PAU.ATTRIBUTIONS_TICKETS AT
        ON T.id_ticket = AT.fk_ticket
    JOIN CYPI_PAU.UTILISATEURS U
        ON AT.fk_utilisateur = U.id_utilisateur
    GROUP BY T.id_ticket
) ASS ON ASS.id_ticket = T.id_ticket
LEFT JOIN (
    SELECT
        T.id_ticket,
        LISTAGG(U.nom || ' ' || U.prenom || ' ; ') WITHIN GROUP (ORDER BY O.fk_utilisateur) AS utilisateurs_observateurs,
        LISTAGG(U.email || ' ; ') WITHIN GROUP (ORDER BY O.fk_utilisateur) AS emails_observateurs
    FROM CYPI_PAU.TICKETS T
    JOIN CYPI_PAU.OBSERVATEURS_TICKETS O
        ON T.id_ticket = O.fk_ticket
    JOIN CYPI_PAU.UTILISATEURS U
        ON O.fk_utilisateur = U.id_utilisateur
    GROUP BY T.id_ticket
) OBS ON OBS.id_ticket = T.id_ticket;


-- 2) TICKETS_PAR_CATEGORIE
CREATE MATERIALIZED VIEW CYPI_PAU.TICKETS_PAR_CATEGORIE AS
SELECT C."categorie", COUNT(*) AS nombre_tickets
FROM CYPI_PAU.TICKETS
JOIN CYPI_PAU.CATEGORIES_TICKETS C ON TICKETS.fk_categorie = C.id_categorie
GROUP BY C."categorie";


-- 3) TICKETS_PAR_EMPLACEMENT
CREATE MATERIALIZED VIEW CYPI_PAU.TICKETS_PAR_EMPLACEMENT AS
SELECT E."emplacement", COUNT(*) AS nombre_tickets
FROM CYPI_PAU.TICKETS
JOIN CYPI_PAU.EMPLACEMENTS E ON TICKETS.fk_emplacement = E.id_emplacement
GROUP BY E."emplacement";


-- 4) TEMPS_RESOLUTION_TICKETS
CREATE MATERIALIZED VIEW CYPI_PAU.TEMPS_RESOLUTION_TICKETS AS
SELECT 
    TRUNC(AVG(JOURS_RESOLUTION)) AS jours_moyens,
    TRUNC(MOD(AVG(JOURS_RESOLUTION) * 24, 24)) AS heures_moyennes,
    TRUNC(MOD(AVG(JOURS_RESOLUTION) * 24 * 60, 60)) AS minutes_moyennes,
    TRUNC(MOD(AVG(JOURS_RESOLUTION) * 24 * 60 * 60, 60)) AS secondes_moyennes
FROM (
    SELECT 
        AVG(EXTRACT(DAY FROM interval_resolution)) AS JOURS_RESOLUTION
    FROM (
        SELECT 
            date_resolution - date_creation AS interval_resolution
        FROM CYPI_PAU.TICKETS
        WHERE date_resolution IS NOT NULL
    )
);


-- 5) ACTIVITE_RECENTE_TICKETS
CREATE MATERIALIZED VIEW CYPI_PAU.ACTIVITE_RECENTE_TICKETS AS
SELECT id_ticket, titre, date_modification
FROM (
    SELECT id_ticket, titre, date_modification
    FROM CYPI_PAU.TICKETS
    ORDER BY date_modification DESC
)
WHERE ROWNUM <= 100;

------------------------------------------------------------------------
-- VUES SIMPLES
------------------------------------------------------------------------

-- 6) TICKETS_OUVERTS_PAR_CATEGORIE
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_OUVERTS_PAR_CATEGORIE AS
SELECT C."categorie", S.statut, COUNT(*) AS tickets_ouverts
FROM CYPI_PAU.TICKETS T
JOIN CYPI_PAU.CATEGORIES_TICKETS C ON T.fk_categorie = C.id_categorie
JOIN CYPI_PAU.STATUTS_TICKETS S ON T.fk_statut = S.id_statut
WHERE UPPER(S.statut) = 'A FAIRE' OR UPPER(S.statut) = 'EN COURS'
GROUP BY C."categorie", S.statut;


-- 7) TICKETS_CLOTURES
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_CLOTURES AS
SELECT T.*, S.statut
FROM CYPI_PAU.TICKETS T
JOIN CYPI_PAU.STATUTS_TICKETS S ON T.fk_statut = S.id_statut
WHERE S.statut = 'TERMINE';


-- 8) TICKETS_PAR_PRIORITE
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_PAR_PRIORITE AS
SELECT P."priorite", COUNT(*) AS nombre_tickets
FROM CYPI_PAU.TICKETS
JOIN CYPI_PAU.PRIORITES_TICKETS P ON TICKETS.fk_priorite = P.id_priorite
GROUP BY P."priorite";


-- 9) TICKETS_PAR_STATUT
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_PAR_STATUT AS
SELECT S.statut, COUNT(*) AS nombre_tickets
FROM CYPI_PAU.TICKETS
JOIN CYPI_PAU.STATUTS_TICKETS S ON TICKETS.fk_statut = S.id_statut
GROUP BY S.statut;


-- 10) TICKETS_PAR_TYPE
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_PAR_TYPE AS
SELECT TYP."type", COUNT(*) AS nombre_tickets
FROM CYPI_PAU.TICKETS
JOIN CYPI_PAU.TYPES_TICKETS TYP ON TICKETS.fk_type = TYP.id_type
GROUP BY TYP."type";


-- 11) TICKETS_PAR_UTILISATEUR
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_PAR_UTILISATEUR AS
SELECT
    U.id_utilisateur,
    (U.nom || ' ' || U.prenom) AS nom_complet,
    COUNT(T.id_ticket) AS nombre_tickets
FROM CYPI_PAU.UTILISATEURS U
LEFT JOIN CYPI_PAU.TICKETS T
    ON T.fk_createur = U.id_utilisateur
GROUP BY U.id_utilisateur, U.nom, U.prenom;

-- 12) TICKETS_EN_RETARD (ex: +7 jours, statut pas fermé/terminé)
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_EN_RETARD AS
SELECT t.*
FROM CYPI_PAU.TICKETS t
JOIN CYPI_PAU.STATUTS_TICKETS s ON t.fk_statut = s.id_statut
WHERE t.date_creation < (CURRENT_TIMESTAMP - INTERVAL '7' DAY)
  AND UPPER(s.statut) NOT IN ('FERMÉ', 'TERMINE');

-- 13) TICKETS_SANS_COMMENTAIRES
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_SANS_COMMENTAIRES AS
SELECT t.*
FROM CYPI_PAU.TICKETS t
WHERE NOT EXISTS (
    SELECT 1
    FROM CYPI_PAU.COMMENTAIRES_TICKETS c
    WHERE c.fk_ticket = t.id_ticket
);

-- 14) COMMENTAIRES_RECENTS
CREATE OR REPLACE VIEW CYPI_PAU.COMMENTAIRES_RECENTS AS
SELECT c.id_commentaire,
       c.fk_ticket,
       c.fk_utilisateur,
       (u.nom || ' ' || u.prenom) AS auteur_commentaire,
       c.date_creation,
       c."contenu",
       t.titre AS titre_ticket
FROM CYPI_PAU.COMMENTAIRES_TICKETS c
JOIN CYPI_PAU.UTILISATEURS u
    ON c.fk_utilisateur = u.id_utilisateur
JOIN CYPI_PAU.TICKETS t
    ON c.fk_ticket = t.id_ticket
ORDER BY c.date_creation DESC;

-- 15) TICKETS_PAR_GROUPE
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_PAR_GROUPE AS
SELECT 
    g.id_groupe,
    g."groupe" AS nom_groupe,
    COUNT(t.id_ticket) AS nb_tickets
FROM CYPI_PAU.GROUPES_UTILISATEURS g
LEFT JOIN CYPI_PAU.TICKETS t
    ON t.fk_groupe_attribue = g.id_groupe
GROUP BY g.id_groupe, g."groupe";

-- 16) ATTRIBUTIONS_DETAILLEES
CREATE OR REPLACE VIEW CYPI_PAU.ATTRIBUTIONS_DETAILLEES AS
SELECT 
    t.id_ticket,
    t.titre,
    u.id_utilisateur,
    (u.nom || ' ' || u.prenom) AS nom_complet,
    r."role" AS role_utilisateur,
    gr."groupe" AS groupe_utilisateur
FROM CYPI_PAU.ATTRIBUTIONS_TICKETS at
JOIN CYPI_PAU.TICKETS t
    ON at.fk_ticket = t.id_ticket
JOIN CYPI_PAU.UTILISATEURS u
    ON at.fk_utilisateur = u.id_utilisateur
LEFT JOIN CYPI_PAU.ROLES_UTILISATEURS r
    ON u.fk_role = r.id_role
LEFT JOIN CYPI_PAU.GROUPES_UTILISATEURS gr
    ON u.fk_groupe = gr.id_groupe;

-- 17) UTILISATEURS_SANS_TICKETS
CREATE OR REPLACE VIEW CYPI_PAU.UTILISATEURS_SANS_TICKETS AS
SELECT u.*
FROM CYPI_PAU.UTILISATEURS u
WHERE NOT EXISTS (
  SELECT 1 
  FROM CYPI_PAU.TICKETS t
  WHERE t.fk_createur = u.id_utilisateur
);

-- 18) TICKETS_PAR_JOUR
CREATE OR REPLACE VIEW CYPI_PAU.TICKETS_PAR_JOUR AS
SELECT
    TRUNC(date_creation) AS jour,
    COUNT(*) AS nb_tickets
FROM CYPI_PAU.TICKETS
GROUP BY TRUNC(date_creation)
ORDER BY jour;

COMMIT;
