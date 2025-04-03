-- Inserts pour ROLES_UTILISATEURS
INSERT INTO CYPI_CERGY.ROLES_UTILISATEURS (id_role, "role") VALUES (1, 'Coordinateur');
INSERT INTO CYPI_CERGY.ROLES_UTILISATEURS (id_role, "role") VALUES (2, 'Support Technique');
INSERT INTO CYPI_CERGY.ROLES_UTILISATEURS (id_role, "role") VALUES (3, 'Utilisateur Final');
INSERT INTO CYPI_CERGY.ROLES_UTILISATEURS (id_role, "role") VALUES (4, 'Chef de Projet');

-- Inserts pour GROUPES_UTILISATEURS
INSERT INTO CYPI_CERGY.GROUPES_UTILISATEURS (id_groupe, "groupe") VALUES (1, 'Équipe Logicielle');
INSERT INTO CYPI_CERGY.GROUPES_UTILISATEURS (id_groupe, "groupe") VALUES (2, 'Équipe de Test');
INSERT INTO CYPI_CERGY.GROUPES_UTILISATEURS (id_groupe, "groupe") VALUES (3, 'Service Commercial');

-- Inserts pour STATUTS_TICKETS
INSERT INTO CYPI_CERGY.STATUTS_TICKETS (id_statut, statut) VALUES (1, 'À analyser');
INSERT INTO CYPI_CERGY.STATUTS_TICKETS (id_statut, statut) VALUES (2, 'En cours de traitement');
INSERT INTO CYPI_CERGY.STATUTS_TICKETS (id_statut, statut) VALUES (3, 'En attente de validation');
INSERT INTO CYPI_CERGY.STATUTS_TICKETS (id_statut, statut) VALUES (4, 'Résolu');
INSERT INTO CYPI_CERGY.STATUTS_TICKETS (id_statut, statut) VALUES (5, 'Clôturé');
INSERT INTO CYPI_CERGY.STATUTS_TICKETS (id_statut, statut) VALUES (6, 'Rejeté');

-- Inserts pour PRIORITES_TICKETS
INSERT INTO CYPI_CERGY.PRIORITES_TICKETS (id_priorite, "priorite") VALUES (1, 'Bloquant');
INSERT INTO CYPI_CERGY.PRIORITES_TICKETS (id_priorite, "priorite") VALUES (2, 'Critique');
INSERT INTO CYPI_CERGY.PRIORITES_TICKETS (id_priorite, "priorite") VALUES (3, 'Élevée');
INSERT INTO CYPI_CERGY.PRIORITES_TICKETS (id_priorite, "priorite") VALUES (4, 'Normale');
INSERT INTO CYPI_CERGY.PRIORITES_TICKETS (id_priorite, "priorite") VALUES (5, 'Basse');
INSERT INTO CYPI_CERGY.PRIORITES_TICKETS (id_priorite, "priorite") VALUES (6, 'Très Basse');

-- Inserts pour CATEGORIES_TICKETS
INSERT INTO CYPI_CERGY.CATEGORIES_TICKETS (id_categorie, "categorie") VALUES (1, 'Problème matériel');
INSERT INTO CYPI_CERGY.CATEGORIES_TICKETS (id_categorie, "categorie") VALUES (2, 'Incident logiciel');
INSERT INTO CYPI_CERGY.CATEGORIES_TICKETS (id_categorie, "categorie") VALUES (3, 'Demande d accès');
INSERT INTO CYPI_CERGY.CATEGORIES_TICKETS (id_categorie, "categorie") VALUES (4, 'Maintenance préventive');
INSERT INTO CYPI_CERGY.CATEGORIES_TICKETS (id_categorie, "categorie") VALUES (5, 'Problème réseau');
INSERT INTO CYPI_CERGY.CATEGORIES_TICKETS (id_categorie, "categorie") VALUES (6, 'Demande d amélioration');
INSERT INTO CYPI_CERGY.CATEGORIES_TICKETS (id_categorie, "categorie") VALUES (7, 'Autre');

-- Inserts pour TYPES_TICKETS
INSERT INTO CYPI_CERGY.TYPES_TICKETS (id_type, "type") VALUES (1, 'Incident');
INSERT INTO CYPI_CERGY.TYPES_TICKETS (id_type, "type") VALUES (2, 'Demande');
INSERT INTO CYPI_CERGY.TYPES_TICKETS (id_type, "type") VALUES (3, 'Problème critique');
INSERT INTO CYPI_CERGY.TYPES_TICKETS (id_type, "type") VALUES (4, 'Consultation');
INSERT INTO CYPI_CERGY.TYPES_TICKETS (id_type, "type") VALUES (5, 'Amélioration');
INSERT INTO CYPI_CERGY.TYPES_TICKETS (id_type, "type") VALUES (6, 'Service');

-- Inserts pour EMPLACEMENTS
INSERT INTO CYPI_CERGY.EMPLACEMENTS (id_emplacement, ville, "site", "emplacement") VALUES (1, 'Cergy', 'Site du Parc', 'Avenue du Parc');
INSERT INTO CYPI_CERGY.EMPLACEMENTS (id_emplacement, ville, "site", "emplacement") VALUES (2, 'Neuville', 'Site de Neuville', '5 Mail Gay Lussac');
INSERT INTO CYPI_CERGY.EMPLACEMENTS (id_emplacement, ville, "site", "emplacement") VALUES (3, 'Cergy', 'Site des Chênes', '33 boulevard du Port');
INSERT INTO CYPI_CERGY.EMPLACEMENTS (id_emplacement, ville, "site", "emplacement") VALUES (4, 'Cergy', 'Site de St Martin', '2 Avenue Adolphe Chauvin');
INSERT INTO CYPI_CERGY.EMPLACEMENTS (id_emplacement, ville, "site", "emplacement") VALUES (5, 'Cergy', ' de St Martin', '2');

-- Inserts pour MATERIELS
INSERT INTO CYPI_CERGY.MATERIELS (id_materiel, "nom", "modele", marque, date_achat) 
VALUES (1, 'Ordinateur portable', 'ProBook 450 G7', 'HP', TO_TIMESTAMP('2022-05-15 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO CYPI_CERGY.MATERIELS (id_materiel, "nom", "modele", marque, date_achat) 
VALUES (2, 'Imprimante', 'LaserJet Pro M404n', 'HP', TO_TIMESTAMP('2021-08-25 14:20:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO CYPI_CERGY.MATERIELS (id_materiel, "nom", "modele", marque, date_achat) 
VALUES (3, 'Serveur', 'PowerEdge R740', 'Dell', TO_TIMESTAMP('2020-11-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO CYPI_CERGY.MATERIELS (id_materiel, "nom", "modele", marque, date_achat) 
VALUES (4, 'Routeur', 'RT-AC88U', 'Asus', TO_TIMESTAMP('2022-01-03 10:45:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO CYPI_CERGY.MATERIELS (id_materiel, "nom", "modele", marque, date_achat) 
VALUES (5, 'Moniteur', 'UltraSharp U2720Q', 'Dell', TO_TIMESTAMP('2023-02-18 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO CYPI_CERGY.MATERIELS (id_materiel, "nom", "modele", marque, date_achat) 
VALUES (6, 'Clavier', 'K800', 'Logitech', TO_TIMESTAMP('2022-07-06 08:30:00', 'YYYY-MM-DD HH24:MI:SS'));

    
-- Inserts pour UTILISATEURS
INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (1, 1, 1, 'P@ssword20233!', 'julien.dupont@exemple.com', 'Dupont', 'Julien', 'TechCorp', 1);

INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (2, 2, 2, 'Adm1n2023@2023', 'alice.martin@exemple.com', 'Martin', 'Alice', 'InnoSoft', 2);

INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (3, 3, 3, 'Secure@Pass987', 'paul.roux@exemple.com', 'Roux', 'Paul', 'DevSolutions', 3);

INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (4, 4, 1, 'P@ssw0rdQwerty!', 'carla.brun@exemple.com', 'Brun', 'Carla', 'TechCorp', 4);

INSERT INTO CYPI_CERGY.UTILISATEURS (id_utilisateur, fk_role, fk_groupe, "mot_de_passe", email, nom, prenom, entreprise, fk_emplacement) 
VALUES (5, 3, 3, 'MySecure@Pass123', 'leo.dubois@exemple.com', 'Dubois', 'Léo', 'CloudSystems', 5);
    
-- 1) Ajout de 10 000 UTILISATEURS supplémentaires
BEGIN
  FOR i IN 6..10005 LOOP  
    INSERT INTO CYPI_CERGY.UTILISATEURS (
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
      i,
      /* role entre 1 et 4 */
      TRUNC(DBMS_RANDOM.VALUE(1, 5)), 
      /* groupe entre 1 et 3 */
      TRUNC(DBMS_RANDOM.VALUE(1, 4)),
      /* Mot de passe random basique, adapt si besoin */
      'RandomP@ssssss' || i || '!',
      /* Email unique */
      'user_' || i || '@exemple.com',
      /* Nom & prénom randomisables */
      'Nom_' || i,
      'Prenom_' || i,
      /* Entreprise, mettons 1..5 juste pour un test */
      'Entreprise_' || TRUNC(DBMS_RANDOM.VALUE(1,6)),
      /* fk_emplacement : 1..5 */
      TRUNC(DBMS_RANDOM.VALUE(1,6))
    );
  END LOOP;
  COMMIT;
END;
/
-------------------------------------------------------------------------------

-- Inserts pour TICKETS
-- Insertion de tickets dans la table TICKETS
INSERT INTO CYPI_CERGY.TICKETS (id_ticket, fk_createur, fk_type, fk_priorite, titre, "description", fk_emplacement, date_creation, fk_groupe_attribue, fk_statut, fk_categorie, fk_materiel)
VALUES (1, 1, 2, 1, 'Problème de connexion VPN', 'L’utilisateur ne peut pas se connecter au VPN depuis son domicile.', 1, SYSTIMESTAMP, 1, 2, 3, 1);

INSERT INTO CYPI_CERGY.TICKETS (id_ticket, fk_createur, fk_type, fk_priorite, titre, "description", fk_emplacement, date_creation, fk_groupe_attribue, fk_statut, fk_categorie, fk_materiel)
VALUES (2, 2, 3, 2, 'Écran bleu au démarrage', 'L’ordinateur affiche un écran bleu dès l’allumage, impossible d’accéder au bureau.', 3, SYSTIMESTAMP, 2, 1, 1, 5);

INSERT INTO CYPI_CERGY.TICKETS (id_ticket, fk_createur, fk_type, fk_priorite, titre, "description", fk_emplacement, date_creation, fk_groupe_attribue, fk_statut, fk_categorie, fk_materiel)
VALUES (3, 3, 1, 3, 'Imprimante indisponible', 'L’imprimante ne répond plus sur le réseau, aucun utilisateur ne peut imprimer.', 2, SYSTIMESTAMP, 3, 3, 4, 2);

INSERT INTO CYPI_CERGY.TICKETS (id_ticket, fk_createur, fk_type, fk_priorite, titre, "description", fk_emplacement, date_creation, fk_groupe_attribue, fk_statut, fk_categorie, fk_materiel)
VALUES (4, 4, 2, 2, 'Problème de lenteur réseau', 'Les employés signalent des lenteurs importantes sur le réseau interne.', 4, SYSTIMESTAMP, 1, 2, 2, 3);

INSERT INTO CYPI_CERGY.TICKETS (id_ticket, fk_createur, fk_type, fk_priorite, titre, "description", fk_emplacement, date_creation, fk_groupe_attribue, fk_statut, fk_categorie, fk_materiel)
VALUES (5, 5, 1, 4, 'Demande de mise à jour logiciel', 'L’utilisateur souhaite mettre à jour son logiciel de gestion des tickets.', 5, SYSTIMESTAMP, NULL, 4, 5, NULL);


-- 2) Ajout de 10 000 TICKETS supplémentaires
BEGIN
  FOR i IN 6..10005 LOOP  
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
      i,
      
      TRUNC(DBMS_RANDOM.VALUE(1, 10006)),
      TRUNC(DBMS_RANDOM.VALUE(1, 7)),
      TRUNC(DBMS_RANDOM.VALUE(1, 7)),
      -- Titre
      'Titre Ticket #' || i,
      -- Description
      'Description generique pour le ticket ' || i || 
        '. Généré massivement par script.',

      TRUNC(DBMS_RANDOM.VALUE(1, 6)),
      
      SYSTIMESTAMP - TRUNC(DBMS_RANDOM.VALUE(0, 100)),
      
      SYSTIMESTAMP,
      
      CASE 
        WHEN DBMS_RANDOM.VALUE(0,1) < 0.5 THEN SYSTIMESTAMP 
        ELSE NULL 
      END,
     
      CASE 
        WHEN DBMS_RANDOM.VALUE(0,1) < 0.5 THEN 'Résolution auto ' || i
        ELSE NULL
      END,
      
      CASE 
        WHEN DBMS_RANDOM.VALUE(0,1) < 0.25 THEN SYSTIMESTAMP
        ELSE NULL
      END,
      
      CASE 
        WHEN DBMS_RANDOM.VALUE(0,1) < 0.7 THEN TRUNC(DBMS_RANDOM.VALUE(1, 4))
        ELSE NULL
      END,
      
      TRUNC(DBMS_RANDOM.VALUE(1, 7)),
      
      TRUNC(DBMS_RANDOM.VALUE(1, 8)),
     
      CASE 
        WHEN DBMS_RANDOM.VALUE(0,1) < 0.7 THEN TRUNC(DBMS_RANDOM.VALUE(1,7))
        ELSE NULL
      END
    );
  END LOOP;
  COMMIT;
END;
/
------------------------------------------------------------------------------- 

-- Insertion de commentaires dans la table COMMENTAIRES_TICKETS
INSERT INTO CYPI_CERGY.COMMENTAIRES_TICKETS (id_commentaire, fk_ticket, fk_utilisateur, tache, "contenu") 
VALUES (1, 1, 2, 'Analyse du problème', 'Le VPN semble bloqué au niveau du pare-feu. Vérification des logs en cours.');

INSERT INTO CYPI_CERGY.COMMENTAIRES_TICKETS (id_commentaire, fk_ticket, fk_utilisateur, tache, "contenu") 
VALUES (2, 1, 3, 'Test de connexion', 'J’ai demandé à l’utilisateur de tester une autre connexion réseau.');

INSERT INTO CYPI_CERGY.COMMENTAIRES_TICKETS (id_commentaire, fk_ticket, fk_utilisateur, fk_reponse_a, tache, "contenu") 
VALUES (3, 1, 2, 2, 'Mise à jour', 'L’utilisateur a testé un autre réseau, même problème. Possible blocage du fournisseur.');

INSERT INTO CYPI_CERGY.COMMENTAIRES_TICKETS (id_commentaire, fk_ticket, fk_utilisateur, tache, "contenu") 
VALUES (4, 2, 4, 'Diagnostic en cours', 'L’ordinateur redémarre en boucle. Vérification des erreurs système.');

INSERT INTO CYPI_CERGY.COMMENTAIRES_TICKETS (id_commentaire, fk_ticket, fk_utilisateur, fk_reponse_a, tache, "contenu") 
VALUES (5, 2, 3, 4, 'Réinstallation du système', 'Nous allons tenter une réparation du système avant un formatage complet.');

INSERT INTO CYPI_CERGY.COMMENTAIRES_TICKETS (id_commentaire, fk_ticket, fk_utilisateur, tache, "contenu") 
VALUES (6, 3, 1, 'Problème réseau', 'L’imprimante ne répond pas au ping. Vérification de la connectivité.');

INSERT INTO CYPI_CERGY.COMMENTAIRES_TICKETS (id_commentaire, fk_ticket, fk_utilisateur, fk_reponse_a, tache, "contenu") 
VALUES (7, 3, 2, 6, 'Changement de câble', 'Remplacement du câble réseau effectué, tests en cours.');

-- 3) Ajout de 10 000 COMMENTAIRES_TICKETS

BEGIN
  FOR i IN 8..10007 LOOP 
    INSERT INTO CYPI_CERGY.COMMENTAIRES_TICKETS (
      id_commentaire,
      fk_reponse_a,
      fk_ticket,
      fk_utilisateur,
      date_creation,
      tache,
      "contenu"
    ) VALUES (
      i,
      
      CASE 
        WHEN DBMS_RANDOM.VALUE(0,1) < 0.1 THEN TRUNC(DBMS_RANDOM.VALUE(1, i))
        ELSE NULL
      END,
      
      TRUNC(DBMS_RANDOM.VALUE(1, 10006)),
      
      TRUNC(DBMS_RANDOM.VALUE(1, 10006)),
      
      SYSTIMESTAMP - TRUNC(DBMS_RANDOM.VALUE(0, 50)),
      'Tache_' || i,
      'Contenu auto-généré pour le commentaire #' || i
    );
  END LOOP;
  COMMIT;
END;
/
-------------------------------------------------------------------------------

-- Insertion de ressources dans la table RESSOURCES
INSERT INTO CYPI_CERGY.RESSOURCES (id_ressource, ressource) 
VALUES (1, 'https://support.microsoft.com/en-us/windows/troubleshoot-blue-screen-errors');

INSERT INTO CYPI_CERGY.RESSOURCES (id_ressource, ressource) 
VALUES (2, 'https://www.cisco.com/c/en/us/support/switches/catalyst-2960-series-switches/tsd-products-support-troubleshoot-and-alerts.html');

INSERT INTO CYPI_CERGY.RESSOURCES (id_ressource, ressource) 
VALUES (3, 'https://www.hp.com/us-en/shop/tech-takes/how-to-fix-printer-not-responding');

INSERT INTO CYPI_CERGY.RESSOURCES (id_ressource, ressource) 
VALUES (4, 'https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/REGEXP_LIKE.html');

INSERT INTO CYPI_CERGY.RESSOURCES (id_ressource, ressource) 
VALUES (5, 'https://vpn-troubleshooting-guide.com/solutions');

INSERT INTO CYPI_CERGY.RESSOURCES (id_ressource, ressource) 
VALUES (6, 'https://networktroubleshooting.com/slow-connection');

INSERT INTO CYPI_CERGY.RESSOURCES (id_ressource, ressource) 
VALUES (7, 'https://download.cybersecurity-guidelines.com/password-security.pdf');

-- 4) Ajout de 10 000 RESSOURCES

BEGIN
  FOR i IN 8..10007 LOOP
    INSERT INTO CYPI_CERGY.RESSOURCES (
      id_ressource,
      ressource
    ) VALUES (
      i,
      'http://ressource_'|| i || '.exemple.com'
    );
  END LOOP;
  COMMIT;
END;
/
-------------------------------------------------------------------------------

-- Association des ressources aux tickets
INSERT INTO CYPI_CERGY.TICKETS_RESSOURCES (fk_ressource, fk_ticket) 
VALUES (1, 2); -- Problème d'écran bleu, lien vers guide de dépannage Windows

INSERT INTO CYPI_CERGY.TICKETS_RESSOURCES (fk_ressource, fk_ticket) 
VALUES (2, 3); -- Switch Cisco hors ligne, lien vers support Cisco

INSERT INTO CYPI_CERGY.TICKETS_RESSOURCES (fk_ressource, fk_ticket) 
VALUES (3, 5); -- Imprimante non reconnue, lien vers guide de dépannage HP

INSERT INTO CYPI_CERGY.TICKETS_RESSOURCES (fk_ressource, fk_ticket) 
VALUES (5, 1); -- Connexion VPN impossible, lien vers un guide de résolution VPN

INSERT INTO CYPI_CERGY.TICKETS_RESSOURCES (fk_ressource, fk_ticket) 
VALUES (6, 4); -- Internet lent, lien vers un guide de diagnostic réseau

INSERT INTO CYPI_CERGY.TICKETS_RESSOURCES (fk_ressource, fk_ticket) 
VALUES (7, 5); -- Politique de sécurité des mots de passe, lien vers un document interne

-- 5) Ajout de 10 000 TICKETS_RESSOURCES

BEGIN
  FOR i IN 1..10000 LOOP
    BEGIN
      INSERT INTO CYPI_CERGY.TICKETS_RESSOURCES (
        fk_ressource,
        fk_ticket
      ) VALUES (
        
        TRUNC(DBMS_RANDOM.VALUE(1, 10008)),
        
        TRUNC(DBMS_RANDOM.VALUE(1, 10006))
      );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        
        NULL;
    END;
  END LOOP;
  COMMIT;
END;
/
-------------------------------------------------------------------------------

-- Association des ressources aux commentaires
INSERT INTO CYPI_CERGY.COMMENTAIRES_RESSOURCES (fk_ressource, fk_commentaire) 
VALUES (1, 4); -- Commentaire sur un écran bleu, lien vers le guide de dépannage Windows

INSERT INTO CYPI_CERGY.COMMENTAIRES_RESSOURCES (fk_ressource, fk_commentaire) 
VALUES (2, 6); -- Commentaire sur un switch hors ligne, lien vers support Cisco

INSERT INTO CYPI_CERGY.COMMENTAIRES_RESSOURCES (fk_ressource, fk_commentaire) 
VALUES (3, 7); -- Commentaire sur une imprimante non reconnue, lien vers guide HP

INSERT INTO CYPI_CERGY.COMMENTAIRES_RESSOURCES (fk_ressource, fk_commentaire) 
VALUES (5, 3); -- Commentaire sur un VPN bloqué, lien vers un guide VPN

INSERT INTO CYPI_CERGY.COMMENTAIRES_RESSOURCES (fk_ressource, fk_commentaire) 
VALUES (6, 5); -- Commentaire sur un réseau lent, lien vers guide de diagnostic réseau

INSERT INTO CYPI_CERGY.COMMENTAIRES_RESSOURCES (fk_ressource, fk_commentaire) 
VALUES (7, 2); -- Commentaire sur la politique de mots de passe, lien vers document interne

-- 6) Ajout de 10 000 COMMENTAIRES_RESSOURCES

BEGIN
  FOR i IN 1..10000 LOOP
    BEGIN
      INSERT INTO CYPI_CERGY.COMMENTAIRES_RESSOURCES (
        fk_ressource,
        fk_commentaire
      ) VALUES (
        TRUNC(DBMS_RANDOM.VALUE(1, 10008)),  
        TRUNC(DBMS_RANDOM.VALUE(1, 10008))   
      );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END;
  END LOOP;
  COMMIT;
END;
/
-------------------------------------------------------------------------------

-- Association des observateurs aux tickets
INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (1, 3); -- L'utilisateur 3 observe le ticket 1

INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (2, 5); -- L'utilisateur 5 observe le ticket 2

INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (3, 2); -- L'utilisateur 2 observe le ticket 3

INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (4, 1); -- L'utilisateur 1 observe le ticket 4

INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (5, 4); -- L'utilisateur 4 observe le ticket 5

INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (2, 3); -- L'utilisateur 6 observe également le ticket 2

INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (3, 5); -- L'utilisateur 7 observe le ticket 3

INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (5, 5); -- L'utilisateur 8 observe le ticket 5

-- 7) Ajout de 10 000 OBSERVATEURS_TICKETS

BEGIN
  FOR i IN 1..10000 LOOP
    BEGIN
      INSERT INTO CYPI_CERGY.OBSERVATEURS_TICKETS (
        fk_ticket,
        fk_utilisateur
      ) VALUES (
        TRUNC(DBMS_RANDOM.VALUE(1, 10006)),  
        TRUNC(DBMS_RANDOM.VALUE(1, 10006))   
      );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END;
  END LOOP;
  COMMIT;
END;
/
-------------------------------------------------------------------------------

-- Attribution des tickets aux responsables
INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (1, 2); -- L'utilisateur 2 est responsable du ticket 1

INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (2, 4); -- L'utilisateur 4 est responsable du ticket 2

INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (3, 5); -- L'utilisateur 5 est responsable du ticket 3

INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (4, 5); -- L'utilisateur 6 est responsable du ticket 4

INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (5, 3); -- L'utilisateur 3 est responsable du ticket 5

INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (5, 1); -- L'utilisateur 1 est responsable du ticket 6

INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (5, 5); -- L'utilisateur 8 est responsable du ticket 7

INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (fk_ticket, fk_utilisateur) 
VALUES (5, 4); -- L'utilisateur 7 est responsable du ticket 8

-- 8) Ajout de 10 000 ATTRIBUTIONS_TICKETS

BEGIN
  FOR i IN 1..10000 LOOP
    BEGIN
      INSERT INTO CYPI_CERGY.ATTRIBUTIONS_TICKETS (
        fk_ticket,
        fk_utilisateur
      ) VALUES (
        TRUNC(DBMS_RANDOM.VALUE(1, 10006)),  
        TRUNC(DBMS_RANDOM.VALUE(1, 10006))   
      );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END;
  END LOOP;
  COMMIT;
END;
/
-------------------------------------------------------------------------------

COMMIT;