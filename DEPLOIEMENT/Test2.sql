------------------------------------------------------------------------
--  ACTIVER LE TIMING
------------------------------------------------------------------------
SET TIMING ON;

------------------------------------------------------------------------
-- TEST #1 : VUE MATÉRIALISÉE "TICKETS_PAR_CATEGORIE"
------------------------------------------------------------------------

-- A) Requête "avec" la MV (si elle existe déjà)
--    On fait un EXPLAIN PLAN, on affiche le plan, puis on exécute la requête.

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST #1 (MV) : Requête AVEC la MV TICKETS_PAR_CATEGORIE ===');
END;
/

EXPLAIN PLAN FOR
SELECT
    "categorie",
    nombre_tickets
FROM CYPI_CERGY.TICKETS_PAR_CATEGORIE
ORDER BY nombre_tickets DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT
    "categorie",
    nombre_tickets
FROM CYPI_CERGY.TICKETS_PAR_CATEGORIE
ORDER BY nombre_tickets DESC;


------------------------------------------------------------------------
-- B) DROP LA MV => tester "sans MV"
------------------------------------------------------------------------

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST #1 (MV) : DROP MV => tester la requête brute ===');
END;
/

DROP MATERIALIZED VIEW CYPI_CERGY.TICKETS_PAR_CATEGORIE;

EXPLAIN PLAN FOR
SELECT
    c."categorie",
    COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS t
JOIN CYPI_CERGY.CATEGORIES_TICKETS c
    ON t.fk_categorie = c.id_categorie
GROUP BY c."categorie"
ORDER BY nombre_tickets DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT
    c."categorie",
    COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS t
JOIN CYPI_CERGY.CATEGORIES_TICKETS c
    ON t.fk_categorie = c.id_categorie
GROUP BY c."categorie"
ORDER BY nombre_tickets DESC;


------------------------------------------------------------------------
-- C) RECRÉER LA MV => re-tester "avec MV"
------------------------------------------------------------------------

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST #1 (MV) : Recréation de la MV et nouvelle requête ===');
END;
/

CREATE MATERIALIZED VIEW CYPI_CERGY.TICKETS_PAR_CATEGORIE
AS
SELECT 
    c."categorie",
    COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS t
JOIN CYPI_CERGY.CATEGORIES_TICKETS c
    ON t.fk_categorie = c.id_categorie
GROUP BY c."categorie";

EXPLAIN PLAN FOR
SELECT
    "categorie",
    nombre_tickets
FROM CYPI_CERGY.TICKETS_PAR_CATEGORIE
ORDER BY nombre_tickets DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT
    "categorie",
    nombre_tickets
FROM CYPI_CERGY.TICKETS_PAR_CATEGORIE
ORDER BY nombre_tickets DESC;


------------------------------------------------------------------------
-- TEST #2 : CLUSTER "GROUPE_UTILISATEURS"
------------------------------------------------------------------------
-- On va démontrer le "sans cluster" en droppant le cluster,
-- recréant les tables en mode normal,
-- insérant plein de données,
-- puis on fait une grosse requête sur UTILISATEURS + OBSERVATEURS_TICKETS + TICKETS.
-- Ensuite, on pourrait recréer le cluster et refaire la même requête.

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST #2 (CLUSTER) : ON DROP LE CLUSTER & TABLES ===');
END;
/


SELECT
    obs.fk_ticket,
    t.titre,
    obs.fk_utilisateur,
    (u.nom || ' ' || u.prenom) AS observateur,
    u.entreprise,
    t.date_creation,
    s.statut
FROM CYPI_CERGY.OBSERVATEURS_TICKETS obs
JOIN CYPI_CERGY.UTILISATEURS u
    ON obs.fk_utilisateur = u.id_utilisateur
JOIN CYPI_CERGY.TICKETS t
    ON obs.fk_ticket = t.id_ticket
JOIN CYPI_CERGY.STATUTS_TICKETS s
    ON t.fk_statut = s.id_statut
ORDER BY obs.fk_ticket, u.nom;

COMMIT;


------------------------------------------------------
-- 1) DROP TABLES du CLUSTER + CLUSTER
------------------------------------------------------
DROP TABLE CYPI_CERGY.OBSERVATEURS_TICKETS CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.ATTRIBUTIONS_TICKETS CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.UTILISATEURS CASCADE CONSTRAINTS;
DROP CLUSTER CYPI_CERGY.GROUPE_UTILISATEURS INCLUDING TABLES;


------------------------------------------------------
-- 2) RECRÉER LES TABLES "SANS" CLUSTER
------------------------------------------------------
CREATE CLUSTER CYPI_CERGY.GROUPE_UTILISATEURS (ID_UTILISATEUR INT) TABLESPACE CYPI_CERGY_ESPACE; 

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST #2 (CLUSTER) : RECREATE TABLES WITHOUT CLUSTER ===');
END;
/

CREATE TABLE CYPI_CERGY.UTILISATEURS (
    id_utilisateur INT PRIMARY KEY,  
    fk_role INT NULL,  
    fk_groupe INT NULL,  
    "mot_de_passe" VARCHAR2(255) NOT NULL 
        CHECK ( 
            LENGTH("mot_de_passe") >= 14
            AND REGEXP_LIKE("mot_de_passe", '[0-9]')
            AND REGEXP_LIKE("mot_de_passe", '[A-Z]')
            AND REGEXP_LIKE("mot_de_passe", '[a-z]')
            AND REGEXP_LIKE("mot_de_passe", '[[:punct:]]')
        ),
    email VARCHAR2(50) NOT NULL UNIQUE 
        CHECK(REGEXP_LIKE(email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')),
    nom VARCHAR2(50) NOT NULL,  
    prenom VARCHAR2(50) NOT NULL,  
    entreprise VARCHAR2(50) NULL,  
    fk_emplacement INT NULL,  
    FOREIGN KEY (fk_role) REFERENCES CYPI_CERGY.ROLES_UTILISATEURS(id_role),  
    FOREIGN KEY (fk_groupe) REFERENCES CYPI_CERGY.GROUPES_UTILISATEURS(id_groupe),  
    FOREIGN KEY (fk_emplacement) REFERENCES CYPI_CERGY.EMPLACEMENTS(id_emplacement)
);

CREATE TABLE CYPI_CERGY.OBSERVATEURS_TICKETS (
    fk_ticket INT,  
    fk_utilisateur INT,  
    PRIMARY KEY (fk_ticket, fk_utilisateur),  
    FOREIGN KEY (fk_ticket) REFERENCES CYPI_CERGY.TICKETS(id_ticket),  
    FOREIGN KEY (fk_utilisateur) REFERENCES CYPI_CERGY.UTILISATEURS(id_utilisateur)
);

CREATE TABLE CYPI_CERGY.ATTRIBUTIONS_TICKETS (
    fk_ticket INT,  
    fk_utilisateur INT,  
    PRIMARY KEY (fk_ticket, fk_utilisateur),  
    FOREIGN KEY (fk_ticket) REFERENCES CYPI_CERGY.TICKETS(id_ticket),  
    FOREIGN KEY (fk_utilisateur) REFERENCES CYPI_CERGY.UTILISATEURS(id_utilisateur)
);


------------------------------------------------------
-- 3) INSÉRER DONNÉES (UTILISATEURS, OBSERVATEURS, ATTRIBUTIONS)
--    On suppose que TICKETS est déjà peuplé.
------------------------------------------------------

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST #2 (CLUSTER) : INSERT BIG DATA ON UTILISATEURS, OBS, ATTRIBUTIONS ===');
END;
/

-- 5 "utilisateurs" initiaux
INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (1, 1, 1, 'P@ssword20233!', 'julien.dupont@exemple.com', 'Dupont', 'Julien', 'TechCorp', 1);

INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (2, 2, 2, 'Adm1n2023@2023', 'alice.martin@exemple.com', 'Martin', 'Alice', 'InnoSoft', 2);

INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (3, 3, 3, 'Secure@Pass987', 'paul.roux@exemple.com', 'Roux', 'Paul', 'DevSolutions', 3);

INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (4, 4, 1, 'P@ssw0rdQwerty!', 'carla.brun@exemple.com', 'Brun', 'Carla', 'TechCorp', 4);

INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (5, 3, 3, 'MySecure@Pass123', 'leo.dubois@exemple.com', 'Dubois', 'Léo', 'CloudSystems', 5);

-- 10 000 utilisateurs supplémentaires
BEGIN
  FOR i IN 6..10005 LOOP
    INSERT INTO CYPI_CERGY.UTILISATEURS (
      id_utilisateur, fk_role, fk_groupe, "mot_de_passe",
      email, nom, prenom, entreprise, fk_emplacement
    ) VALUES (
      i,
      TRUNC(DBMS_RANDOM.VALUE(1, 5)),   -- role 1..4
      TRUNC(DBMS_RANDOM.VALUE(1, 4)),   -- groupe 1..3
      'RandomP@ssssss' || i || '!',
      'user_' || i || '@exemple.com',
      'Nom_' || i,
      'Prenom_' || i,
      'Entreprise_' || TRUNC(DBMS_RANDOM.VALUE(1,6)),
      TRUNC(DBMS_RANDOM.VALUE(1,6))     -- emplacement 1..5
    );
  END LOOP;
  COMMIT;
END;
/

-- OBSERVATEURS_TICKETS, quelques inserts "manuels"
INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) VALUES (1, 3);
INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) VALUES (2, 5);
INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) VALUES (3, 2);
INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) VALUES (4, 1);
INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) VALUES (5, 4);

-- 10 000 obs
BEGIN
  FOR i IN 1..10000 LOOP
    BEGIN
      INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur)
      VALUES (
        TRUNC(DBMS_RANDOM.VALUE(1, 10006)),  -- ticket 1..10005
        TRUNC(DBMS_RANDOM.VALUE(1, 10006))   -- user 1..10005
      );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END;
  END LOOP;
  COMMIT;
END;
/

-- ATTRIBUTIONS_TICKETS
INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) VALUES (1, 2);
INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) VALUES (2, 4);
INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) VALUES (3, 5);
INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) VALUES (4, 5);
INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) VALUES (5, 3);

-- 10 000 attribut
BEGIN
  FOR i IN 1..10000 LOOP
    BEGIN
      INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur)
      VALUES (
        TRUNC(DBMS_RANDOM.VALUE(1, 10006)),
        TRUNC(DBMS_RANDOM.VALUE(1, 10006))
      );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END;
  END LOOP;
  COMMIT;
END;
/

COMMIT;


-----------------------------------------------------------
-- 4) GROSSE REQUÊTE DE TEST "SANS" CLUSTER
-----------------------------------------------------------
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST #2 (CLUSTER) : Grosse requête de test SANS cluster ===');
END;
/

/*
   On va faire une grosse jointure entre UTILISATEURS, OBSERVATEURS_TICKETS,
   et TICKETS, filtrer sur un champ, etc. Mais on ne met PAS de where trop restrictif
   pour que la requête balaie beaucoup de données.
*/

EXPLAIN PLAN FOR
SELECT
    obs.fk_ticket,
    t.titre,
    obs.fk_utilisateur,
    (u.nom || ' ' || u.prenom) AS observateur,
    u.entreprise,
    t.date_creation,
    s.statut
FROM CYPI_CERGY.OBSERVATEURS_TICKETS obs
JOIN CYPI_CERGY.UTILISATEURS u
    ON obs.fk_utilisateur = u.id_utilisateur
JOIN CYPI_CERGY.TICKETS t
    ON obs.fk_ticket = t.id_ticket
JOIN CYPI_CERGY.STATUTS_TICKETS s
    ON t.fk_statut = s.id_statut
ORDER BY obs.fk_ticket, u.nom;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT
    obs.fk_ticket,
    t.titre,
    obs.fk_utilisateur,
    (u.nom || ' ' || u.prenom) AS observateur,
    u.entreprise,
    t.date_creation,
    s.statut
FROM CYPI_CERGY.OBSERVATEURS_TICKETS obs
JOIN CYPI_CERGY.UTILISATEURS u
    ON obs.fk_utilisateur = u.id_utilisateur
JOIN CYPI_CERGY.TICKETS t
    ON obs.fk_ticket = t.id_ticket
JOIN CYPI_CERGY.STATUTS_TICKETS s
    ON t.fk_statut = s.id_statut
ORDER BY obs.fk_ticket, u.nom;


------------------------------------------------------------------------
-- (Optionnel) 5) RECRÉER LE CLUSTER + TABLES POUR REFAIRE LE TEST "AVEC CLUSTER"
--     (Si vous voulez comparer tout de suite)
------------------------------------------------------------------------
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST #2 (CLUSTER) : Recréation du cluster, si besoin ===');
END;
/

--  Table des observateurs de tickets.
CREATE TABLE CYPI_CERGY.OBSERVATEURS_TICKETS (
    fk_ticket INT,  
    fk_utilisateur INT,  
    PRIMARY KEY (fk_ticket, fk_utilisateur),  
    FOREIGN KEY (fk_ticket) REFERENCES CYPI_CERGY.TICKETS(id_ticket),  
    FOREIGN KEY (fk_utilisateur) REFERENCES CYPI_CERGY.UTILISATEURS(id_utilisateur)  
)
CLUSTER CYPI_CERGY.GROUPE_UTILISATEURS(fk_utilisateur);

-- Table des responsables des tickets.
CREATE TABLE CYPI_CERGY.ATTRIBUTIONS_TICKETS (
    fk_ticket INT,  
    fk_utilisateur INT,  
    PRIMARY KEY (fk_ticket, fk_utilisateur),  
    FOREIGN KEY (fk_ticket) REFERENCES CYPI_CERGY.TICKETS(id_ticket),  
    FOREIGN KEY (fk_utilisateur) REFERENCES CYPI_CERGY.UTILISATEURS(id_utilisateur)  
)
CLUSTER CYPI_CERGY.GROUPE_UTILISATEURS(fk_utilisateur);

--  Table des utilisateurs du système.
CREATE TABLE CYPI_CERGY.UTILISATEURS (
    id_utilisateur INT PRIMARY KEY,  
    fk_role INT NULL,  
    fk_groupe INT NULL,  
    "mot_de_passe" VARCHAR2(255) NOT NULL 
    CHECK ( 
        LENGTH("mot_de_passe") >= 14
        AND REGEXP_LIKE("mot_de_passe", '[0-9]')
        AND REGEXP_LIKE("mot_de_passe", '[A-Z]')
        AND REGEXP_LIKE("mot_de_passe", '[a-z]')
        AND REGEXP_LIKE("mot_de_passe", '[[:punct:]]')
    ),
    email VARCHAR2(50) NOT NULL UNIQUE 
    CHECK(REGEXP_LIKE(email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')),
    nom VARCHAR2(50) NOT NULL,  
    prenom VARCHAR2(50) NOT NULL,  
    entreprise VARCHAR2(50) NULL,  
    fk_emplacement INT NULL,  
    FOREIGN KEY (fk_role) REFERENCES CYPI_CERGY.ROLES_UTILISATEURS(id_role),  
    FOREIGN KEY (fk_groupe) REFERENCES CYPI_CERGY.GROUPES_UTILISATEURS(id_groupe),  
    FOREIGN KEY (fk_emplacement) REFERENCES CYPI_CERGY.EMPLACEMENTS(id_emplacement)  
)
CLUSTER CYPI_CERGY.GROUPE_UTILISATEURS(id_utilisateur);


BEGIN
    DBMS_OUTPUT.PUT_LINE('=== FIN DES TESTS ===');
END;
/
