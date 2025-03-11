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
DROP ROLE CYPI_FULL_ADMIN;
DROP ROLE CYPI_CERGY_ADMIN;
DROP ROLE CYPI_CERGY_DEV;
DROP ROLE CYPI_CERGY_ANALYSTE;
DROP ROLE CYPI_CERGY_OBSERVATEUR;
DROP ROLE CYPI_PAU_ADMIN;
DROP ROLE CYPI_PAU_DEV;
DROP ROLE CYPI_PAU_ANALYSTE;
DROP ROLE CYPI_PAU_OBSERVATEUR;

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
DROP USER CYPI_CERGY_OBSERVATEUR1 CASCADE;
DROP USER CYPI_CERGY_ANALYST1     CASCADE;
DROP USER CYPI_CERGY_DEV1         CASCADE;
DROP USER CYPI_CERGY_ADMIN1       CASCADE;

COMMIT;
---------------------------------------------------------------
-- FIN DE LA SECTION DROP
---------------------------------------------------------------


