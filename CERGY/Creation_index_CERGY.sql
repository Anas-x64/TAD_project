--------------------------------------------
-- CREATION DES INDEX B-TREE
--------------------------------------------

-- Index pour optimiser la recherche des tickets par créateur
CREATE INDEX CYPI_CERGY.idx_tickets_fk_createur ON CYPI_CERGY.TICKETS(fk_createur);

-- Index pour optimiser le tri et le filtrage par date de création des tickets
CREATE INDEX CYPI_CERGY.idx_tickets_date_creation ON CYPI_CERGY.TICKETS(date_creation);

-- Index pour optimiser le tri et le filtrage par date de dernière modification des tickets
CREATE INDEX CYPI_CERGY.idx_tickets_derniere_modif ON CYPI_CERGY.TICKETS(date_modification);

-- Index pour optimiser le tri et le filtrage par date de résolution des tickets
CREATE INDEX CYPI_CERGY.idx_tickets_date_resolution ON CYPI_CERGY.TICKETS(date_resolution);

-- Index pour optimiser le tri et le filtrage par date de clôture des tickets
CREATE INDEX CYPI_CERGY.idx_tickets_date_cloture ON CYPI_CERGY.TICKETS(date_cloture);

-- Index pour accélérer les requêtes qui filtrent les tickets par priorité
CREATE INDEX CYPI_CERGY.idx_tickets_fk_priorite ON CYPI_CERGY.TICKETS(fk_priorite);

-- Index pour accélérer les requêtes qui filtrent les tickets par emplacement
CREATE INDEX CYPI_CERGY.idx_tickets_fk_emplacement ON CYPI_CERGY.TICKETS(fk_emplacement);

-- Index pour accélérer les requêtes qui filtrent les commentaires par ticket
CREATE INDEX CYPI_CERGY.idx_commentaires_fk_ticket ON CYPI_CERGY.COMMENTAIRES_TICKETS(fk_ticket);

-- Index pour optimiser les requêtes qui récupèrent tous les commentaires d'un utilisateur
CREATE INDEX CYPI_CERGY.idx_commentaires_fk_utilisateur ON CYPI_CERGY.COMMENTAIRES_TICKETS(fk_utilisateur);

--------------------------------------------
-- CREATION DES INDEX BITMAP
--------------------------------------------

-- Index bitmap pour optimiser les requêtes qui filtrent les utilisateurs par rôle
CREATE BITMAP INDEX CYPI_CERGY.idx_utilisateurs_fk_role ON CYPI_CERGY.UTILISATEURS(fk_role);

-- Index bitmap pour optimiser les requêtes qui filtrent les utilisateurs par groupe
CREATE BITMAP INDEX CYPI_CERGY.idx_utilisateurs_fk_groupe ON CYPI_CERGY.UTILISATEURS(fk_groupe);

-- Index bitmap pour optimiser les requêtes qui classifient les tickets par type
CREATE BITMAP INDEX CYPI_CERGY.idx_tickets_fk_type ON CYPI_CERGY.TICKETS(fk_type);

-- Index bitmap pour optimiser les requêtes qui classifient les tickets par statut
CREATE BITMAP INDEX CYPI_CERGY.idx_tickets_fk_statut ON CYPI_CERGY.TICKETS(fk_statut);

-- Index bitmap pour optimiser les requêtes qui classifient les tickets par catégorie
CREATE BITMAP INDEX CYPI_CERGY.idx_tickets_fk_categorie ON CYPI_CERGY.TICKETS(fk_categorie);

-- Index bitmap pour optimiser les requêtes qui filtrent les tickets par groupe assigné
CREATE BITMAP INDEX CYPI_CERGY.idx_tickets_fk_groupe_attribue ON CYPI_CERGY.TICKETS(fk_groupe_attribue);

--------------------------------------------
-- CREATION DES INDEX COMPOSITES
--------------------------------------------

-- Index composite sur les tickets pour améliorer les performances des requêtes filtrant par statut et priorité
CREATE INDEX CYPI_CERGY.idx_tickets_statut_priorite ON CYPI_CERGY.TICKETS(fk_statut, fk_priorite);

-- Index composite sur les commentaires pour accélérer les requêtes filtrant par utilisateur et date de création
CREATE INDEX CYPI_CERGY.idx_commentaires_utilisateur_date_creation ON CYPI_CERGY.COMMENTAIRES_TICKETS(fk_utilisateur, date_creation);

-- Index composite sur les utilisateurs pour optimiser les requêtes filtrant par rôle et entreprise
CREATE INDEX CYPI_CERGY.idx_utilisateurs_role_entreprise ON CYPI_CERGY.UTILISATEURS(fk_role, entreprise);

-- Index composite sur les utilisateurs pour optimiser les requêtes filtrant par groupe et entreprise
CREATE INDEX CYPI_CERGY.idx_utilisateurs_groupe_entreprise ON CYPI_CERGY.UTILISATEURS(fk_groupe, entreprise);

-- Index composite sur les utilisateurs pour optimiser les requêtes filtrant par emplacement et entreprise
CREATE INDEX CYPI_CERGY.idx_utilisateurs_emplacement_entreprise ON CYPI_CERGY.UTILISATEURS(fk_emplacement, entreprise);

--------------------------------------------
-- VALIDATION ET COMMIT
--------------------------------------------
COMMIT;
EXIT;
