---------------------------------------------------------------
-- SECTION DE "DROP" À PLACER AU DÉBUT DU SCRIPT
---------------------------------------------------------------
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

---------------------------------------------------------------
-- 1) DROP DES DATABASE LINKS PUBLICS
---------------------------------------------------------------
DROP PUBLIC DATABASE LINK LK_CYPI_PAU;
DROP PUBLIC DATABASE LINK LK_CYPI_CERGY;

---------------------------------------------------------------
-- 2) DROP DE TOUS LES RÔLES
---------------------------------------------------------------
DROP ROLE CYPI_MASTER;
DROP ROLE CYPI_CERGY_RESPONSABLE;
DROP ROLE CYPI_CERGY_INGENIEUR;
DROP ROLE CYPI_CERGY_SUPERVISEUR;
DROP ROLE CYPI_CERGY_EXPERT;
DROP ROLE CYPI_PAU_RESPONSABLE;
DROP ROLE CYPI_PAU_INGENIEUR;
DROP ROLE CYPI_PAU_SUPERVISEUR;
DROP ROLE CYPI_PAU_EXPERT;

---------------------------------------------------------------
-- 3) DROP DES UTILISATEURS (SUPPRIME TOUT LEURS OBJETS DÉPENDANTS)
---------------------------------------------------------------
DROP USER CYPI_CERGY CASCADE;
DROP USER CYPI_PAU CASCADE;

---------------------------------------------------------------
-- 4) DROP DES TABLESPACES
---------------------------------------------------------------
DROP TABLESPACE CYPI_CERGY_ESPACE       INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE CYPI_CERGY_ESPACE_TEMP  INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE CYPI_PAU_ESPACE         INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE CYPI_PAU_ESPACE_TEMP    INCLUDING CONTENTS AND DATAFILES;

COMMIT;
---------------------------------------------------------------
-- FIN DE LA SECTION DROP
---------------------------------------------------------------

---------------------------------------------------------------
-- SECTION DROP POUR LES FONCTIONS ET PROCÉDURES
---------------------------------------------------------------
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

---------------------------------------------------------------
-- 1) DROP DES FONCTIONS
---------------------------------------------------------------
DROP FUNCTION CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE;
DROP FUNCTION CYPI_CERGY.TICKETS_EN_RETARDS;
DROP FUNCTION CYPI_CERGY.OBTENIR_TICKET;
DROP FUNCTION CYPI_CERGY.OBTENIR_TICKETS_UTILISATEUR;
DROP FUNCTION CYPI_CERGY.OBTENIR_COMMENTAIRES_TICKET;
DROP FUNCTION CYPI_CERGY.GET_TICKETS_BY_STATUS;

---------------------------------------------------------------
-- 2) DROP DES PROCÉDURES
---------------------------------------------------------------
DROP PROCEDURE CYPI_CERGY.DEFINIR_STATUT_TICKET;
DROP PROCEDURE CYPI_CERGY.RESOUDRE_TICKET;
DROP PROCEDURE CYPI_CERGY.FERMER_TICKET;
DROP PROCEDURE CYPI_CERGY.ATTRIBUER_TICKET_A_UTILISATEUR;
DROP PROCEDURE CYPI_CERGY.AJOUTER_SUPPRIMER_OBSERVATEUR_TICKET;
DROP PROCEDURE CYPI_CERGY.RAFRAICHIR_VUE_MATERIELLEE;
DROP PROCEDURE CYPI_CERGY.AUTO_ASSIGNER_TICKET;
DROP PROCEDURE CYPI_CERGY.NOUVEAU_TICKET;
DROP PROCEDURE CYPI_CERGY.NOUVEL_UTILISATEUR;
DROP PROCEDURE CYPI_CERGY.NOUVEAU_COMMENTAIRE;

COMMIT;
---------------------------------------------------------------
-- FIN DE LA SECTION DROP
---------------------------------------------------------------


---------------------------------------------------------------
-- SECTION DROP POUR LES OBJETS CRÉÉS DANS LE SCRIPT
---------------------------------------------------------------
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

---------------------------------------------------------------
-- 1) DROP DES VUES MATÉRIALISÉES (MATERIALIZED VIEWS)
---------------------------------------------------------------
DROP MATERIALIZED VIEW CYPI_CERGY.TICKETS_GLOBAL;
DROP MATERIALIZED VIEW CYPI_CERGY.TICKETS_PAR_CATEGORIE;
DROP MATERIALIZED VIEW CYPI_CERGY.TICKETS_PAR_EMPLACEMENT;
DROP MATERIALIZED VIEW CYPI_CERGY.TEMPS_RESOLUTION_TICKETS;
DROP MATERIALIZED VIEW CYPI_CERGY.ACTIVITE_RECENTE_TICKETS;

---------------------------------------------------------------
-- 2) DROP DES VUES (VIEWS) SIMPLES
---------------------------------------------------------------
DROP VIEW CYPI_CERGY.TICKETS_OUVERTS_PAR_CATEGORIE;
DROP VIEW CYPI_CERGY.TICKETS_CLOTURES;
DROP VIEW CYPI_CERGY.TICKETS_PAR_PRIORITE;
DROP VIEW CYPI_CERGY.TICKETS_PAR_STATUT;
DROP VIEW CYPI_CERGY.TICKETS_PAR_TYPE;

---------------------------------------------------------------
-- 3) DROP DES INDEX B-TREE
---------------------------------------------------------------
DROP INDEX CYPI_CERGY.idx_tickets_fk_createur;
DROP INDEX CYPI_CERGY.idx_tickets_date_creation;
DROP INDEX CYPI_CERGY.idx_tickets_derniere_modif;
DROP INDEX CYPI_CERGY.idx_tickets_date_resolution;
DROP INDEX CYPI_CERGY.idx_tickets_date_cloture;
DROP INDEX CYPI_CERGY.idx_tickets_fk_priorite;
DROP INDEX CYPI_CERGY.idx_tickets_fk_emplacement;
DROP INDEX CYPI_CERGY.idx_commentaires_fk_ticket;
DROP INDEX CYPI_CERGY.idx_commentaires_fk_utilisateur;

---------------------------------------------------------------
-- 4) DROP DES INDEX BITMAP
---------------------------------------------------------------
DROP INDEX CYPI_CERGY.idx_utilisateurs_fk_role;
DROP INDEX CYPI_CERGY.idx_utilisateurs_fk_groupe;
DROP INDEX CYPI_CERGY.idx_tickets_fk_type;
DROP INDEX CYPI_CERGY.idx_tickets_fk_statut;
DROP INDEX CYPI_CERGY.idx_tickets_fk_categorie;
DROP INDEX CYPI_CERGY.idx_tickets_fk_groupe_attribue;

---------------------------------------------------------------
-- 5) DROP DES INDEX COMPOSITES
---------------------------------------------------------------
DROP INDEX CYPI_CERGY.idx_tickets_statut_priorite;
DROP INDEX CYPI_CERGY.idx_commentaires_utilisateur_date_creation;
DROP INDEX CYPI_CERGY.idx_utilisateurs_role_entreprise;
DROP INDEX CYPI_CERGY.idx_utilisateurs_groupe_entreprise;
DROP INDEX CYPI_CERGY.idx_utilisateurs_emplacement_entreprise;

---------------------------------------------------------------
-- 6) DROP DES SEQUENCES
---------------------------------------------------------------
DROP SEQUENCE CYPI_CERGY.seq_id_roles_utilisateurs;
DROP SEQUENCE CYPI_CERGY.seq_id_groupes_utilisateurs;
DROP SEQUENCE CYPI_CERGY.seq_id_statuts_tickets;
DROP SEQUENCE CYPI_CERGY.seq_id_priorites_tickets;
DROP SEQUENCE CYPI_CERGY.seq_id_categories_tickets;
DROP SEQUENCE CYPI_CERGY.seq_id_types_tickets;
DROP SEQUENCE CYPI_CERGY.seq_id_emplacements;
DROP SEQUENCE CYPI_CERGY.seq_id_materiels;
DROP SEQUENCE CYPI_CERGY.seq_id_utilisateurs;
DROP SEQUENCE CYPI_CERGY.seq_id_tickets;
DROP SEQUENCE CYPI_CERGY.seq_id_commentaires_tickets;
DROP SEQUENCE CYPI_CERGY.seq_id_ressources;

---------------------------------------------------------------
-- 7) DROP DES TABLES (AVEC CASCADE CONSTRAINTS SI BESOIN)
---------------------------------------------------------------
DROP TABLE CYPI_CERGY.ATTRIBUTIONS_TICKETS      CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.OBSERVATEURS_TICKETS      CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.COMMENTAIRES_RESSOURCES   CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.TICKETS_RESSOURCES        CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.RESSOURCES                CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.COMMENTAIRES_TICKETS      CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.TICKETS                   CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.UTILISATEURS              CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.MATERIELS                 CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.EMPLACEMENTS              CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.TYPES_TICKETS             CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.CATEGORIES_TICKETS        CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.PRIORITES_TICKETS         CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.STATUTS_TICKETS           CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.GROUPES_UTILISATEURS      CASCADE CONSTRAINTS;
DROP TABLE CYPI_CERGY.ROLES_UTILISATEURS        CASCADE CONSTRAINTS;

---------------------------------------------------------------
-- 8) DROP DES UTILISATEURS SPÉCIFIQUES CRÉÉS À LA FIN
---------------------------------------------------------------
DROP USER CYPI_CERGY_SUPERVISEUR1       CASCADE;
DROP USER CYPI_CERGY_EXPERT1            CASCADE;
DROP USER CYPI_CERGY_INGENIEUR1         CASCADE;
DROP USER CYPI_CERGY_RESPONSABLE1       CASCADE;
DROP USER CYPI_PAU_SUPERVISEUR1         CASCADE;
DROP USER CYPI_PAU_EXPERT1              CASCADE;
DROP USER CYPI_PAU_INGENIEUR1           CASCADE;
DROP USER CYPI_PAU_RESPONSABLE1         CASCADE;


COMMIT;
---------------------------------------------------------------
-- FIN DE LA SECTION DROP
---------------------------------------------------------------

-------------------------------------------
-- CREATION DE LA BDD
-------------------------------------------

ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
SET SERVEROUTPUT OFF;

--Creation TABLESPACES et SCHEMA CYPI_PAU
CREATE TABLESPACE CYPI_PAU_ESPACE
datafile 'C:\app\ilyas\product\21c\oradata\XE\PAU\CYPI_PAU_ESPACE.dat'
SIZE 100M AUTOEXTEND ON;

CREATE TEMPORARY TABLESPACE CYPI_PAU_ESPACE_TEMP
tempfile 'C:\app\ilyas\product\21c\oradata\XE\PAU\CYPI_PAU_ESPACE_TEMP.dat'
SIZE 50M AUTOEXTEND ON;

CREATE USER CYPI_PAU
IDENTIFIED BY CYPI_PAU_PASSWORD
DEFAULT TABLESPACE CYPI_PAU_ESPACE
TEMPORARY TABLESPACE CYPI_PAU_ESPACE_TEMP;
GRANT CONNECT, CREATE SESSION TO CYPI_PAU;
GRANT DBA TO CYPI_PAU;

--Creation TABLESPACES et SCHEMA CYPI_CERGY
CREATE TABLESPACE CYPI_CERGY_ESPACE
datafile 'C:\app\ilyas\product\21c\oradata\XE\CERGY\CYPI_CERGY_ESPACE.dat'
SIZE 100M AUTOEXTEND ON;

CREATE TEMPORARY TABLESPACE CYPI_CERGY_ESPACE_TEMP
tempfile 'C:\app\ilyas\product\21c\oradata\XE\CERGY\CYPI_CERGY_ESPACE_TEMP.dat'
SIZE 50M AUTOEXTEND ON;

CREATE USER CYPI_CERGY
IDENTIFIED BY CYPI_CERGY_PASSWORD
DEFAULT TABLESPACE CYPI_CERGY_ESPACE
TEMPORARY TABLESPACE CYPI_CERGY_ESPACE_TEMP;

GRANT CONNECT, CREATE SESSION TO CYPI_CERGY;

GRANT DBA TO CYPI_CERGY;

-------------------------------------------------------
-- DB LINKS
-------------------------------------------------------
CREATE PUBLIC DATABASE LINK LK_CYPI_PAU 
CONNECT TO CYPI_PAU IDENTIFIED BY CYPI_PAU_PASSWORD 
USING '127.0.0.1:1521';

CREATE PUBLIC DATABASE LINK LK_CYPI_CERGY 
CONNECT TO CYPI_CERGY IDENTIFIED BY CYPI_CERGY_PASSWORD 
USING '127.0.0.1:1521';

COMMIT;


------------------------------------------------------------------
-- CREATION DES CLUSTER
------------------------------------------------------------------


-- CRÉATION DES GROUPES DE STOCKAGE POUR LES UTILISATEURS ET LES TICKETS
CREATE CLUSTER CYPI_CERGY.GROUPE_UTILISATEURS (ID_UTILISATEUR INT) TABLESPACE CYPI_CERGY_ESPACE; 
CREATE CLUSTER CYPI_CERGY.GROUPE_TICKETS (ID_TICKET INT) TABLESPACE CYPI_CERGY_ESPACE; 

CREATE CLUSTER CYPI_PAU.GROUPE_UTILISATEURS (ID_UTILISATEUR INT) TABLESPACE CYPI_PAU_ESPACE; 
CREATE CLUSTER CYPI_PAU.GROUPE_TICKETS (ID_TICKET INT) TABLESPACE CYPI_PAU_ESPACE; 


--------------------------------------------
-- CRÉATION DES INDEX 
--------------------------------------------


-- INDEX POUR ACCÉLÉRER LES REQUÊTES SUR LES UTILISATEURS
CREATE INDEX CYPI_PAU.IDX_GROUPE_UTILISATEURS ON CLUSTER CYPI_PAU.GROUPE_UTILISATEURS;
CREATE INDEX CYPI_CERGY.IDX_GROUPE_UTILISATEURS ON CLUSTER CYPI_CERGY.GROUPE_UTILISATEURS;

-- INDEX POUR OPTIMISER LES RECHERCHES ET MANIPULATIONS SUR LES TICKETS
CREATE INDEX CYPI_PAU.IDX_GROUPE_TICKETS ON CLUSTER CYPI_PAU.GROUPE_TICKETS;
CREATE INDEX CYPI_CERGY.IDX_GROUPE_TICKETS ON CLUSTER CYPI_CERGY.GROUPE_TICKETS;

COMMIT;


ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

-- CREATION DES TABLES
-- Les colonnes entre guillemets évitent les conflits avec des mots réservés.

-- Table des rôles des utilisateurs.
CREATE TABLE CYPI_CERGY.ROLES_UTILISATEURS (
    id_role INT PRIMARY KEY,  
    "role" VARCHAR2(50) NOT NULL UNIQUE  
);

-- Table des groupes d’utilisateurs.
CREATE TABLE CYPI_CERGY.GROUPES_UTILISATEURS (
    id_groupe INT PRIMARY KEY,  
    "groupe" VARCHAR2(50) NOT NULL UNIQUE  
);

-- Table des statuts des tickets.
CREATE TABLE CYPI_CERGY.STATUTS_TICKETS (
    id_statut INT PRIMARY KEY,  
    statut VARCHAR2(50) NOT NULL UNIQUE  
);

--  Table des niveaux de priorité des tickets.
CREATE TABLE CYPI_CERGY.PRIORITES_TICKETS (
    id_priorite INT PRIMARY KEY,  
    "priorite" VARCHAR2(50) NOT NULL UNIQUE  
);

--  Table des catégories des tickets.
CREATE TABLE CYPI_CERGY.CATEGORIES_TICKETS (
    id_categorie INT PRIMARY KEY,  
    "categorie" VARCHAR2(50) NOT NULL UNIQUE  
);

--  Table des types de tickets.
CREATE TABLE CYPI_CERGY.TYPES_TICKETS (
    id_type INT PRIMARY KEY,  
    "type" VARCHAR2(50) NOT NULL UNIQUE  
);

--  Table des emplacements physiques associés aux tickets.
CREATE TABLE CYPI_CERGY.EMPLACEMENTS (
    id_emplacement INT PRIMARY KEY,  
    ville VARCHAR2(50) NOT NULL,  
    "site" VARCHAR2(50) NOT NULL,  
    "emplacement" VARCHAR2(103) UNIQUE  
);

--  Table des matériels liés aux tickets.
CREATE TABLE CYPI_CERGY.MATERIELS (
    id_materiel INT PRIMARY KEY,  
    "nom" VARCHAR2(50) NOT NULL UNIQUE,  
    "modele" VARCHAR2(50) NOT NULL,  
    marque VARCHAR2(50) NOT NULL,  
    date_achat TIMESTAMP DEFAULT SYSTIMESTAMP  
);

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

--  Table principale des tickets.
CREATE TABLE CYPI_CERGY.TICKETS (
    id_ticket INT PRIMARY KEY,  
    fk_createur INT NOT NULL,  
    fk_type INT NOT NULL,  
    fk_priorite INT DEFAULT 3,  
    titre VARCHAR2(100) NOT NULL,  
    "description" VARCHAR2(2000) NOT NULL,  
    fk_emplacement INT NOT NULL,  
    date_creation TIMESTAMP DEFAULT SYSTIMESTAMP,  
    date_modification TIMESTAMP DEFAULT SYSTIMESTAMP,  
    date_resolution TIMESTAMP NULL,  
    note_resolution VARCHAR2(2000) NULL,  
    date_cloture TIMESTAMP NULL,  
    fk_groupe_attribue INT NULL,  
    fk_statut INT DEFAULT 1,  
    fk_categorie INT NOT NULL,  
    fk_materiel INT NULL,  
    FOREIGN KEY (fk_createur) REFERENCES CYPI_CERGY.UTILISATEURS(id_utilisateur),  
    FOREIGN KEY (fk_type) REFERENCES CYPI_CERGY.TYPES_TICKETS(id_type),  
    FOREIGN KEY (fk_priorite) REFERENCES CYPI_CERGY.PRIORITES_TICKETS(id_priorite),  
    FOREIGN KEY (fk_emplacement) REFERENCES CYPI_CERGY.EMPLACEMENTS(id_emplacement),  
    FOREIGN KEY (fk_groupe_attribue) REFERENCES CYPI_CERGY.GROUPES_UTILISATEURS(id_groupe),  
    FOREIGN KEY (fk_statut) REFERENCES CYPI_CERGY.STATUTS_TICKETS(id_statut),  
    FOREIGN KEY (fk_categorie) REFERENCES CYPI_CERGY.CATEGORIES_TICKETS(id_categorie),  
    FOREIGN KEY (fk_materiel) REFERENCES CYPI_CERGY.MATERIELS(id_materiel)  
)
CLUSTER CYPI_CERGY.GROUPE_TICKETS(id_ticket);

--  Table des commentaires sur les tickets.
CREATE TABLE CYPI_CERGY.COMMENTAIRES_TICKETS (
    id_commentaire INT PRIMARY KEY,  
    fk_reponse_a INT,  
    fk_ticket INT,  
    fk_utilisateur INT,  
    date_creation TIMESTAMP DEFAULT SYSTIMESTAMP,  
    tache VARCHAR2(255) NULL,  
    "contenu" VARCHAR2(2000) NOT NULL,  
    FOREIGN KEY (fk_reponse_a) REFERENCES CYPI_CERGY.COMMENTAIRES_TICKETS(id_commentaire),  
    FOREIGN KEY (fk_ticket) REFERENCES CYPI_CERGY.TICKETS(id_ticket),  
    FOREIGN KEY (fk_utilisateur) REFERENCES CYPI_CERGY.UTILISATEURS(id_utilisateur)  
)
CLUSTER CYPI_CERGY.GROUPE_TICKETS(fk_ticket);

--  Table des ressources (fichiers, liens).
CREATE TABLE CYPI_CERGY.RESSOURCES (
    id_ressource INT PRIMARY KEY,  
    ressource VARCHAR2(2000) UNIQUE NOT NULL  
);

--  Table de liaison entre les tickets et les ressources.
CREATE TABLE CYPI_CERGY.TICKETS_RESSOURCES (
    fk_ressource INT,  
    fk_ticket INT,  
    PRIMARY KEY (fk_ressource, fk_ticket),  
    FOREIGN KEY (fk_ressource) REFERENCES CYPI_CERGY.RESSOURCES(id_ressource),  
    FOREIGN KEY (fk_ticket) REFERENCES CYPI_CERGY.TICKETS(id_ticket)  
)
CLUSTER CYPI_CERGY.GROUPE_TICKETS(fk_ticket);

--  Table de liaison entre les commentaires et les ressources.
CREATE TABLE CYPI_CERGY.COMMENTAIRES_RESSOURCES (
    fk_ressource INT,  
    fk_commentaire INT,  
    PRIMARY KEY (fk_ressource, fk_commentaire),  
    FOREIGN KEY (fk_ressource) REFERENCES CYPI_CERGY.RESSOURCES(id_ressource),  
    FOREIGN KEY (fk_commentaire) REFERENCES CYPI_CERGY.COMMENTAIRES_TICKETS(id_commentaire)  
);

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

COMMIT;

--------------------------------------------
-- CREATION DES INDEX B-TREE
--------------------------------------------

-- Index pour optimiser la recherche des tickets par créateur
CREATE INDEX CYPI_CERGY.idx_tickets_fk_createur ON CYPI_CERGY.TICKETS(fk_createur);

-- Index pour optimiser le tri et le filtrage par date de création des tickets
CREATE INDEX CYPI_CERGY.idx_tickets_date_creation ON CYPI_CERGY.TICKETS(date_creation);

-- Index pour optimiser le tri et le filtrage par date de dernière modification des tickets
CREATE INDEX CYPI_CERGY.idx_tickets_derniere_modif ON CYPI_CERGY.TICKETS(date_modification);

-- Index pour optimiser le tri et le filtrage par date de résolution des tickets
CREATE INDEX CYPI_CERGY.idx_tickets_date_resolution ON CYPI_CERGY.TICKETS(date_resolution);

-- Index pour optimiser le tri et le filtrage par date de clôture des tickets
CREATE INDEX CYPI_CERGY.idx_tickets_date_cloture ON CYPI_CERGY.TICKETS(date_cloture);

-- Index pour accélérer les requêtes qui filtrent les tickets par priorité
CREATE INDEX CYPI_CERGY.idx_tickets_fk_priorite ON CYPI_CERGY.TICKETS(fk_priorite);

-- Index pour accélérer les requêtes qui filtrent les tickets par emplacement
CREATE INDEX CYPI_CERGY.idx_tickets_fk_emplacement ON CYPI_CERGY.TICKETS(fk_emplacement);

-- Index pour accélérer les requêtes qui filtrent les commentaires par ticket
CREATE INDEX CYPI_CERGY.idx_commentaires_fk_ticket ON CYPI_CERGY.COMMENTAIRES_TICKETS(fk_ticket);

-- Index pour optimiser les requêtes qui récupèrent tous les commentaires d'un utilisateur
CREATE INDEX CYPI_CERGY.idx_commentaires_fk_utilisateur ON CYPI_CERGY.COMMENTAIRES_TICKETS(fk_utilisateur);

--------------------------------------------
-- CREATION DES INDEX BITMAP
--------------------------------------------

-- Index bitmap pour optimiser les requêtes qui filtrent les utilisateurs par rôle
CREATE BITMAP INDEX CYPI_CERGY.idx_utilisateurs_fk_role ON CYPI_CERGY.UTILISATEURS(fk_role);

-- Index bitmap pour optimiser les requêtes qui filtrent les utilisateurs par groupe
CREATE BITMAP INDEX CYPI_CERGY.idx_utilisateurs_fk_groupe ON CYPI_CERGY.UTILISATEURS(fk_groupe);

-- Index bitmap pour optimiser les requêtes qui classifient les tickets par type
CREATE BITMAP INDEX CYPI_CERGY.idx_tickets_fk_type ON CYPI_CERGY.TICKETS(fk_type);

-- Index bitmap pour optimiser les requêtes qui classifient les tickets par statut
CREATE BITMAP INDEX CYPI_CERGY.idx_tickets_fk_statut ON CYPI_CERGY.TICKETS(fk_statut);

-- Index bitmap pour optimiser les requêtes qui classifient les tickets par catégorie
CREATE BITMAP INDEX CYPI_CERGY.idx_tickets_fk_categorie ON CYPI_CERGY.TICKETS(fk_categorie);

-- Index bitmap pour optimiser les requêtes qui filtrent les tickets par groupe assigné
CREATE BITMAP INDEX CYPI_CERGY.idx_tickets_fk_groupe_attribue ON CYPI_CERGY.TICKETS(fk_groupe_attribue);

--------------------------------------------
-- CREATION DES INDEX COMPOSITES
--------------------------------------------

-- Index composite sur les tickets pour améliorer les performances des requêtes filtrant par statut et priorité
CREATE INDEX CYPI_CERGY.idx_tickets_statut_priorite ON CYPI_CERGY.TICKETS(fk_statut, fk_priorite);

-- Index composite sur les commentaires pour accélérer les requêtes filtrant par utilisateur et date de création
CREATE INDEX CYPI_CERGY.idx_commentaires_utilisateur_date_creation ON CYPI_CERGY.COMMENTAIRES_TICKETS(fk_utilisateur, date_creation);

-- Index composite sur les utilisateurs pour optimiser les requêtes filtrant par rôle et entreprise
CREATE INDEX CYPI_CERGY.idx_utilisateurs_role_entreprise ON CYPI_CERGY.UTILISATEURS(fk_role, entreprise);

-- Index composite sur les utilisateurs pour optimiser les requêtes filtrant par groupe et entreprise
CREATE INDEX CYPI_CERGY.idx_utilisateurs_groupe_entreprise ON CYPI_CERGY.UTILISATEURS(fk_groupe, entreprise);

-- Index composite sur les utilisateurs pour optimiser les requêtes filtrant par emplacement et entreprise
CREATE INDEX CYPI_CERGY.idx_utilisateurs_emplacement_entreprise ON CYPI_CERGY.UTILISATEURS(fk_emplacement, entreprise);

--------------------------------------------
-- VALIDATION ET COMMIT
--------------------------------------------
COMMIT;

-- Création des séquences pour gérer les ID des tables

--  Séquence pour les rôles des utilisateurs.
CREATE SEQUENCE CYPI_CERGY.seq_id_roles_utilisateurs
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les groupes d’utilisateurs.
CREATE SEQUENCE CYPI_CERGY.seq_id_groupes_utilisateurs
  START WITH 1
  INCREMENT BY 1;

-- Séquence pour les statuts des tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_statuts_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les priorités des tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_priorites_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les catégories des tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_categories_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les types de tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_types_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les emplacements.
CREATE SEQUENCE CYPI_CERGY.seq_id_emplacements
  START WITH 1
  INCREMENT BY 1;

-- Séquence pour les matériels liés aux tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_materiels
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les utilisateurs.
CREATE SEQUENCE CYPI_CERGY.seq_id_utilisateurs
  START WITH 1
  INCREMENT BY 1;

-- Séquence pour les tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_tickets
  START WITH 1
  INCREMENT BY 1;

-- Séquence pour les commentaires des tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_commentaires_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les ressources.
CREATE SEQUENCE CYPI_CERGY.seq_id_ressources
  START WITH 1
  INCREMENT BY 1;

COMMIT;

------------------------------------------------------
-- CREATION DES FONCTIONS
------------------------------------------------------

CREATE OR REPLACE FUNCTION CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
    p_valeur      IN VARCHAR2,
    p_nom_colonne IN VARCHAR2,
    p_nom_table   IN VARCHAR2
)
RETURN BOOLEAN
IS
    v_count NUMBER;
BEGIN
    -- Vérification générique : p_nom_table(p_nom_colonne) = p_valeur
    EXECUTE IMMEDIATE
        'SELECT COUNT(*) FROM ' || p_nom_table || ' WHERE ' || p_nom_colonne || ' = :1'
        INTO v_count
        USING p_valeur;

    IF v_count = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('La table ' || p_nom_table || ' n''existe pas ou est vide.');
        RETURN FALSE;
    WHEN OTHERS THEN
        IF SQLCODE = -904 THEN
            DBMS_OUTPUT.PUT_LINE('La colonne ' || p_nom_colonne || ' n''existe pas dans la table ' || p_nom_table || '.');
        ELSE
            RAISE_APPLICATION_ERROR(
                -20030,
                'Erreur lors de l''exécution de la fonction VERIFIER_VALEUR_EXISTANTE : ' || SQLERRM
            );
        END IF;
        RETURN FALSE;
END;
/

CREATE OR REPLACE FUNCTION CYPI_CERGY.TICKETS_EN_RETARDS
RETURN SYS_REFCURSOR
IS
    late_cursor SYS_REFCURSOR;
BEGIN
    OPEN late_cursor FOR
    SELECT id_ticket, titre, "description", date_creation, fk_statut
    FROM CYPI_CERGY.TICKETS
    WHERE date_creation < (CURRENT_TIMESTAMP - INTERVAL '7' DAY)
    AND fk_statut NOT IN (SELECT id_statut FROM CYPI_CERGY.STATUTS_TICKETS WHERE statut = 'Fermé');

    RETURN late_cursor;
END;
/

CREATE OR REPLACE FUNCTION CYPI_CERGY.OBTENIR_TICKET(
    p_id_ticket IN INT
)
RETURN CYPI_CERGY.TICKETS%ROWTYPE
IS
    v_ligne_ticket CYPI_CERGY.TICKETS%ROWTYPE;
BEGIN
    SELECT *
      INTO v_ligne_ticket
      FROM CYPI_CERGY.TICKETS
     WHERE id_ticket = p_id_ticket;

    RETURN v_ligne_ticket;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Le ticket avec l''ID ' || p_id_ticket || ' n''existe pas.');
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Erreur lors de l''exécution de la fonction OBTENIR_TICKET : ' || SQLERRM
        );
        RETURN NULL;
END;
/


CREATE OR REPLACE FUNCTION CYPI_CERGY.OBTENIR_TICKETS_UTILISATEUR(
    p_id_utilisateur IN INT
)
RETURN SYS.ODCINUMBERLIST
IS
    liste_tickets SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
BEGIN
    FOR rec IN (
        SELECT id_ticket
          FROM CYPI_CERGY.TICKETS
         WHERE fk_createur = p_id_utilisateur
    )
    LOOP
        liste_tickets.EXTEND;
        liste_tickets(liste_tickets.LAST) := rec.id_ticket;
    END LOOP;

    RETURN liste_tickets;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            'Erreur lors de la récupération des tickets de l''utilisateur ' 
            || p_id_utilisateur || ' : ' || SQLERRM
        );
        RETURN NULL;
END;
/


CREATE OR REPLACE FUNCTION CYPI_CERGY.OBTENIR_COMMENTAIRES_TICKET(
    p_id_ticket IN INT
)
RETURN SYS.ODCINUMBERLIST
IS
    liste_commentaires SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
BEGIN
    FOR rec IN (
        SELECT id_commentaire
          FROM CYPI_CERGY.COMMENTAIRES_TICKETS
         WHERE fk_ticket = p_id_ticket
    )
    LOOP
        liste_commentaires.EXTEND;
        liste_commentaires(liste_commentaires.LAST) := rec.id_commentaire;
    END LOOP;

    RETURN liste_commentaires;
END;
/

CREATE OR REPLACE FUNCTION CYPI_CERGY.GET_TICKETS_BY_STATUS(p_statut VARCHAR2)
RETURN SYS_REFCURSOR
IS
    ticket_cursor SYS_REFCURSOR;
BEGIN
    OPEN ticket_cursor FOR
    SELECT id_ticket, titre, "description", date_creation, fk_statut
    FROM CYPI_CERGY.TICKETS
    WHERE fk_statut = (SELECT id_statut FROM CYPI_CERGY.STATUTS_TICKETS WHERE statut = p_statut);
    
    RETURN ticket_cursor;
END;
/


-------------------------------------------------------
-- CREATION DES PROCEDURES 
-------------------------------------------------------


CREATE OR REPLACE PROCEDURE CYPI_CERGY.DEFINIR_STATUT_TICKET(
    p_id_ticket   IN INT,
    p_nom_statut  IN VARCHAR2
)
IS
    v_id_statut INT;
BEGIN
    -- Vérifier si le statut existe dans la table STATUTS_TICKETS
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(p_nom_statut, 'statut', 'CYPI_CERGY.STATUTS_TICKETS') THEN
        RAISE_APPLICATION_ERROR(
            -20001, 
            'Le statut spécifié n''existe pas dans la table STATUTS_TICKETS.'
        );
    END IF;

    -- Vérifier si le ticket existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(p_id_ticket, 'id_ticket', 'CYPI_CERGY.TICKETS') THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Le ticket spécifié n''existe pas dans la table TICKETS.'
        );
    END IF;

    -- Récupérer l'ID du statut
    SELECT id_statut
      INTO v_id_statut
      FROM CYPI_CERGY.STATUTS_TICKETS
     WHERE statut = p_nom_statut;

    -- Mise à jour du statut
    UPDATE CYPI_CERGY.TICKETS
       SET fk_statut       = v_id_statut,
           date_modification = CURRENT_TIMESTAMP
     WHERE id_ticket       = p_id_ticket;

    DBMS_OUTPUT.PUT_LINE(
        'Statut du ticket ' || p_id_ticket || ' mis à jour avec succès en "' || p_nom_statut || '".'
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Erreur lors de la mise à jour du statut du ticket : ' || SQLERRM
        );
END;
/


CREATE OR REPLACE PROCEDURE CYPI_CERGY.RESOUDRE_TICKET(
    p_id_ticket         IN INT,
    p_note_resolution   IN VARCHAR2
)
IS
BEGIN
    -- Vérifier si le ticket existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(p_id_ticket, 'id_ticket', 'CYPI_CERGY.TICKETS') THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Le ticket spécifié n''existe pas dans la table TICKETS.'
        );
    END IF;

    -- Appel de la procédure de mise à jour du statut pour passer le ticket en "Terminé" (exemple)
    CYPI_CERGY.DEFINIR_STATUT_TICKET(p_id_ticket, 'Terminé');

    -- Mise à jour de la note de résolution et de la date de résolution
    UPDATE CYPI_CERGY.TICKETS
       SET note_resolution = p_note_resolution,
           date_resolution = CURRENT_TIMESTAMP
     WHERE id_ticket = p_id_ticket;

    DBMS_OUTPUT.PUT_LINE('Ticket ' || p_id_ticket || ' résolu avec succès.');

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20002, 
            'Erreur lors de la résolution du ticket : ' || SQLERRM
        );
END;
/


CREATE OR REPLACE PROCEDURE CYPI_CERGY.FERMER_TICKET(
    p_id_ticket IN INT
)
IS
BEGIN
    -- Vérifier si le ticket existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(p_id_ticket, 'id_ticket', 'CYPI_CERGY.TICKETS') THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Le ticket spécifié n''existe pas dans la table TICKETS.'
        );
    END IF;

    -- Mise à jour : date de clôture et date de modification
    UPDATE CYPI_CERGY.TICKETS
       SET date_cloture     = CURRENT_TIMESTAMP,
           date_modification = CURRENT_TIMESTAMP
     WHERE id_ticket        = p_id_ticket;

    DBMS_OUTPUT.PUT_LINE('Ticket ' || p_id_ticket || ' fermé avec succès.');

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Erreur lors de la fermeture du ticket : ' || SQLERRM
        );
END;
/


CREATE OR REPLACE PROCEDURE CYPI_CERGY.ATTRIBUER_TICKET_A_UTILISATEUR(
    p_id_ticket       IN INT,
    p_id_utilisateur  IN INT
)
IS
    v_count INT;
BEGIN
    -- Vérifie d'abord si la relation existe déjà
    SELECT COUNT(*)
      INTO v_count
      FROM CYPI_CERGY.ATTRIBUTIONS_TICKETS
     WHERE fk_ticket       = p_id_ticket
       AND fk_utilisateur  = p_id_utilisateur;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('La relation entre ce ticket et cet utilisateur existe déjà.');
    ELSE
        -- Insert la relation
        INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur)
        VALUES (p_id_ticket, p_id_utilisateur);

        DBMS_OUTPUT.PUT_LINE(
            'Ticket ' || p_id_ticket || ' attribué avec succès à l''utilisateur ' || p_id_utilisateur
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Erreur lors de l''attribution du ticket à l''utilisateur : ' || SQLERRM
        );
END;
/


CREATE OR REPLACE PROCEDURE CYPI_CERGY.AJOUTER_SUPPRIMER_OBSERVATEUR_TICKET(
    p_id_ticket       IN INT,
    p_id_utilisateur  IN INT
)
IS
    v_compte INT;
BEGIN
    -- Vérifier si le ticket existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(p_id_ticket, 'id_ticket', 'CYPI_CERGY.TICKETS') THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Le ticket spécifié n''existe pas dans la table TICKETS.'
        );
    END IF;

    -- Vérifier si l'utilisateur existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(p_id_utilisateur, 'id_utilisateur', 'CYPI_CERGY.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'L''utilisateur spécifié n''existe pas dans la table UTILISATEURS.'
        );
    END IF;

    -- Vérifier si l’observateur existe déjà
    SELECT COUNT(*)
      INTO v_compte
      FROM CYPI_CERGY.OBSERVATEURS_TICKETS
     WHERE fk_ticket       = p_id_ticket
       AND fk_utilisateur  = p_id_utilisateur;

    IF v_compte > 0 THEN
        -- Supprimer l'observateur
        DELETE FROM CYPI_CERGY.OBSERVATEURS_TICKETS
         WHERE fk_ticket       = p_id_ticket
           AND fk_utilisateur  = p_id_utilisateur;

        DBMS_OUTPUT.PUT_LINE(
            'Utilisateur ' || p_id_utilisateur 
            || ' retiré des observateurs du ticket ' || p_id_ticket
        );
    ELSE
        -- Ajouter l'observateur
        INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur)
        VALUES (p_id_ticket, p_id_utilisateur);

        DBMS_OUTPUT.PUT_LINE(
            'Utilisateur ' || p_id_utilisateur 
            || ' ajouté aux observateurs du ticket ' || p_id_ticket
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Erreur lors de l''ajout/suppression de l''observateur du ticket : ' || SQLERRM
        );
END;
/


CREATE OR REPLACE PROCEDURE CYPI_CERGY.RAFRAICHIR_VUE_MATERIELLEE(
    p_nom_vue IN VARCHAR2
)
IS
BEGIN
    DBMS_MVIEW.REFRESH(p_nom_vue);
END RAFRAICHIR_VUE_MATERIELLEE;
/


CREATE OR REPLACE PROCEDURE CYPI_CERGY.AUTO_ASSIGNER_TICKET(p_ticket_id IN INT)
IS
    v_utilisateur_id INT;
BEGIN
    -- Sélectionne l'utilisateur avec le moins de tickets attribués
    SELECT id_utilisateur INTO v_utilisateur_id
    FROM CYPI_CERGY.UTILISATEURS
    WHERE id_utilisateur NOT IN (
        SELECT fk_utilisateur FROM CYPI_CERGY.ATTRIBUTIONS_TICKETS
    )
    FETCH FIRST 1 ROWS ONLY;

    -- Assigne le ticket à l'utilisateur trouvé
    INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur)
    VALUES (p_ticket_id, v_utilisateur_id);

    DBMS_OUTPUT.PUT_LINE('Ticket ' || p_ticket_id || ' attribué à l''utilisateur ' || v_utilisateur_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun utilisateur disponible pour ce ticket.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erreur lors de l''assignation automatique : ' || SQLERRM);
END;
/



CREATE OR REPLACE PROCEDURE CYPI_CERGY.NOUVEAU_TICKET(
    p_id_createur       IN INT,       -- id de l'utilisateur créateur
    p_type              IN VARCHAR2,  -- libellé du type
    p_priorite          IN VARCHAR2,  -- libellé de la priorité
    p_categorie         IN VARCHAR2,  -- libellé de la catégorie
    p_id_groupe_attrib  IN INT,       -- groupe (id) auquel est assigné le ticket
    p_description       IN VARCHAR2,
    p_titre             IN VARCHAR2,
    p_ville             IN VARCHAR2,
    p_site              IN VARCHAR2,
    p_id_materiel       IN INT,       -- id du matériel (peut être NULL)
    p_id_ressource      IN INT        -- id de la ressource (peut être NULL)
)
IS
    v_emplacement    VARCHAR2(200) := p_ville || ' - ' || p_site;
    v_id_type        INT;
    v_id_priorite    INT;
    v_id_categorie   INT;
    v_id_emplacement INT;
    v_id_ticket      INT;
    v_id_statut      INT;
BEGIN
    ---------------------------------------------------------------------------
    -- 1) Vérifications préalables
    ---------------------------------------------------------------------------
    -- Vérifier l’existence de l’utilisateur (créateur)
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           p_id_createur,
           'id_utilisateur',
           'CYPI_CERGY.UTILISATEURS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'L''utilisateur créateur n''existe pas dans UTILISATEURS.'
        );
    END IF;

    -- Vérifier le matériel s’il n’est pas NULL
    IF p_id_materiel IS NOT NULL THEN
        IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
               p_id_materiel,
               'id_materiel',
               'CYPI_CERGY.MATERIELS'
           ) THEN
            RAISE_APPLICATION_ERROR(
                -20002,
                'Le matériel spécifié n''existe pas dans MATERIELS.'
            );
        END IF;
    END IF;

    -- Vérifier le groupe attribué s’il n’est pas NULL
    IF p_id_groupe_attrib IS NOT NULL THEN
        IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
               p_id_groupe_attrib,
               'id_groupe',
               'CYPI_CERGY.GROUPES_UTILISATEURS'
           ) THEN
            RAISE_APPLICATION_ERROR(
                -20003,
                'Le groupe spécifié n''existe pas dans GROUPES_UTILISATEURS.'
            );
        END IF;
    END IF;

    -- Vérifier que le type (ex: "Incident", "Demande", etc.) existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           p_type,
           '"type"',
           'CYPI_CERGY.TYPES_TICKETS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'Le type spécifié n''existe pas dans TYPES_TICKETS.'
        );
    END IF;

    -- Vérifier que la priorité (ex: "Haute", "Moyenne", etc.) existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           p_priorite,
           '"priorite"',
           'CYPI_CERGY.PRIORITES_TICKETS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'La priorité spécifiée n''existe pas dans PRIORITES_TICKETS.'
        );
    END IF;

    -- Vérifier que la catégorie (ex: "Logiciel", "Matériel", etc.) existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           p_categorie,
           '"categorie"',
           'CYPI_CERGY.CATEGORIES_TICKETS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20006,
            'La catégorie spécifiée n''existe pas dans CATEGORIES_TICKETS.'
        );
    END IF;

    -- Vérifier que l’emplacement (ex: "Cergy - Bâtiment A") existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           v_emplacement,
           '"emplacement"',
           'CYPI_CERGY.EMPLACEMENTS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20007,
            'Le site/villes spécifié n''existe pas dans EMPLACEMENTS.'
        );
    END IF;

    -- Vérifier la ressource si non NULL
    IF p_id_ressource IS NOT NULL THEN
        IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
               p_id_ressource,
               'id_ressource',
               'CYPI_CERGY.RESSOURCES'
           ) THEN
            RAISE_APPLICATION_ERROR(
                -20008,
                'La ressource spécifiée n''existe pas dans RESSOURCES.'
            );
        END IF;
    END IF;

    ---------------------------------------------------------------------------
    -- 2) Récupération des ID référentiels
    ---------------------------------------------------------------------------
    SELECT id_type
      INTO v_id_type
      FROM CYPI_CERGY.TYPES_TICKETS
     WHERE "type" = p_type;

    SELECT id_statut
      INTO v_id_statut
      FROM CYPI_CERGY.STATUTS_TICKETS
     WHERE UPPER(statut) = 'À FAIRE'  -- Exemple : si en base on a "À faire" ou "A FAIRE"
       OR UPPER(statut) = 'TO DO';    -- ou si vous utilisez l’anglais

    SELECT id_priorite
      INTO v_id_priorite
      FROM CYPI_CERGY.PRIORITES_TICKETS
     WHERE "priorite" = p_priorite;

    SELECT id_categorie
      INTO v_id_categorie
      FROM CYPI_CERGY.CATEGORIES_TICKETS
     WHERE "categorie" = p_categorie;

    SELECT id_emplacement
      INTO v_id_emplacement
      FROM CYPI_CERGY.EMPLACEMENTS
     WHERE "emplacement" = v_emplacement;

    ---------------------------------------------------------------------------
    -- 3) Insertion du ticket
    ---------------------------------------------------------------------------
    INSERT INTO CYPI_CERGY.TICKETS (
        id_ticket,
        fk_createur,
        fk_type,
        fk_priorite,
        titre,
        "description",
        fk_emplacement,
        date_creation,
        date_modification,
        date_resolution,
        note_resolution,
        date_cloture,
        fk_groupe_attribue,
        fk_statut,
        fk_categorie,
        fk_materiel
    ) VALUES (
        0,                      -- Supposons un trigger/sequence pour l’auto-incrément
        p_id_createur,
        v_id_type,
        v_id_priorite,
        p_titre,
        p_description,
        v_id_emplacement,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP,
        NULL,
        NULL,
        NULL,
        p_id_groupe_attrib,
        v_id_statut,
        v_id_categorie,
        p_id_materiel
    );

    -- Récupérer l’ID du ticket nouvellement créé (si séquence/triggers)
    -- Par exemple si vous avez SEQ_ID_TICKETS pour incrémenter l’ID:
    -- v_id_ticket := CYPI_CERGY.SEQ_ID_TICKETS.CURRVAL;

    -- Si on souhaite lier une ressource
    IF p_id_ressource IS NOT NULL THEN
        -- Ici, si l’on a besoin de l’ID venant d’une séquence/trigger :
        SELECT id_ticket
          INTO v_id_ticket
          FROM CYPI_CERGY.TICKETS
         WHERE ROWID = (SELECT MAX(ROWID) 
                          FROM CYPI_CERGY.TICKETS
                         WHERE fk_createur = p_id_createur);

        INSERT INTO CYPI_CERGY.TICKETS_RESSOURCES (
            fk_ressource, 
            fk_ticket
        ) VALUES (
            p_id_ressource,
            v_id_ticket
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Nouveau ticket créé avec succès pour le créateur ' || p_id_createur);

END;
/


CREATE OR REPLACE PROCEDURE CYPI_CERGY.NOUVEL_UTILISATEUR(
    p_role       IN VARCHAR2,
    p_id_groupe  IN INT,
    p_mot_de_passe IN VARCHAR2,
    p_email      IN VARCHAR2,
    p_nom        IN VARCHAR2,
    p_prenom     IN VARCHAR2,
    p_entreprise IN VARCHAR2,
    p_ville      IN VARCHAR2,
    p_site       IN VARCHAR2
)
IS
    v_id_role       INT;
    v_id_emplacement INT;
    v_emplacement    VARCHAR2(200) := p_ville || ' - ' || p_site;
BEGIN
    -- Vérifier si le rôle existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           p_role,
           '"role"',
           'CYPI_CERGY.ROLES_UTILISATEURS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Le rôle spécifié n''existe pas dans ROLES_UTILISATEURS.'
        );
    END IF;

    -- Vérifier si le groupe existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           p_id_groupe,
           'id_groupe',
           'CYPI_CERGY.GROUPES_UTILISATEURS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Le groupe spécifié n''existe pas dans GROUPES_UTILISATEURS.'
        );
    END IF;

    -- Vérifier si l’emplacement (ville-site) existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           v_emplacement,
           '"emplacement"',
           'CYPI_CERGY.EMPLACEMENTS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20006,
            'Le site/villes spécifié n''existe pas dans EMPLACEMENTS.'
        );
    END IF;

    -- Récupérer les IDs
    SELECT id_role
      INTO v_id_role
      FROM CYPI_CERGY.ROLES_UTILISATEURS
     WHERE "role" = p_role;

    SELECT id_emplacement
      INTO v_id_emplacement
      FROM CYPI_CERGY.EMPLACEMENTS
     WHERE "emplacement" = v_emplacement;

    -- Insertion de l’utilisateur
    INSERT INTO CYPI_CERGY.UTILISATEURS(
        id_utilisateur,
        fk_role,
        fk_groupe,
        "mot_de_passe",
        email,
        nom,
        prenom,
        entreprise,
        fk_emplacement
    ) VALUES (
        0,                 -- idem, supposons un trigger ou une séquence
        v_id_role,
        p_id_groupe,
        p_mot_de_passe,
        p_email,
        p_nom,
        p_prenom,
        p_entreprise,
        v_id_emplacement
    );

    DBMS_OUTPUT.PUT_LINE('Nouvel utilisateur créé : ' || p_nom || ' ' || p_prenom);

END;
/


CREATE OR REPLACE PROCEDURE CYPI_CERGY.NOUVEAU_COMMENTAIRE(
    p_id_utilisateur   IN INT,     -- auteur du commentaire
    p_id_reponse_a     IN INT,     -- commentaire auquel on répond (peut être NULL)
    p_id_ticket        IN INT,     -- ticket concerné
    p_tache            IN VARCHAR2,
    p_contenu          IN VARCHAR2,
    p_id_ressource     IN INT      -- ressource (peut être NULL)
)
IS
    v_commentaire_id INT;
BEGIN
    -- Vérifier si l'utilisateur existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           p_id_utilisateur,
           'id_utilisateur',
           'CYPI_CERGY.UTILISATEURS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'L''utilisateur spécifié n''existe pas dans UTILISATEURS.'
        );
    END IF;

    -- Vérifier si le commentaire (réponse à) existe
    IF p_id_reponse_a IS NOT NULL THEN
        IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
               p_id_reponse_a,
               'id_commentaire',
               'CYPI_CERGY.COMMENTAIRES_TICKETS'
           ) THEN
            RAISE_APPLICATION_ERROR(
                -20003,
                'Le commentaire auquel vous répondez n''existe pas.'
            );
        END IF;
    END IF;

    -- Vérifier si le ticket existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
           p_id_ticket,
           'id_ticket',
           'CYPI_CERGY.TICKETS'
       ) THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'Le ticket spécifié n''existe pas dans TICKETS.'
        );
    END IF;

    -- Vérifier la ressource
    IF p_id_ressource IS NOT NULL THEN
        IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
               p_id_ressource,
               'id_ressource',
               'CYPI_CERGY.RESSOURCES'
           ) THEN
            RAISE_APPLICATION_ERROR(
                -20005,
                'La ressource spécifiée n''existe pas dans RESSOURCES.'
            );
        END IF;
    END IF;

    -- Insertion du commentaire
    INSERT INTO CYPI_CERGY.COMMENTAIRES_TICKETS(
        id_commentaire,
        fk_reponse_a,
        fk_ticket,
        fk_utilisateur,
        date_creation,
        tache,
        "contenu"
    ) VALUES (
        0,  -- trigger/séquence
        p_id_reponse_a,
        p_id_ticket,
        p_id_utilisateur,
        CURRENT_TIMESTAMP,
        p_tache,
        p_contenu
    );

    -- Si on doit associer une ressource
    IF p_id_ressource IS NOT NULL THEN
        -- Récupérer le dernier id_commentaire inséré 
        SELECT id_commentaire
          INTO v_commentaire_id
          FROM CYPI_CERGY.COMMENTAIRES_TICKETS
         WHERE ROWID = (SELECT MAX(ROWID)
                          FROM CYPI_CERGY.COMMENTAIRES_TICKETS
                         WHERE fk_utilisateur = p_id_utilisateur
                           AND fk_ticket = p_id_ticket);

        INSERT INTO CYPI_CERGY.COMMENTAIRES_RESSOURCES(
            fk_ressource,
            fk_commentaire
        ) VALUES (
            p_id_ressource,
            v_commentaire_id
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Nouveau commentaire créé pour le ticket ' || p_id_ticket);

END;
/


COMMIT;



CREATE OR REPLACE FUNCTION CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(
    p_valeur      IN VARCHAR2,
    p_nom_colonne IN VARCHAR2,
    p_nom_table   IN VARCHAR2
)
RETURN BOOLEAN
IS
    v_count NUMBER;
BEGIN
    EXECUTE IMMEDIATE
        'SELECT COUNT(*) FROM ' || p_nom_table || ' WHERE ' || p_nom_colonne || ' = :1'
        INTO v_count
        USING p_valeur;

    RETURN (v_count > 0);
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
/
------------------------------------------------------


CREATE OR REPLACE TRIGGER CYPI_CERGY.trg_upsert_roles_utilisateurs
BEFORE INSERT ON CYPI_CERGY.ROLES_UTILISATEURS
FOR EACH ROW
BEGIN
    IF CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(:NEW."role", '"role"', 'CYPI_CERGY.ROLES_UTILISATEURS')
    THEN
        RAISE_APPLICATION_ERROR(-20000, 'Le rôle ' || :NEW."role" || ' existe déjà.');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER CYPI_CERGY.trg_upsert_groupes_utilisateurs
BEFORE INSERT ON CYPI_CERGY.GROUPES_UTILISATEURS
FOR EACH ROW
BEGIN
    IF CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(:NEW."groupe", '"groupe"', 'CYPI_CERGY.GROUPES_UTILISATEURS')
    THEN
        RAISE_APPLICATION_ERROR(-20005, 'Le groupe ' || :NEW."groupe" || ' existe déjà.');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER CYPI_CERGY.trg_upsert_emplacements
BEFORE INSERT ON CYPI_CERGY.EMPLACEMENTS
FOR EACH ROW
BEGIN
    IF CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(:NEW."emplacement", '"emplacement"', 'CYPI_CERGY.EMPLACEMENTS')
    THEN
        RAISE_APPLICATION_ERROR(-20006, 'L''emplacement ' || :NEW."emplacement" || ' existe déjà.');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER CYPI_CERGY.trg_upsert_materiels
BEFORE INSERT ON CYPI_CERGY.MATERIELS
FOR EACH ROW
BEGIN
    IF CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(:NEW."nom", '"nom"', 'CYPI_CERGY.MATERIELS')
    THEN
        RAISE_APPLICATION_ERROR(-20007, 'Le matériel ' || :NEW."nom" || ' existe déjà.');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER CYPI_CERGY.trg_upsert_utilisateurs
BEFORE INSERT OR UPDATE ON CYPI_CERGY.UTILISATEURS
FOR EACH ROW
BEGIN
    -- Vérifie si l'email existe déjà (colonne email est non quotée)
    IF CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(:NEW.email, 'email', 'CYPI_CERGY.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20009, 'Email ' || :NEW.email || ' existe déjà.');
    END IF;

    -- Vérifie si fk_emplacement existe (colonne fk_emplacement est non quotée)
    IF :NEW.fk_emplacement IS NOT NULL
       AND NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(:NEW.fk_emplacement, 'id_emplacement', 'CYPI_CERGY.EMPLACEMENTS')
    THEN
        RAISE_APPLICATION_ERROR(-20010, 'Emplacement ID ' || :NEW.fk_emplacement || ' n''existe pas.');
    END IF;

    -- Normalisation des noms et prénoms (colonnes nom, prenom, entreprise sont non quotées)
    :NEW.nom := INITCAP(:NEW.nom);
    :NEW.prenom := INITCAP(:NEW.prenom);
    :NEW.entreprise := INITCAP(:NEW.entreprise);
END;
/


CREATE OR REPLACE TRIGGER CYPI_CERGY.trg_upsert_tickets
BEFORE INSERT ON CYPI_CERGY.TICKETS
FOR EACH ROW
BEGIN
    -- Vérifie si fk_createur existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(:NEW.fk_createur, 'id_utilisateur', 'CYPI_CERGY.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20011, 'Utilisateur ID ' || :NEW.fk_createur || ' n''existe pas.');
    END IF;

    -- Vérifie si fk_priorite existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(:NEW.fk_priorite, 'id_priorite', 'CYPI_CERGY.PRIORITES_TICKETS') THEN
        RAISE_APPLICATION_ERROR(-20013, 'Priorité ID ' || :NEW.fk_priorite || ' n''existe pas.');
    END IF;

    -- Vérifie si fk_emplacement existe
    IF NOT CYPI_CERGY.VERIFIER_VALEUR_EXISTANTE(:NEW.fk_emplacement, 'id_emplacement', 'CYPI_CERGY.EMPLACEMENTS') THEN
        RAISE_APPLICATION_ERROR(-20014, 'Emplacement ID ' || :NEW.fk_emplacement || ' n''existe pas.');
    END IF;
END;
/


COMMIT;


ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

------------------------------------------
--  Création des rôles pour CYPI_CERGY
------------------------------------------

----------------------------
--  Rôle Superviseur
----------------------------
CREATE ROLE CYPI_CERGY_SUPERVISEUR;

--  Accorder l'accès en lecture (SELECT) à toutes les vues
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT view_name FROM all_views WHERE owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT ON CYPI_CERGY.' || v.view_name || ' TO CYPI_CERGY_SUPERVISEUR';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

GRANT CONNECT, CREATE SESSION TO CYPI_CERGY_SUPERVISEUR;

----------------------------
--  Rôle INGENIEUR
----------------------------
CREATE ROLE CYPI_CERGY_INGENIEUR;
GRANT CYPI_CERGY_SUPERVISEUR TO CYPI_CERGY_INGENIEUR;

--  Accorder l'accès en lecture (SELECT) sur toutes les tables
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR tbl IN (SELECT table_name FROM all_tables WHERE owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT ON CYPI_CERGY.' || tbl.table_name || ' TO CYPI_CERGY_INGENIEUR';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Autoriser la modification des tickets et commentaires
GRANT UPDATE ON CYPI_CERGY.TICKETS TO CYPI_CERGY_INGENIEUR;
GRANT UPDATE ON CYPI_CERGY.COMMENTAIRES_TICKETS TO CYPI_CERGY_INGENIEUR;

GRANT CONNECT, CREATE SESSION TO CYPI_CERGY_INGENIEUR;

----------------------------
--  Rôle EXPERT
----------------------------
CREATE ROLE CYPI_CERGY_EXPERT;
GRANT CYPI_CERGY_INGENIEUR TO CYPI_CERGY_EXPERT;

--  Accorder tous les droits (SELECT, INSERT, UPDATE, DELETE) sur toutes les tables
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR tbl IN (SELECT table_name FROM all_tables WHERE owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_CERGY.' || tbl.table_name || ' TO CYPI_CERGY_EXPERT';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Accorder tous les droits sur les vues (SELECT, INSERT, UPDATE, DELETE)
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT view_name FROM all_views WHERE owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_CERGY.' || v.view_name || ' TO CYPI_CERGY_EXPERT';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Accorder l'accès aux séquences (SELECT, ALTER)
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT sequence_name FROM all_sequences WHERE sequence_owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT, ALTER ON CYPI_CERGY.' || v.sequence_name || ' TO CYPI_CERGY_EXPERT';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

GRANT CONNECT, CREATE SESSION TO CYPI_CERGY_EXPERT;

----------------------------
--  Rôle RESPONSABLE
----------------------------
CREATE ROLE CYPI_CERGY_RESPONSABLE;

--  Donner tous les privilèges de l'expert au responsable
GRANT CYPI_CERGY_EXPERT TO CYPI_CERGY_RESPONSABLE;

--  Autoriser la création de liens de base de données
GRANT CREATE DATABASE LINK TO CYPI_CERGY_RESPONSABLE;

GRANT CONNECT, CREATE SESSION TO CYPI_CERGY_RESPONSABLE;

COMMIT;

ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

-- Création de l'utilisateur superviseur
CREATE USER CYPI_CERGY_SUPERVISEUR1 IDENTIFIED BY your_password;
GRANT CYPI_CERGY_SUPERVISEUR TO CYPI_CERGY_SUPERVISEUR1;

-- Création de l'utilisateur expert
CREATE USER CYPI_CERGY_EXPERT1 IDENTIFIED BY your_password;
GRANT CYPI_CERGY_EXPERT TO CYPI_CERGY_EXPERT1;

-- Création de l'utilisateur ingénieur
CREATE USER CYPI_CERGY_INGENIEURR IDENTIFIED BY your_password;
GRANT CYPI_CERGY_INGENIEUR TO CYPI_CERGY_INGENIEURR;

-- Création de l'utilisateur responsable
CREATE USER CYPI_CERGY_RESPONSABLE1 IDENTIFIED BY your_password;
GRANT CYPI_CERGY_RESPONSABLE TO CYPI_CERGY_RESPONSABLE1;

COMMIT;