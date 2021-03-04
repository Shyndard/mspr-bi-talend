-- SGBD PostgreSQL

-- Création d'une table 'site' représentant les entrepots stockants les produits
DROP TABLE IF EXISTS site;
CREATE TABLE site (
	id_site varchar(10) primary key,
	numero_rue varchar(10),
	rue varchar(150),
	code_postal varchar(5),
	ville varchar(50)
);
COMMENT ON TABLE site IS 'Représentation des entrepots';

-- Création d'une table 'produit'
DROP TABLE IF EXISTS produit;
CREATE TABLE produit(
	id_produit varchar(10) primary key,
	id_categorie varchar(3),
	nom_categorie varchar(50),
	description varchar(250),
	commentaire varchar(250),
	seuil smallint
);
COMMENT ON TABLE produit IS 'Représentation des produits';

-- Création d'une table 'temps'
DROP TABLE IF EXISTS temps;
CREATE TABLE temps(
	id_temps serial primary key,
	annee smallint,
	mois smallint,
	jour smallint
);
COMMENT ON TABLE temps IS 'Représentation du temps entre 2000 et 2099 avec une précision au jour';

-- Création d'une table 'client'
DROP TABLE IF EXISTS client;
CREATE TABLE client(
	id_client varchar(10) primary key,
	nom varchar(50),
	numero_rue varchar(10),
	rue varchar(150),
	code_postal varchar(5),
	ville varchar(50),
	telephone varchar(13),
	email varchar(50),
	contact varchar(50)
);
COMMENT ON TABLE client IS 'Représentation des clients';

-- Création d'une table 'fournisseur'
DROP TABLE IF EXISTS fournisseur;
CREATE TABLE fournisseur(
	id_fournisseur varchar(10) primary key,
	nom varchar(50),
	numero_rue varchar(10),
	rue varchar(150),
	code_postal varchar(5),
	ville varchar(50),
	telephone varchar(13),
	email varchar(50)
);
COMMENT ON TABLE fournisseur IS 'Représentation des fournisseurs de produit';

-- Création d'une table 'achat'
DROP TABLE IF EXISTS achat;
CREATE TABLE achat(
	id_site varchar(10),
	id_temps integer,
	id_produit varchar(10),
	id_fournisseur varchar(10),
	quantite integer,
	prix_achat float,
	CONSTRAINT pk_achat PRIMARY KEY (id_site, id_temps, id_produit, id_fournisseur)
);
COMMENT ON TABLE achat IS 'Représentation des achats en fonction du site, du temps, du produit et des fournisseurs';

-- Création d'une table 'vente'
DROP TABLE IF EXISTS vente;
CREATE TABLE vente(
	id_site varchar(10),
	id_temps integer,
	id_produit varchar(10),
	id_client varchar(10),
	quantite integer,
	prix_vente float,
	CONSTRAINT pk_vente PRIMARY KEY (id_site, id_temps, id_produit, id_client)
);
COMMENT ON TABLE vente IS 'Représentation des ventes en fonction du site, du temps, du produit et des clients';

-- Génération des données pour la table 'temps' entre le 1er janvier 2000 et le 31 décembre 2099
do $$
declare
   nyear integer := 2000;
   nmonth integer := 1;
   nday integer := 0 ; 
begin
	loop 
		exit when nyear = 2100 ; 
		nmonth = 1;
		loop 
			exit when nmonth = 13 ;
				nday = 1;
				loop 
					exit when nday = 32 ;
						INSERT INTO temps (annee, mois, jour) values (nyear, nmonth, nday);
						nday := nday + 1 ;
				end loop;
				nmonth := nmonth + 1 ; 
		end loop;
		nyear := nyear + 1 ; 
	end loop; 
end; $$