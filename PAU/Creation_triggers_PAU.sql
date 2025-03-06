-- Fonction améliorée pour vérifier l'existence d'une valeur
CREATE OR REPLACE FUNCTION CHECK_VALUE_EXIST(p_value VARCHAR2, p_column VARCHAR2, p_table VARCHAR2) RETURN BOOLEAN IS
    v_count NUMBER;
    v_sql VARCHAR2(4000);
BEGIN
    v_sql := 'SELECT COUNT(*) FROM ' || p_table || ' WHERE ' || p_column || ' = :1';
    EXECUTE IMMEDIATE v_sql INTO v_count USING p_value;
    RETURN v_count > 0;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
/
 
-- Trigger pour éviter la duplication des rôles utilisateurs
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_roles_utilisateurs
BEFORE INSERT ON CYPI_PAU.ROLES_UTILISATEURS
FOR EACH ROW
BEGIN
    IF CHECK_VALUE_EXIST(:NEW.role, 'role', 'CYPI_PAU.ROLES_UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20000, 'Le rôle ' || :NEW.role || ' existe déjà.');
    END IF;
END;
/
 
-- Trigger pour éviter la duplication des groupes utilisateurs
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_groupes_utilisateurs
BEFORE INSERT ON CYPI_PAU.GROUPES_UTILISATEURS
FOR EACH ROW
BEGIN
    IF CHECK_VALUE_EXIST(:NEW.groupe, 'groupe', 'CYPI_PAU.GROUPES_UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20005, 'Le groupe ' || :NEW.groupe || ' existe déjà.');
    END IF;
END;
/
 
-- Trigger pour éviter la duplication des emplacements
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_emplacements
BEFORE INSERT ON CYPI_PAU.EMPLACEMENTS
FOR EACH ROW
BEGIN
    IF CHECK_VALUE_EXIST(:NEW.emplacement, 'emplacement', 'CYPI_PAU.EMPLACEMENTS') THEN
        RAISE_APPLICATION_ERROR(-20006, 'L''emplacement ' || :NEW.emplacement || ' existe déjà.');
    END IF;
END;
/
 
-- Trigger pour éviter la duplication des matériels
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_materiels
BEFORE INSERT ON CYPI_PAU.MATERIELS
FOR EACH ROW
BEGIN
    IF CHECK_VALUE_EXIST(:NEW.nom, 'nom', 'CYPI_PAU.MATERIELS') THEN
        RAISE_APPLICATION_ERROR(-20007, 'Le matériel ' || :NEW.nom || ' existe déjà.');
    END IF;
END;
/
 
-- Trigger pour UTILISATEURS (formatage et vérifications)
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_utilisateurs
BEFORE INSERT OR UPDATE ON CYPI_PAU.UTILISATEURS
FOR EACH ROW
BEGIN
    IF CHECK_VALUE_EXIST(:NEW.email, 'email', 'CYPI_PAU.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20009, 'Email ' || :NEW.email || ' existe déjà.');
    END IF;
 
    IF :NEW.fk_emplacement IS NOT NULL AND NOT CHECK_VALUE_EXIST(:NEW.fk_emplacement, 'id_emplacement', 'CYPI_PAU.EMPLACEMENTS') THEN
        RAISE_APPLICATION_ERROR(-20010, 'Emplacement ID ' || :NEW.fk_emplacement || ' n''existe pas.');
    END IF;
 
    -- Normalisation des noms et prénoms
    :NEW.nom := INITCAP(:NEW.nom);
    :NEW.prenom := INITCAP(:NEW.prenom);
    :NEW.entreprise := INITCAP(:NEW.entreprise);
END;
/
 
-- Trigger pour TICKETS (vérifications des clés étrangères)
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_tickets
BEFORE INSERT ON CYPI_PAU.TICKETS
FOR EACH ROW
BEGIN
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_createur, 'id_utilisateur', 'CYPI_PAU.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20011, 'Utilisateur ID ' || :NEW.fk_createur || ' n''existe pas.');
    END IF;
 
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_priorite, 'id_priorite', 'CYPI_PAU.PRIORITES_TICKETS') THEN
        RAISE_APPLICATION_ERROR(-20013, 'Priorité ID ' || :NEW.fk_priorite || ' n''existe pas.');
    END IF;
 
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_emplacement, 'id_emplacement', 'CYPI_PAU.EMPLACEMENTS') THEN
        RAISE_APPLICATION_ERROR(-20014, 'Emplacement ID ' || :NEW.fk_emplacement || ' n''existe pas.');
    END IF;
END;
/
 
-- Trigger pour COMMENTAIRES_TICKETS (vérifications des références)
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_commentaires_tickets
BEFORE INSERT ON CYPI_PAU.COMMENTAIRES_TICKETS
FOR EACH ROW
BEGIN
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_ticket, 'id_ticket', 'CYPI_PAU.TICKETS') THEN
        RAISE_APPLICATION_ERROR(-20019, 'Ticket ID ' || :NEW.fk_ticket || ' n''existe pas.');
    END IF;
 
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_utilisateur, 'id_utilisateur', 'CYPI_PAU.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20020, 'Utilisateur ID ' || :NEW.fk_utilisateur || ' n''existe pas.');
    END IF;
END;
/
 
-- Trigger pour OBSERVATEURS_TICKETS
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_observateurs_tickets
BEFORE INSERT ON CYPI_PAU.OBSERVATEURS_TICKETS
FOR EACH ROW
BEGIN
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_ticket, 'id_ticket', 'CYPI_PAU.TICKETS') THEN
        RAISE_APPLICATION_ERROR(-20026, 'Ticket ID ' || :NEW.fk_ticket || ' n''existe pas.');
    END IF;
 
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_utilisateur, 'id_utilisateur', 'CYPI_PAU.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20027, 'Utilisateur ID ' || :NEW.fk_utilisateur || ' n''existe pas.');
    END IF;
END;
/
 
-- Trigger pour ATTRIBUTIONS_TICKETS
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_attributions_tickets
BEFORE INSERT ON CYPI_PAU.ATTRIBUTIONS_TICKETS
FOR EACH ROW
BEGIN
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_ticket, 'id_ticket', 'CYPI_PAU.TICKETS') THEN
        RAISE_APPLICATION_ERROR(-20028, 'Ticket ID ' || :NEW.fk_ticket || ' n''existe pas.');
    END IF;
 
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_utilisateur, 'id_utilisateur', 'CYPI_PAU.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20029, 'Utilisateur ID ' || :NEW.fk_utilisateur || ' n''existe pas.');
    END IF;
END;
/
 
-- Trigger pour TICKETS_RESSOURCES
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_tickets_ressources
BEFORE INSERT ON CYPI_PAU.TICKETS_RESSOURCES
FOR EACH ROW
BEGIN
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_ticket, 'id_ticket', 'CYPI_PAU.TICKETS') THEN
        RAISE_APPLICATION_ERROR(-20030, 'Ticket ID ' || :NEW.fk_ticket || ' n''existe pas.');
    END IF;
 
    IF NOT CHECK_VALUE_EXIST(:NEW.fk_ressource, 'id_ressource', 'CYPI_PAU.RESSOURCES') THEN
        RAISE_APPLICATION_ERROR(-20031, 'Ressource ID ' || :NEW.fk_ressource || ' n''existe pas.');
    END IF;
END;
/
 
COMMIT;
EXIT;
 
 