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