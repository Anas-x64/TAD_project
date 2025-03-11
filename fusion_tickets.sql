ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

----------------------------------------------------------
--  Vue Globale pour CYPI_CERGY : Fusion des tickets
----------------------------------------------------------
CREATE VIEW CYPI_CERGY.TICKETS_GLOBAUX
AS
SELECT * FROM CYPI_CERGY.TICKETS_GLOBAL
UNION 
SELECT * FROM CYPI_PAU.TICKETS_GLOBAL@LK_CYPI_PAU;

--  Accorder les permissions à CYPI_CERGY_DEV
GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_CERGY.TICKETS_GLOBAUX TO CYPI_CERGY_DEV;

----------------------------------------------------------
--  Vue Globale pour CYPI_PAU : Fusion des tickets
----------------------------------------------------------
CREATE VIEW CYPI_PAU.TICKETS_GLOBAUX
AS
SELECT * FROM CYPI_PAU.TICKETS_GLOBAL
UNION 
SELECT * FROM CYPI_CERGY.TICKETS_GLOBAL@LK_CYPI_CERGY;

--  Accorder les permissions à CYPI_PAU_DEV
GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_PAU.TICKETS_GLOBAUX TO CYPI_PAU_DEV;

COMMIT;