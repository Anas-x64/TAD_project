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

------------------------------------------
--  Création des rôles pour CYPI_PAU
------------------------------------------

----------------------------
--  Rôle SUPERVISEUR
----------------------------
CREATE ROLE CYPI_PAU_SUPERVISEUR;

--  Accorder l'accès en lecture (SELECT) sur toutes les vues
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT view_name FROM all_views WHERE owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT ON CYPI_PAU.' || v.view_name || ' TO CYPI_PAU_SUPERVISEUR';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

GRANT CONNECT, CREATE SESSION TO CYPI_PAU_SUPERVISEUR;

----------------------------
--  Rôle INGENIEUR
----------------------------
CREATE ROLE CYPI_PAU_INGENIEUR;
GRANT CYPI_PAU_SUPERVISEUR TO CYPI_PAU_INGENIEUR;

--  Accorder l'accès en lecture (SELECT) sur toutes les tables
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR tbl IN (SELECT table_name FROM all_tables WHERE owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT ON CYPI_PAU.' || tbl.table_name || ' TO CYPI_PAU_INGENIEUR';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Autoriser la modification des tickets et commentaires
GRANT UPDATE ON CYPI_PAU.TICKETS TO CYPI_PAU_INGENIEUR;
GRANT UPDATE ON CYPI_PAU.COMMENTAIRES_TICKETS TO CYPI_PAU_INGENIEUR;

GRANT CONNECT, CREATE SESSION TO CYPI_PAU_INGENIEUR;

----------------------------
--  Rôle EXPERT
----------------------------
CREATE ROLE CYPI_PAU_EXPERT;
GRANT CYPI_PAU_INGENIEUR TO CYPI_PAU_EXPERT;

--  Accorder tous les droits (SELECT, INSERT, UPDATE, DELETE) sur toutes les tables
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR tbl IN (SELECT table_name FROM all_tables WHERE owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_PAU.' || tbl.table_name || ' TO CYPI_PAU_EXPERT';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Accorder tous les droits sur les vues (SELECT, INSERT, UPDATE, DELETE)
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT view_name FROM all_views WHERE owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_PAU.' || v.view_name || ' TO CYPI_PAU_EXPERT';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Accorder l'accès aux séquences (SELECT, ALTER)
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT sequence_name FROM all_sequences WHERE sequence_owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT, ALTER ON CYPI_PAU.' || v.sequence_name || ' TO CYPI_PAU_EXPERT';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

GRANT CONNECT, CREATE SESSION TO CYPI_PAU_EXPERT;

----------------------------
-- Rôle RESPONSABLE
----------------------------
CREATE ROLE CYPI_PAU_RESPONSABLE;

--  Donner tous les privilèges du développeur au responsable
GRANT CYPI_PAU_EXPERT TO CYPI_PAU_RESPONSABLE;

--  Autoriser la création de liens de base de données
GRANT CREATE DATABASE LINK TO CYPI_PAU_RESPONSABLE;

GRANT CONNECT, CREATE SESSION TO CYPI_PAU_RESPONSABLE;

----------------------------
--  Rôle Master
----------------------------
CREATE ROLE CYPI_MASTER;

GRANT CYPI_CERGY_RESPONSABLE TO CYPI_MASTER;
GRANT CYPI_PAU_RESPONSABLE TO CYPI_MASTER;
GRANT CONNECT, CREATE SESSION TO CYPI_MASTER;

COMMIT;





