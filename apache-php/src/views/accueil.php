<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monkey Business - Accueil</title>
    <link href="https://fonts.googleapis.com/css2?family=Averia+Serif+Libre:wght@400;700&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/accueil.css">
</head>
<body>
    <div class="container">
        <h1 class="titre">Monkey Business 🍌</h1>

        <!-- affichage de l'erreur lié au mauvais pseudo -->
        <?php if (isset($error)) : ?>
            <p class="error"><?= $error ?></p>
        <?php endif; ?>

        <form action="/carte" method="post" class="form-pseudo">
            <input type="text" id="pseudo" name="pseudo" placeholder="Votre pseudo">
            <button type="submit" class="btn-primary">Commencer la partie</button>
        </form>
    </div>
    
    <div class="container">
        <h1 class="titre">Scoreboard 🏆</h1>
        
        <!-- Hall of Fame -->
        <ul class="scoreboard"> 
            <?php
                $rank = 1;

                if (!empty($scores)) {
                    foreach ($scores as $row) {

                        $prefix = $rank . ". ";
                        if ($rank == 1) $prefix = "🥇 ";
                        if ($rank == 2) $prefix = "🥈 ";
                        if ($rank == 3) $prefix = "🥉 ";

                        echo "<li>" 
                            . $prefix 
                            . "<strong>" . htmlspecialchars($row['pseudo']) . "</strong> : " 
                            . htmlspecialchars($row['score_total']) . " pts "
                            . "<small>(" . gmdate("i:s", (int)$row['temps_total']) . " min)</small>"
                            . "</li>";

                        $rank++;
                    }
                } else {
                    echo "<li>Aucun score enregistré pour le moment.</li>";
                }
            ?>
        </ul>
    </div>
</body>
</html>
