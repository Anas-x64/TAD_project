---------------------------------------------------------------
-- Test de performance : deux requêtes
-- 1) Requête TICKETS / COMMENTAIRES
-- 2) Requête UTILISATEURS / ROLES / GROUPES
-- 
-- On active SET TIMING ON UNE SEULE FOIS, au début.
---------------------------------------------------------------

SET TIMING ON;

---------------------------------------------------------------
-- Situation A : SANS INDEX sur date_creation
---------------------------------------------------------------


-- 1) DROP INDEX (si existe déjà) : ignore l’erreur si inexistant
DROP INDEX CYPI_CERGY.idx_tickets_date_creation;

-- 2) EXPLAIN PLAN
EXPLAIN PLAN FOR
SELECT
    t.id_ticket,
    t.titre,
    t.date_creation,
    u.nom || ' ' || u.prenom AS createur,
    COUNT(c.id_commentaire) AS nb_commentaires
FROM TICKETS t
JOIN UTILISATEURS u
       ON t.fk_createur = u.id_utilisateur
LEFT JOIN COMMENTAIRES_TICKETS c
       ON t.id_ticket = c.fk_ticket
WHERE t.date_creation > (SYSDATE - 90)
GROUP BY t.id_ticket, t.titre, t.date_creation, u.nom, u.prenom
ORDER BY nb_commentaires DESC;

-- 3) Affichage du plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());

-- 4) Exécution de la requête (le temps s'affichera automatiquement)
SELECT
    t.id_ticket,
    t.titre,
    t.date_creation,
    u.nom || ' ' || u.prenom AS createur,
    COUNT(c.id_commentaire) AS nb_commentaires
FROM TICKETS t
JOIN UTILISATEURS u
       ON t.fk_createur = u.id_utilisateur
LEFT JOIN COMMENTAIRES_TICKETS c
       ON t.id_ticket = c.fk_ticket
WHERE t.date_creation > (SYSDATE - 90)
GROUP BY t.id_ticket, t.titre, t.date_creation, u.nom, u.prenom
ORDER BY nb_commentaires DESC;


---------------------------------------------------------------
-- Situation B : AVEC INDEX sur date_creation
---------------------------------------------------------------


-- 1) CREATE INDEX
CREATE INDEX CYPI_CERGY.idx_tickets_date_creation ON TICKETS(date_creation);

-- 2) EXPLAIN PLAN
EXPLAIN PLAN FOR
SELECT
    t.id_ticket,
    t.titre,
    t.date_creation,
    u.nom || ' ' || u.prenom AS createur,
    COUNT(c.id_commentaire) AS nb_commentaires
FROM TICKETS t
JOIN UTILISATEURS u
       ON t.fk_createur = u.id_utilisateur
LEFT JOIN COMMENTAIRES_TICKETS c
       ON t.id_ticket = c.fk_ticket
WHERE t.date_creation > (SYSDATE - 90)
GROUP BY t.id_ticket, t.titre, t.date_creation, u.nom, u.prenom
ORDER BY nb_commentaires DESC;

-- 3) Affichage du plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());

-- 4) Exécution de la requête
SELECT
    t.id_ticket,
    t.titre,
    t.date_creation,
    u.nom || ' ' || u.prenom AS createur,
    COUNT(c.id_commentaire) AS nb_commentaires
FROM TICKETS t
JOIN UTILISATEURS u
       ON t.fk_createur = u.id_utilisateur
LEFT JOIN COMMENTAIRES_TICKETS c
       ON t.id_ticket = c.fk_ticket
WHERE t.date_creation > (SYSDATE - 90)
GROUP BY t.id_ticket, t.titre, t.date_creation, u.nom, u.prenom
ORDER BY nb_commentaires DESC;


---------------------------------------------------------------
-- PARTIE 2 : REQUETE #2 (UTILISATEURS / ROLES / GROUPES)
---------------------------------------------------------------

---------------------------------------------------------------
-- Situation A : SANS INDEX COMPOSITE
---------------------------------------------------------------

-- 1) DROP INDEX
DROP INDEX idx_utilisateurs_fk_role_groupe_entreprise;

-- 2) EXPLAIN PLAN
EXPLAIN PLAN FOR
SELECT
    u.id_utilisateur,
    u.nom,
    u.prenom,
    r."role",
    g."groupe",
    u.entreprise
FROM UTILISATEURS u
JOIN ROLES_UTILISATEURS r
    ON u.fk_role = r.id_role
JOIN GROUPES_UTILISATEURS g
    ON u.fk_groupe = g.id_groupe
WHERE u.fk_role = 2
  AND u.fk_groupe = 2
  AND u.entreprise = 'TechCorp';

-- 3) Affichage du plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());

-- 4) Exécution de la requête
SELECT
    u.id_utilisateur,
    u.nom,
    u.prenom,
    r."role",
    g."groupe",
    u.entreprise
FROM UTILISATEURS u
JOIN ROLES_UTILISATEURS r
    ON u.fk_role = r.id_role
JOIN GROUPES_UTILISATEURS g
    ON u.fk_groupe = g.id_groupe
WHERE u.fk_role = 2
  AND u.fk_groupe = 2
  AND u.entreprise = 'TechCorp';


---------------------------------------------------------------
-- Situation B : AVEC INDEX COMPOSITE
---------------------------------------------------------------

-- 1) CREATE INDEX
CREATE INDEX CYPI_CERGY.idx_utilisateurs_fk_groupe ON UTILISATEURS(fk_role, fk_groupe, entreprise);

-- 2) EXPLAIN PLAN
EXPLAIN PLAN FOR
SELECT
    u.id_utilisateur,
    u.nom,
    u.prenom,
    r."role",
    g."groupe",
    u.entreprise
FROM UTILISATEURS u
JOIN ROLES_UTILISATEURS r
    ON u.fk_role = r.id_role
JOIN GROUPES_UTILISATEURS g
    ON u.fk_groupe = g.id_groupe
WHERE u.fk_role = 2
  AND u.fk_groupe = 2
  AND u.entreprise = 'TechCorp';

-- 3) Affichage du plan
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());

-- 4) Exécution de la requête
SELECT
    u.id_utilisateur,
    u.nom,
    u.prenom,
    r."role",
    g."groupe",
    u.entreprise
FROM UTILISATEURS u
JOIN ROLES_UTILISATEURS r
    ON u.fk_role = r.id_role
JOIN GROUPES_UTILISATEURS g
    ON u.fk_groupe = g.id_groupe
WHERE u.fk_role = 2
  AND u.fk_groupe = 2
  AND u.entreprise = 'TechCorp';

