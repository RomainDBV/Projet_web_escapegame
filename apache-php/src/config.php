<?php
$host = 'db';
$port = 5432;
$dbname = 'mydb';
$user = 'postgres';
$pass = 'postgres';

$link = pg_connect("host=$host port=$port dbname=$dbname user=$user password=$pass");

if (!$link) {
    die("Erreur de connexion à la base de données");
}
?>

