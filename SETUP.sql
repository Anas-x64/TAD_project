-------------------------------------------
-- CREATION DE LA BDD
-------------------------------------------

ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
SET SERVEROUTPUT OFF;

--Creation TABLESPACES et SCHEMA CYPI_PAU
CREATE TABLESPACE CYPI_PAU_ESPACE
datafile 'C:\Oracle\oradata\FREE\PAU\CYPI_PAU_ESPACE.dat'
SIZE 100M AUTOEXTEND ON;

CREATE TEMPORARY TABLESPACE CYPI_PAU_ESPACE_TEMP
tempfile 'C:\Oracle\oradata\FREE\PAU\CYPI_PAU_ESPACE_TEMP.dat'
SIZE 50M AUTOEXTEND ON;

CREATE USER CYPI_PAU
IDENTIFIED BY CYPI_PAU_PASSWORD
DEFAULT TABLESPACE CYPI_PAU_ESPACE
TEMPORARY TABLESPACE CYPI_PAU_ESPACE_TEMP;
GRANT CONNECT, CREATE SESSION TO CYPI_PAU;
GRANT DBA TO CYPI_PAU;

--Creation TABLESPACES et SCHEMA CYPI_CERGY
CREATE TABLESPACE CYPI_CERGY_ESPACE
datafile 'C:\Oracle\oradata\FREE\PAU\CYPI_CERGY_ESPACE.dat'
SIZE 100M AUTOEXTEND ON;

CREATE TEMPORARY TABLESPACE CYPI_CERGY_ESPACE_TEMP
tempfile 'C:\Oracle\oradata\FREE\PAU\CYPI_CERGY_ESPACE_TEMP.dat'
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
EXIT;

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
EXIT;

