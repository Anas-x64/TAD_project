ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
--  Création de la vue matérialisée principale avec tous les tickets.
CREATE MATERIALIZED VIEW CYPI_CERGY.TICKETS_GLOBAL
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
FROM CYPI_CERGY.TICKETS T
JOIN CYPI_CERGY.UTILISATEURS U ON T.fk_createur = U.id_utilisateur
JOIN CYPI_CERGY.PRIORITES_TICKETS P ON T.fk_priorite = P.id_priorite
JOIN CYPI_CERGY.TYPES_TICKETS TT ON T.fk_type = TT.id_type
JOIN CYPI_CERGY.EMPLACEMENTS E ON T.fk_emplacement = E.id_emplacement
JOIN CYPI_CERGY.CATEGORIES_TICKETS C ON T.fk_categorie = C.id_categorie
JOIN CYPI_CERGY.STATUTS_TICKETS S ON T.fk_statut = S.id_statut
LEFT JOIN CYPI_CERGY.MATERIELS M ON T.fk_materiel = M.id_materiel
LEFT JOIN CYPI_CERGY.GROUPES_UTILISATEURS G ON T.fk_groupe_attribue = G.id_groupe
LEFT JOIN (
    SELECT fk_ticket, id_commentaire, "contenu", 
           ROW_NUMBER() OVER(PARTITION BY fk_ticket ORDER BY date_creation DESC) AS rn
    FROM CYPI_CERGY.COMMENTAIRES_TICKETS
) LC1 ON T.id_ticket = LC1.fk_ticket AND LC1.rn = 1
LEFT JOIN (
    SELECT fk_ticket, id_commentaire, "contenu", 
           ROW_NUMBER() OVER(PARTITION BY fk_ticket ORDER BY date_creation DESC) AS rn
    FROM CYPI_CERGY.COMMENTAIRES_TICKETS
) LC2 ON T.id_ticket = LC2.fk_ticket AND LC2.rn = 2
LEFT JOIN (
    SELECT
        T.id_ticket,
        LISTAGG(U.nom || ' ' || U.prenom || ' ; ') WITHIN GROUP (ORDER BY AT.fk_utilisateur) AS utilisateurs_attribues,
        LISTAGG(U.email || ' ; ') WITHIN GROUP (ORDER BY AT.fk_utilisateur) AS emails_attribues
    FROM CYPI_CERGY.TICKETS T
    JOIN CYPI_CERGY.ATTRIBUTIONS_TICKETS AT
        ON T.id_ticket = AT.fk_ticket
    JOIN CYPI_CERGY.UTILISATEURS U
        ON AT.fk_utilisateur = U.id_utilisateur
    GROUP BY T.id_ticket
) ASS ON ASS.id_ticket = T.id_ticket
LEFT JOIN (
    SELECT
        T.id_ticket,
        LISTAGG(U.nom || ' ' || U.prenom || ' ; ') WITHIN GROUP (ORDER BY O.fk_utilisateur) AS utilisateurs_observateurs,
        LISTAGG(U.email || ' ; ') WITHIN GROUP (ORDER BY O.fk_utilisateur) AS emails_observateurs
    FROM CYPI_CERGY.TICKETS T
    JOIN CYPI_CERGY.OBSERVATEURS_TICKETS O
        ON T.id_ticket = O.fk_ticket
    JOIN CYPI_CERGY.UTILISATEURS U
        ON O.fk_utilisateur = U.id_utilisateur
    GROUP BY T.id_ticket
) OBS ON OBS.id_ticket = T.id_ticket;


--  Nombre de tickets par catégorie.
CREATE MATERIALIZED VIEW CYPI_CERGY.TICKETS_PAR_CATEGORIE AS
SELECT C."categorie", COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.CATEGORIES_TICKETS C ON TICKETS.fk_categorie = C.id_categorie
GROUP BY C."categorie";

--  Nombre de tickets par emplacement.
CREATE MATERIALIZED VIEW CYPI_CERGY.TICKETS_PAR_EMPLACEMENT AS
SELECT E."emplacement", COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.EMPLACEMENTS E ON TICKETS.fk_emplacement = E.id_emplacement
GROUP BY E."emplacement";


--  Temps moyen de résolution des tickets.
CREATE MATERIALIZED VIEW CYPI_CERGY.TEMPS_RESOLUTION_TICKETS AS
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
        FROM CYPI_CERGY.TICKETS
        WHERE date_resolution IS NOT NULL
    )
);

--  Activité récente des tickets.
CREATE MATERIALIZED VIEW CYPI_CERGY.ACTIVITE_RECENTE_TICKETS AS
SELECT id_ticket, titre, date_modification
FROM (
    SELECT id_ticket, titre, date_modification
    FROM CYPI_CERGY.TICKETS
    ORDER BY date_modification DESC
)
WHERE ROWNUM <= 100;

--  Tickets ouverts par catégorie.
CREATE VIEW CYPI_CERGY.TICKETS_OUVERTS_PAR_CATEGORIE AS
SELECT C."categorie", S.statut, COUNT(*) AS tickets_ouverts
FROM CYPI_CERGY.TICKETS T
JOIN CYPI_CERGY.CATEGORIES_TICKETS C ON T.fk_categorie = C.id_categorie
JOIN CYPI_CERGY.STATUTS_TICKETS S ON T.fk_statut = S.id_statut
WHERE UPPER(S.statut) = 'A FAIRE' OR UPPER(S.statut) = 'EN COURS'
GROUP BY C."categorie", S.statut;

--  Tickets clôturés.
CREATE VIEW CYPI_CERGY.TICKETS_CLOTURES AS
SELECT T.*, S.statut
FROM CYPI_CERGY.TICKETS T
JOIN CYPI_CERGY.STATUTS_TICKETS S ON T.fk_statut = S.id_statut
WHERE S.statut = 'TERMINE';

--  Tickets par priorité.
CREATE VIEW CYPI_CERGY.TICKETS_PAR_PRIORITE AS
SELECT P."priorite", COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.PRIORITES_TICKETS P ON TICKETS.fk_priorite = P.id_priorite
GROUP BY P."priorite";

--  Tickets par statut.
CREATE VIEW CYPI_CERGY.TICKETS_PAR_STATUT AS
SELECT S.statut, COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.STATUTS_TICKETS S ON TICKETS.fk_statut = S.id_statut
GROUP BY S.statut;

--  Tickets par type.
CREATE VIEW CYPI_CERGY.TICKETS_PAR_TYPE AS
SELECT TYP."type", COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.TYPES_TICKETS TYP ON TICKETS.fk_type = TYP.id_type
GROUP BY TYP."type";

COMMIT;

