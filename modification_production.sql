-- SGBD MariaDB

-- Modification du schéma actuel

-- Création de la table entrepot qui fait le lien entre
-- un produit, son emplacement et sa localisation
DROP TABLE IF EXISTS entrepot;
CREATE TABLE `entrepot` (
  `id_entrepot` int PRIMARY KEY AUTO_INCREMENT,
  `id_loca` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Polutation de la table entrepot avec une valeur
INSERT INTO entrepot (id_loca) 
SELECT id_loca FROM localisation LIMIT 1;

-- Modification de la table emplacement en liant avec un entrepot 
ALTER TABLE emplacement ADD COLUMN IF NOT EXISTS ID_ENTREPOT int;
UPDATE emplacement SET ID_ENTREPOT = (SELECT id_entrepot FROM entrepot LIMIT 1);

-- Modification de la table detail_commande en liant avec un entrepot 
ALTER TABLE detail_commande ADD COLUMN IF NOT EXISTS ID_ENTREPOT int;
UPDATE detail_commande SET ID_ENTREPOT = (SELECT id_entrepot FROM entrepot LIMIT 1);

-- Modification de la table detail_livr_f en liant avec un entrepot 
ALTER TABLE detail_livr_f ADD COLUMN IF NOT EXISTS ID_ENTREPOT int;
UPDATE detail_livr_f SET ID_ENTREPOT = (SELECT id_entrepot FROM entrepot LIMIT 1);

-- Liaison des données actuelles de la table emplacement
-- avec un entrepot
UPDATE emplacement SET ID_ENTREPOT = (SELECT id_entrepot FROM entrepot LIMIT 1);

-- Création de la table entrepot qui fait le lien entre
-- un produit, son emplacement et sa localisation
DROP TABLE IF EXISTS entrepot_stock;
CREATE TABLE `entrepot_stock` (
  `code_produit` varchar(8) NOT NULL,
  `no_emplacement` int(3) NOT NULL,
  `quantite_stock` int(4) NOT NULL,
  `date_stock` date NOT NULL,
  `seuil` int(4) NOT NULL,
  PRIMARY KEY (`code_produit`,`no_emplacement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Polutation de la table entrepot_stock avec les données actuelles
INSERT INTO entrepot_stock (code_produit, no_emplacement, quantite_stock, date_stock, seuil)  
SELECT code_produit, no_emplacement, quantite_stock, date_stock, 100 as seuil
FROM produit;

-- Ajout de la colonne seuil dans produit afin de déterminer
-- quand il y aura besoin de reapprovisionner un produit
ALTER TABLE produit ADD COLUMN IF NOT EXISTS SEUIL int(4) default 100;

-- Suppression des données en doublons apportées par la
-- modification du schéma sql
ALTER TABLE produit DROP IF EXISTS no_emplacement, DROP IF EXISTS quantite_stock, DROP IF EXISTS date_stock;