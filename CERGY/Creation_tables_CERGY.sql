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
    "emplacement" VARCHAR2(103) NOT NULL UNIQUE  
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

