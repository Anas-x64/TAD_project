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




