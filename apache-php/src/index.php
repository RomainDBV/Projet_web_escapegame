<?php

declare(strict_types=1);

session_start();

require_once 'flight/Flight.php';
require_once 'config.php';

// Stocke la connexion dans Flight
Flight::set('connexion', $link);


// API : tous les objets présents dans la table objets
Flight::route('GET /api/objets', function() {
    $db = Flight::get('connexion');
    $sql = "SELECT id_objet, nom, description, type_objet, code_deverrouille, id_objet_precedent,
                   indice_precedent, indice_propre, indice_suivant, niveau_zoom_min, icone,
                   ST_X(geom) AS lon, ST_Y(geom) AS lat
            FROM objets
            WHERE visible = true";

    $result = pg_query($db, $sql);
    $rows = pg_fetch_all($result);
    Flight::json($rows);
});

// API : objet précis avec id_objet
Flight::route('GET /api/objets/@id', function($id) {
    $db = Flight::get('connexion');
    $sql = "SELECT id_objet, nom, description, type_objet, code_deverrouille, id_objet_precedent,
                   indice_precedent, indice_propre, indice_suivant, niveau_zoom_min, icone,
                   ST_X(geom) AS lon, ST_Y(geom) AS lat
            FROM objets
            WHERE id_objet = $1";

    $result = pg_query_params($db, $sql, [$id]);
    $row = pg_fetch_assoc($result);
    Flight::json($row);
});


// Route accueil
Flight::route('/', function() {
    $db = Flight::get('connexion');
    
    // Requête SQL pour les 10 meilleurs scores
    $sql = "SELECT j.pseudo, s.temps_total, s.score_total, 
                   to_char(s.date_partie, 'DD/MM/YYYY HH24:MI') as date_fmt
            FROM scores s
            JOIN joueurs j ON s.id_joueur = j.id_joueur
            ORDER BY s.score_total DESC
            LIMIT 10";

    $result = pg_query($db, $sql);
    $scores = [];
    if ($result) {
        while ($row = pg_fetch_assoc($result)) {
            $scores[] = $row;
        }
    }

    Flight::render('accueil', ['scores' => $scores]);
});


// Route carte
Flight::route('POST /carte', function() {
    $db = Flight::get('connexion'); 
    $pseudo = $_POST['pseudo'];

    // Validation du pseudo : seules les lettres (a-zA-Z), chiffres (0-9), underscore (_) et tiret (-) sont autorisés
    if (!preg_match('/^[a-zA-Z0-9_-]+$/', $pseudo)) {
        Flight::render('accueil', ['error' => 'Pseudo invalide : seules les lettres, chiffres, _ et - sont autorisés']);
        return;
    }

    // Vérifie si le joueur existe déjà dans la base
    $sql = "SELECT id_joueur FROM joueurs WHERE pseudo = $1";
    $result = pg_query_params($db, $sql, [$pseudo]);
    $row = pg_fetch_assoc($result);

    if ($row) {
        // Si le joueur existe, on récupère son ID
        $id_joueur = $row['id_joueur'];
    } else {
        // Sinon, on insère le nouveau joueur dans la base et on récupère direct son ID
        $sql = "INSERT INTO joueurs (pseudo) VALUES ($1) RETURNING id_joueur";
        $result = pg_query_params($db, $sql, [$pseudo]);
        $row = pg_fetch_assoc($result);
        $id_joueur = $row['id_joueur'];
    }

    $_SESSION['id_joueur'] = $id_joueur;
    $_SESSION['pseudo'] = $pseudo;

    Flight::render('carte');
});


// API : sauvegarde du score
Flight::route('POST /api/score', function(){
    $db = Flight::get('connexion');
    $data = Flight::request()->data; // on récupère le JSON contenant le score et le timer envoyé par carte.js

    $id_joueur = $_SESSION['id_joueur'];
    $score = $data->score;
    $temps = $data->temps; 
    $nb_objets = 4; // 4 objets = 4 singes

    $sql = "INSERT INTO scores (id_joueur, temps_total, objets_trouves, score_total) 
            VALUES ($1, $2, $3, $4)";
            
    $result = pg_query_params($db, $sql, array($id_joueur, $temps, $nb_objets, $score));

    Flight::json(['success' => true]);

});

Flight::start();

