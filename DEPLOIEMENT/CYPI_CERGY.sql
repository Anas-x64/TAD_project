ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
--  Création de la vue matérialisée principale avec tous les tickets.
CREATE MATERIALIZED VIEW CYPI_CERGY.TICKETS_GLOBAL
AS
SELECT
    E.ville AS emplacement,
    T.id_ticket,
    T.titre,
    U.nom || ' ' || U.prenom AS cree_par,
    U.email AS email_createur,
    ASS.utilisateurs_attribues AS attribue_a,
    ASS.emails_attribues AS emails_attribues,
    OBS.utilisateurs_observateurs AS observateurs,
    OBS.emails_observateurs AS emails_observateurs,
    TT."type" AS type,
    P."priorite" AS priorite,
    T."description",
    T.date_creation,
    T.date_modification,
    T.date_resolution,
    T.note_resolution,
    T.date_cloture,
    S.statut AS statut,
    C."categorie" AS categorie,
    M."nom" || ', ' || M."modele" || ', ' || M.marque || ', ' || TO_CHAR(M.date_achat, 'DD-MON-YYYY') AS materiel,
    G."groupe" AS groupe_attribue,
    LC1.id_commentaire AS "Dernier Commentaire ID",
    LC1."contenu" AS "Dernier Commentaire",
    LC2.id_commentaire AS "Avant-Dernier Commentaire ID",
    LC2."contenu" AS "Avant-Dernier Commentaire"
FROM CYPI_CERGY.TICKETS T
JOIN CYPI_CERGY.UTILISATEURS U ON T.fk_createur = U.id_utilisateur
JOIN CYPI_CERGY.PRIORITES_TICKETS P ON T.fk_priorite = P.id_priorite
JOIN CYPI_CERGY.TYPES_TICKETS TT ON T.fk_type = TT.id_type
JOIN CYPI_CERGY.EMPLACEMENTS E ON T.fk_emplacement = E.id_emplacement
JOIN CYPI_CERGY.CATEGORIES_TICKETS C ON T.fk_categorie = C.id_categorie
JOIN CYPI_CERGY.STATUTS_TICKETS S ON T.fk_statut = S.id_statut
LEFT JOIN CYPI_CERGY.MATERIELS M ON T.fk_materiel = M.id_materiel
LEFT JOIN CYPI_CERGY.GROUPES_UTILISATEURS G ON T.fk_groupe_attribue = G.id_groupe
LEFT JOIN (
    SELECT fk_ticket, id_commentaire, "contenu", 
           ROW_NUMBER() OVER(PARTITION BY fk_ticket ORDER BY date_creation DESC) AS rn
    FROM CYPI_CERGY.COMMENTAIRES_TICKETS
) LC1 ON T.id_ticket = LC1.fk_ticket AND LC1.rn = 1
LEFT JOIN (
    SELECT fk_ticket, id_commentaire, "contenu", 
           ROW_NUMBER() OVER(PARTITION BY fk_ticket ORDER BY date_creation DESC) AS rn
    FROM CYPI_CERGY.COMMENTAIRES_TICKETS
) LC2 ON T.id_ticket = LC2.fk_ticket AND LC2.rn = 2
LEFT JOIN (
    SELECT
        T.id_ticket,
        LISTAGG(U.nom || ' ' || U.prenom || ' ; ') WITHIN GROUP (ORDER BY AT.fk_utilisateur) AS utilisateurs_attribues,
        LISTAGG(U.email || ' ; ') WITHIN GROUP (ORDER BY AT.fk_utilisateur) AS emails_attribues
    FROM CYPI_CERGY.TICKETS T
    JOIN CYPI_CERGY.ATTRIBUTIONS_TICKETS AT
        ON T.id_ticket = AT.fk_ticket
    JOIN CYPI_CERGY.UTILISATEURS U
        ON AT.fk_utilisateur = U.id_utilisateur
    GROUP BY T.id_ticket
) ASS ON ASS.id_ticket = T.id_ticket
LEFT JOIN (
    SELECT
        T.id_ticket,
        LISTAGG(U.nom || ' ' || U.prenom || ' ; ') WITHIN GROUP (ORDER BY O.fk_utilisateur) AS utilisateurs_observateurs,
        LISTAGG(U.email || ' ; ') WITHIN GROUP (ORDER BY O.fk_utilisateur) AS emails_observateurs
    FROM CYPI_CERGY.TICKETS T
    JOIN CYPI_CERGY.OBSERVATEURS_TICKETS O
        ON T.id_ticket = O.fk_ticket
    JOIN CYPI_CERGY.UTILISATEURS U
        ON O.fk_utilisateur = U.id_utilisateur
    GROUP BY T.id_ticket
) OBS ON OBS.id_ticket = T.id_ticket;


--  Nombre de tickets par catégorie.
CREATE MATERIALIZED VIEW CYPI_CERGY.TICKETS_PAR_CATEGORIE AS
SELECT C."categorie", COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.CATEGORIES_TICKETS C ON TICKETS.fk_categorie = C.id_categorie
GROUP BY C."categorie";

--  Nombre de tickets par emplacement.
CREATE MATERIALIZED VIEW CYPI_CERGY.TICKETS_PAR_EMPLACEMENT AS
SELECT E."emplacement", COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.EMPLACEMENTS E ON TICKETS.fk_emplacement = E.id_emplacement
GROUP BY E."emplacement";


--  Temps moyen de résolution des tickets.
CREATE MATERIALIZED VIEW CYPI_CERGY.TEMPS_RESOLUTION_TICKETS AS
SELECT 
    TRUNC(AVG(JOURS_RESOLUTION)) AS jours_moyens,
    TRUNC(MOD(AVG(JOURS_RESOLUTION) * 24, 24)) AS heures_moyennes,
    TRUNC(MOD(AVG(JOURS_RESOLUTION) * 24 * 60, 60)) AS minutes_moyennes,
    TRUNC(MOD(AVG(JOURS_RESOLUTION) * 24 * 60 * 60, 60)) AS secondes_moyennes
FROM (
    SELECT 
        AVG(EXTRACT(DAY FROM interval_resolution)) AS JOURS_RESOLUTION
    FROM (
        SELECT 
            date_resolution - date_creation AS interval_resolution
        FROM CYPI_CERGY.TICKETS
        WHERE date_resolution IS NOT NULL
    )
);

--  Activité récente des tickets.
CREATE MATERIALIZED VIEW CYPI_CERGY.ACTIVITE_RECENTE_TICKETS AS
SELECT id_ticket, titre, date_modification
FROM (
    SELECT id_ticket, titre, date_modification
    FROM CYPI_CERGY.TICKETS
    ORDER BY date_modification DESC
)
WHERE ROWNUM <= 100;

--  Tickets ouverts par catégorie.
CREATE VIEW CYPI_CERGY.TICKETS_OUVERTS_PAR_CATEGORIE AS
SELECT C."categorie", S.statut, COUNT(*) AS tickets_ouverts
FROM CYPI_CERGY.TICKETS T
JOIN CYPI_CERGY.CATEGORIES_TICKETS C ON T.fk_categorie = C.id_categorie
JOIN CYPI_CERGY.STATUTS_TICKETS S ON T.fk_statut = S.id_statut
WHERE UPPER(S.statut) = 'A FAIRE' OR UPPER(S.statut) = 'EN COURS'
GROUP BY C."categorie", S.statut;

--  Tickets clôturés.
CREATE VIEW CYPI_CERGY.TICKETS_CLOTURES AS
SELECT T.*, S.statut
FROM CYPI_CERGY.TICKETS T
JOIN CYPI_CERGY.STATUTS_TICKETS S ON T.fk_statut = S.id_statut
WHERE S.statut = 'TERMINE';

--  Tickets par priorité.
CREATE VIEW CYPI_CERGY.TICKETS_PAR_PRIORITE AS
SELECT P."priorite", COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.PRIORITES_TICKETS P ON TICKETS.fk_priorite = P.id_priorite
GROUP BY P."priorite";

--  Tickets par statut.
CREATE VIEW CYPI_CERGY.TICKETS_PAR_STATUT AS
SELECT S.statut, COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.STATUTS_TICKETS S ON TICKETS.fk_statut = S.id_statut
GROUP BY S.statut;

--  Tickets par type.
CREATE VIEW CYPI_CERGY.TICKETS_PAR_TYPE AS
SELECT TYP."type", COUNT(*) AS nombre_tickets
FROM CYPI_CERGY.TICKETS
JOIN CYPI_CERGY.TYPES_TICKETS TYP ON TICKETS.fk_type = TYP.id_type
GROUP BY TYP."type";

COMMIT;

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

COMMIT;