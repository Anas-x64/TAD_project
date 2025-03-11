-- Création des séquences pour gérer les ID des tables

--  Séquence pour les rôles des utilisateurs.
CREATE SEQUENCE CYPI_CERGY.seq_id_roles_utilisateurs
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les groupes d’utilisateurs.
CREATE SEQUENCE CYPI_CERGY.seq_id_groupes_utilisateurs
  START WITH 1
  INCREMENT BY 1;

-- Séquence pour les statuts des tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_statuts_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les priorités des tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_priorites_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les catégories des tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_categories_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les types de tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_types_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les emplacements.
CREATE SEQUENCE CYPI_CERGY.seq_id_emplacements
  START WITH 1
  INCREMENT BY 1;

-- Séquence pour les matériels liés aux tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_materiels
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les utilisateurs.
CREATE SEQUENCE CYPI_CERGY.seq_id_utilisateurs
  START WITH 1
  INCREMENT BY 1;

-- Séquence pour les tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_tickets
  START WITH 1
  INCREMENT BY 1;

-- Séquence pour les commentaires des tickets.
CREATE SEQUENCE CYPI_CERGY.seq_id_commentaires_tickets
  START WITH 1
  INCREMENT BY 1;

--  Séquence pour les ressources.
CREATE SEQUENCE CYPI_CERGY.seq_id_ressources
  START WITH 1
  INCREMENT BY 1;

COMMIT;

