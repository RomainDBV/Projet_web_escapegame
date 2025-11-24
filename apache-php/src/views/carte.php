<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monkey Business</title>
    <link href="https://fonts.googleapis.com/css2?family=Averia+Serif+Libre:wght@400;700&family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <link rel="stylesheet" href="assets/carte.css">

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

</head>
<body>
    <div id="app">

        <div class="game-container">

            <!-- Zone inventaire -->
            <div id="inventaire">
                <h2>Inventaire</h2>
                <ul id="liste-inventaire">
                    <li 
                        v-for="obj in inventaire" 
                        :key="obj.id_objet" 
                        draggable="true" 
                        @dragstart="startDrag(obj, $event)"
                        :class="{ selected: objetSelectionneInventaire && objetSelectionneInventaire.id_objet === obj.id_objet }"
                        @click="utiliserObjetDepuisInventaire(obj)">

                    <img :src="obj.icone" :alt="obj.nom" class="icone-inventaire">   
            </div>

            <!-- Zone carte -->
            <div id="map-container">              
                <div id="timer">{{ timer }}</div>
                
                <!-- Heatmap -->
                <div class="heat-button">
                    <label>
                        <input type="checkbox" v-model="showHeatmap" @change="cocherHeatmap">
                        Tricher (afficher la Heatmap)
                    </label>
                </div>

                <div id="map"></div>
            </div>

        </div>


         <!-- Modal pour les indices -->
        <div v-if="modalVisible" class="modal-overlay" @click="fermerModal">
            <div class="modal-content" @click.stop>

                <h3>{{ modalTitre }}</h3> 
                <p>{{ modalMessage }}</p>

                <button @click="fermerModal">OK</button>
            </div>
        </div>


        <!-- Modal pour les objets bloqués par code -->
        <div v-if="modalCodeVisible" class="modal-overlay" @click="fermerModalCode">
            <div class="modal-content" @click.stop>

                <h3>{{ modalCodeTitre }}</h3>
                <p>{{ modalCodeIndice }}</p>

                <!-- Formulaire -->
                <form @submit.prevent="validerCode" class="code-form">
                    <input 
                        v-model="codeSaisi" 
                        placeholder="Entrez le code"
                        class="input-code"
                    >

                    <button type="submit" class="btn-primary">Valider</button>
                    <button type="button" class="btn-secondary" @click="fermerModalCode">
                        Annuler
                    </button>
                </form>

                <p v-if="erreurCode" class="erreur">{{ erreurCode }}</p>
            </div>
        </div>


        <!-- Modal pour la fin de partie --> 
        <div v-if="modalFinalVisible" id="final-zone" class="final-zone">
            <span class="croix-fermeture" @click="fermerModalFinal">&times;</span>
            
            <h3>Déposez les 4 singes dans les cases</h3>

            <div class="slots-container">
                <div class="drop-slot" v-for="(slot, index) in slots" :key="index" @dragover.prevent @drop.prevent="handleDrop($event, index)">
                    <img v-if="slot" :src="slot.icone" :alt="slot.nom" class="slot-img">
                </div>
            </div>

            <button class="btn-valider" @click="validerSlots">Valider</button>
        </div>

    </div>

    
    <script src="https://cdn.jsdelivr.net/npm/vue"></script>
    <script src="assets/carte.js"></script>
</body>
</html>
