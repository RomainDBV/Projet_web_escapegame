# Les 4 singes se sont échappés du zoo, ils sont éparpillés dans toute la France, heureusement ils ont laissé des indices pour se faire attraper ! Retrouve-les et ramène-les chez eux. tu auras une récompense juteuse!

Escape game géographique où il faut trouver 5 objets éparpillés dans le monde grâce à des indices, certains seront bloqués par un code ou un objet spécial à sélectionner.

Projet réalisé par Romain De Bloteau-Val'Chuk et Gabriel Pires-Prata dans le cadre du projet de développment web de 2ème année du cycle ingénieur de l'Ecole Nationale des Sciences Géographiques.


## Consignes d'installation
Après avoir cloné le repo et installé Docker, éxecuter `docker compose up -d` à la racine du projet.

### Apache+PHP+Flight

- basé sur `./apache-php/Dockerfile`
- fichiers sources dans `./apache-php/src`
- http://localhost:1234 (site web de l'escape game, vous devez mettre cette adresse URL dans votre navigateur)

### Postgres+PostGIS

- user: `postgres`, pass: `postgres`, base: `mydb`, port: `5432`
- exécute `./db/backup.sql` (au cas ou, le code de création de table est aussi disponible sous le nom de bdd.sql, fichier texte)

### pgadmin

- user: `admin@admin.com`, pass: `admin`
- permet de se connecter à postgres si besoin (host `db`, port `5432`, user/pass, sans SSL)
- http://localhost:5050 (création de BDD avec backup.sql ou bdd.sql)

### GeoServer

- user: `admin`, pass: `geoserver`
- http://localhost:8080/geoserver (création de la heatmap)


