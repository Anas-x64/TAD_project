ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

------------------------------------------
--  Création des rôles pour CYPI_CERGY
------------------------------------------

----------------------------
--  Rôle Observateur
----------------------------
CREATE ROLE CYPI_CERGY_OBSERVATEUR;

--  Accorder l'accès en lecture (SELECT) à toutes les vues
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT view_name FROM all_views WHERE owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT ON CYPI_CERGY.' || v.view_name || ' TO CYPI_CERGY_OBSERVATEUR';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

GRANT CONNECT, CREATE SESSION TO CYPI_CERGY_OBSERVATEUR;

----------------------------
--  Rôle Analyste
----------------------------
CREATE ROLE CYPI_CERGY_ANALYSTE;
GRANT CYPI_CERGY_OBSERVATEUR TO CYPI_CERGY_ANALYSTE;

--  Accorder l'accès en lecture (SELECT) sur toutes les tables
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR tbl IN (SELECT table_name FROM all_tables WHERE owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT ON CYPI_CERGY.' || tbl.table_name || ' TO CYPI_CERGY_ANALYSTE';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Autoriser la modification des tickets et commentaires
GRANT UPDATE ON CYPI_CERGY.TICKETS TO CYPI_CERGY_ANALYSTE;
GRANT UPDATE ON CYPI_CERGY.COMMENTAIRES_TICKETS TO CYPI_CERGY_ANALYSTE;

GRANT CONNECT, CREATE SESSION TO CYPI_CERGY_ANALYSTE;

----------------------------
--  Rôle Développeur
----------------------------
CREATE ROLE CYPI_CERGY_DEV;
GRANT CYPI_CERGY_ANALYSTE TO CYPI_CERGY_DEV;

--  Accorder tous les droits (SELECT, INSERT, UPDATE, DELETE) sur toutes les tables
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR tbl IN (SELECT table_name FROM all_tables WHERE owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_CERGY.' || tbl.table_name || ' TO CYPI_CERGY_DEV';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Accorder tous les droits sur les vues (SELECT, INSERT, UPDATE, DELETE)
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT view_name FROM all_views WHERE owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_CERGY.' || v.view_name || ' TO CYPI_CERGY_DEV';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Accorder l'accès aux séquences (SELECT, ALTER)
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT sequence_name FROM all_sequences WHERE sequence_owner = 'CYPI_CERGY') LOOP
    v_sql := 'GRANT SELECT, ALTER ON CYPI_CERGY.' || v.sequence_name || ' TO CYPI_CERGY_DEV';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

GRANT CONNECT, CREATE SESSION TO CYPI_CERGY_DEV;

----------------------------
--  Rôle Administrateur
----------------------------
CREATE ROLE CYPI_CERGY_ADMIN;

--  Donner tous les privilèges du développeur à l'administrateur
GRANT CYPI_CERGY_DEV TO CYPI_CERGY_ADMIN;

--  Autoriser la création de liens de base de données
GRANT CREATE DATABASE LINK TO CYPI_CERGY_ADMIN;

GRANT CONNECT, CREATE SESSION TO CYPI_CERGY_ADMIN;

------------------------------------------
--  Création des rôles pour CYPI_PAU
------------------------------------------

----------------------------
--  Rôle Observateur
----------------------------
CREATE ROLE CYPI_PAU_OBSERVATEUR;

--  Accorder l'accès en lecture (SELECT) sur toutes les vues
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT view_name FROM all_views WHERE owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT ON CYPI_PAU.' || v.view_name || ' TO CYPI_PAU_OBSERVATEUR';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

GRANT CONNECT, CREATE SESSION TO CYPI_PAU_OBSERVATEUR;

----------------------------
--  Rôle Analyste
----------------------------
CREATE ROLE CYPI_PAU_ANALYSTE;
GRANT CYPI_PAU_OBSERVATEUR TO CYPI_PAU_ANALYSTE;

--  Accorder l'accès en lecture (SELECT) sur toutes les tables
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR tbl IN (SELECT table_name FROM all_tables WHERE owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT ON CYPI_PAU.' || tbl.table_name || ' TO CYPI_PAU_ANALYSTE';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Autoriser la modification des tickets et commentaires
GRANT UPDATE ON CYPI_PAU.TICKETS TO CYPI_PAU_ANALYSTE;
GRANT UPDATE ON CYPI_PAU.COMMENTAIRES_TICKETS TO CYPI_PAU_ANALYSTE;

GRANT CONNECT, CREATE SESSION TO CYPI_PAU_ANALYSTE;

----------------------------
--  Rôle Développeur
----------------------------
CREATE ROLE CYPI_PAU_DEV;
GRANT CYPI_PAU_ANALYSTE TO CYPI_PAU_DEV;

--  Accorder tous les droits (SELECT, INSERT, UPDATE, DELETE) sur toutes les tables
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR tbl IN (SELECT table_name FROM all_tables WHERE owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_PAU.' || tbl.table_name || ' TO CYPI_PAU_DEV';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Accorder tous les droits sur les vues (SELECT, INSERT, UPDATE, DELETE)
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT view_name FROM all_views WHERE owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT, INSERT, UPDATE, DELETE ON CYPI_PAU.' || v.view_name || ' TO CYPI_PAU_DEV';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

--  Accorder l'accès aux séquences (SELECT, ALTER)
DECLARE
  v_sql VARCHAR2(2000);
BEGIN
  FOR v IN (SELECT sequence_name FROM all_sequences WHERE sequence_owner = 'CYPI_PAU') LOOP
    v_sql := 'GRANT SELECT, ALTER ON CYPI_PAU.' || v.sequence_name || ' TO CYPI_PAU_DEV';
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
END;
/

GRANT CONNECT, CREATE SESSION TO CYPI_PAU_DEV;

----------------------------
-- Rôle Administrateur
----------------------------
CREATE ROLE CYPI_PAU_ADMIN;

--  Donner tous les privilèges du développeur à l'administrateur
GRANT CYPI_PAU_DEV TO CYPI_PAU_ADMIN;

--  Autoriser la création de liens de base de données
GRANT CREATE DATABASE LINK TO CYPI_PAU_ADMIN;

GRANT CONNECT, CREATE SESSION TO CYPI_PAU_ADMIN;

----------------------------
--  Rôle Super Admin
----------------------------
CREATE ROLE CYPI_FULL_ADMIN;

GRANT CYPI_CERGY_ADMIN TO CYPI_FULL_ADMIN;
GRANT CYPI_PAU_ADMIN TO CYPI_FULL_ADMIN;
GRANT CONNECT, CREATE SESSION TO CYPI_FULL_ADMIN;

COMMIT;





