CREATE OR REPLACE FUNCTION CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(
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
 
 
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_roles_utilisateurs
BEFORE INSERT ON CYPI_PAU.ROLES_UTILISATEURS
FOR EACH ROW
BEGIN
    IF CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(:NEW."role", '"role"', 'CYPI_PAU.ROLES_UTILISATEURS')
    THEN
        RAISE_APPLICATION_ERROR(-20000, 'Le rôle ' || :NEW."role" || ' existe déjà.');
    END IF;
END;
/
 
 
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_groupes_utilisateurs
BEFORE INSERT ON CYPI_PAU.GROUPES_UTILISATEURS
FOR EACH ROW
BEGIN
    IF CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(:NEW."groupe", '"groupe"', 'CYPI_PAU.GROUPES_UTILISATEURS')
    THEN
        RAISE_APPLICATION_ERROR(-20005, 'Le groupe ' || :NEW."groupe" || ' existe déjà.');
    END IF;
END;
/
 
 
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_emplacements
BEFORE INSERT ON CYPI_PAU.EMPLACEMENTS
FOR EACH ROW
BEGIN
    IF CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(:NEW."emplacement", '"emplacement"', 'CYPI_PAU.EMPLACEMENTS')
    THEN
        RAISE_APPLICATION_ERROR(-20006, 'L''emplacement ' || :NEW."emplacement" || ' existe déjà.');
    END IF;
END;
/
 
 
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_materiels
BEFORE INSERT ON CYPI_PAU.MATERIELS
FOR EACH ROW
BEGIN
    IF CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(:NEW."nom", '"nom"', 'CYPI_PAU.MATERIELS')
    THEN
        RAISE_APPLICATION_ERROR(-20007, 'Le matériel ' || :NEW."nom" || ' existe déjà.');
    END IF;
END;
/
 
 
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_utilisateurs
BEFORE INSERT OR UPDATE ON CYPI_PAU.UTILISATEURS
FOR EACH ROW
BEGIN
    -- Vérifie si l'email existe déjà (colonne email est non quotée)
    IF CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(:NEW.email, 'email', 'CYPI_PAU.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20009, 'Email ' || :NEW.email || ' existe déjà.');
    END IF;
 
    -- Vérifie si fk_emplacement existe (colonne fk_emplacement est non quotée)
    IF :NEW.fk_emplacement IS NOT NULL
       AND NOT CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(:NEW.fk_emplacement, 'id_emplacement', 'CYPI_PAU.EMPLACEMENTS')
    THEN
        RAISE_APPLICATION_ERROR(-20010, 'Emplacement ID ' || :NEW.fk_emplacement || ' n''existe pas.');
    END IF;
 
    -- Normalisation des noms et prénoms (colonnes nom, prenom, entreprise sont non quotées)
    :NEW.nom := INITCAP(:NEW.nom);
    :NEW.prenom := INITCAP(:NEW.prenom);
    :NEW.entreprise := INITCAP(:NEW.entreprise);
END;
/
 
 
CREATE OR REPLACE TRIGGER CYPI_PAU.trg_upsert_tickets
BEFORE INSERT ON CYPI_PAU.TICKETS
FOR EACH ROW
BEGIN
    -- Vérifie si fk_createur existe
    IF NOT CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(:NEW.fk_createur, 'id_utilisateur', 'CYPI_PAU.UTILISATEURS') THEN
        RAISE_APPLICATION_ERROR(-20011, 'Utilisateur ID ' || :NEW.fk_createur || ' n''existe pas.');
    END IF;
 
    -- Vérifie si fk_priorite existe
    IF NOT CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(:NEW.fk_priorite, 'id_priorite', 'CYPI_PAU.PRIORITES_TICKETS') THEN
        RAISE_APPLICATION_ERROR(-20013, 'Priorité ID ' || :NEW.fk_priorite || ' n''existe pas.');
    END IF;
 
    -- Vérifie si fk_emplacement existe
    IF NOT CYPI_PAU.VERIFIER_VALEUR_EXISTANTE(:NEW.fk_emplacement, 'id_emplacement', 'CYPI_PAU.EMPLACEMENTS') THEN
        RAISE_APPLICATION_ERROR(-20014, 'Emplacement ID ' || :NEW.fk_emplacement || ' n''existe pas.');
    END IF;
END;
/
 
 
 
COMMIT;