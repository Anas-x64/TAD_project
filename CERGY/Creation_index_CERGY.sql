-- Creation d'index B-tree pour les colonnes � valeurs presque unique. Cela nous permet de faire des op�rations d'�galit� sur ces tables 

-- Cet index peut am�liorer les performances des requ�tes qui filtrent les tickets par utilisateur. 
-- Par exemple, lors de la recherche de tous les tickets attribu�s � un utilisateur sp�cifique.
CREATE INDEX GLPI_CERGY.idx_tickets_fk_created_by ON GLPI_CERGY.TICKETS(fk_created_by);

-- Cet index peut acc�l�rer les requ�tes qui impliquent le tri ou le filtrage par date de cr�ation des tickets.
CREATE INDEX GLPI_CERGY.idx_tickets_creation_date ON GLPI_CERGY.TICKETS(creation_datetime);

-- De la m�me mani�re, cet index peut acc�l�rer les requ�tes qui impliquent le tri ou le filtrage par date de modification des tickets.
CREATE INDEX GLPI_CERGY.idx_tickets_last_modification_date ON GLPI_CERGY.TICKETS(last_modification_datetime);

-- De la m�me mani�re, cet index peut acc�l�rer les requ�tes qui impliquent le tri ou le filtrage par date de resolution des tickets.
CREATE INDEX GLPI_CERGY.idx_tickets_resolution_date ON GLPI_CERGY.TICKETS(resolution_datetime);

-- De la m�me mani�re, cet index peut acc�l�rer les requ�tes qui impliquent le tri ou le filtrage par date de cl�ture des tickets.
CREATE INDEX GLPI_CERGY.idx_tickets_closing_date ON GLPI_CERGY.TICKETS(closing_datetime);

-- Cet index peut acc�l�rer les requ�tes qui impliquent le tri ou le filtrage par priorit� de ticket, 
-- ce qui est une op�ration courante dans les syst�mes de gestion des tickets.
CREATE INDEX GLPI_CERGY.idx_tickets_fk_priority ON GLPI_CERGY.TICKETS(fk_priority);

-- Cet index peut �tre utile pour les requ�tes qui impliquent la localisation physique des tickets, 
-- comme la recherche de tous les tickets associ�s � une certaine localisation.
CREATE INDEX GLPI_CERGY.idx_tickets_fk_location ON GLPI_CERGY.TICKETS(fk_location);

-- Cet index peut acc�l�rer les requ�tes qui impliquent le tri ou le filtrage par priorit� de ticket, 
-- ce qui est une op�ration courante dans les syst�mes de gestion des tickets.
CREATE INDEX GLPI_CERGY.idx_comments_fk_ticket ON GLPI_CERGY.COMMENTS(fk_ticket);

-- Cet index peut �tre utilis� pour optimiser les requ�tes qui r�cup�rent tous les commentaires laiss�s par un utilisateur sp�cifique.
CREATE INDEX GLPI_CERGY.idx_comments_fk_user ON GLPI_CERGY.COMMENTS(fk_user);


-- Creation d'index Bitmap pour les colonnes � faible valeurs distinctes. Cela nous permet de faire des op�rations de filtrage sur ces tables.

-- �tant donn� que le r�le d'un utilisateur est souvent limit� � un nombre restreint de valeurs (par exemple, "Support", "IT", "RH"), 
-- un index bitmap peut �tre efficace pour am�liorer les performances des requ�tes qui filtrent ou agr�gent les utilisateurs par r�le.
CREATE BITMAP INDEX GLPI_CERGY.idx_users_fk_role ON GLPI_CERGY.USERS(fk_role);

-- De m�me, comme les utilisateurs peuvent appartenir � un groupe sp�cifique, 
-- un index bitmap peut �tre avantageux pour les requ�tes qui travaillent avec des groupes d'utilisateurs.
CREATE BITMAP INDEX GLPI_CERGY.idx_users_fk_group ON GLPI_CERGY.USERS(fk_group);

-- Cet index bitmap peut �tre utile pour les requ�tes qui impliquent la classification des tickets par type, 
-- par exemple, trouver tous les tickets de type "D�faut" ou "Demande".
CREATE BITMAP INDEX GLPI_CERGY.idx_tickets_fk_type ON GLPI_CERGY.TICKETS(fk_type);

-- Comme les �tats des tickets sont g�n�ralement limit�s � un petit ensemble de valeurs (par exemple, "� faire", "En cours", "Termin�"), 
-- un index bitmap peut acc�l�rer les requ�tes qui filtrent ou agr�gent les tickets par �tat.
CREATE BITMAP INDEX GLPI_CERGY.idx_tickets_fk_status ON GLPI_CERGY.TICKETS(fk_status);

-- Cet index bitmap peut �tre utile pour les requ�tes qui impliquent la classification des tickets par categorie. 
CREATE BITMAP INDEX GLPI_CERGY.idx_tickets_fk_category ON GLPI_CERGY.TICKETS(fk_category);

-- Cet index bitmap peut �tre b�n�fique pour les requ�tes qui filtrent ou agr�gent les tickets par groupe assign�.
CREATE BITMAP INDEX GLPI_CERGY.idx_tickets_fk_assigned_group ON GLPI_CERGY.TICKETS(fk_assigned_group);



-- Creation d'index composite pour am�liorer les performances des requ�tes fr�quentes en prenant en compte plusieurs colonnes importantes pour les requ�tes

-- Index composite sur la table TICKETS pour am�liorer les performances des requ�tes fr�quentes filtrant par �tat et priorit�.
CREATE INDEX GLPI_CERGY.idx_tickets_status_priority ON GLPI_CERGY.TICKETS(fk_status, fk_priority);

-- Index composite sur la table COMMENTS pour acc�l�rer les requ�tes filtrant par utilisateur et date de cr�ation.
CREATE INDEX GLPI_CERGY.idx_comments_user_creation_date ON GLPI_CERGY.COMMENTS(fk_user, creation_datetime);

-- Index composite sur la table USERS pour acc�l�rer les requ�tes filtrant par r�le et entreprise.
CREATE INDEX GLPI_CERGY.idx_users_role_company ON GLPI_CERGY.USERS(fk_role, company);

-- Index composite sur la table USERS pour optimiser les requ�tes filtrant par groupe et entreprise.
CREATE INDEX GLPI_CERGY.idx_users_group_company ON GLPI_CERGY.USERS(fk_group, company);

-- Index composite sur la table USERS pour optimiser les requ�tes filtrant par lieu et entreprise.
CREATE INDEX GLPI_CERGY.idx_users_location_company ON GLPI_CERGY.USERS(fk_location, company);



-- Nous avons limit� le nombre d'index car un surnombre d'index pourrait entrainer des surcouts de maintenance et de stockage. 
-- Nous nous limitons aux indexs les plus importants.
COMMIT;
exit;
