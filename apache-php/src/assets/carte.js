Vue.createApp({
    data() {
        return {
            map: null,
            showHeatmap: false,
            heatmapLayer: null,

            objets: [],
            inventaire: [],

            // variable pour la sélection d'objet dans l'inventaire
            objetSelectionneInventaire: null, 

            // variable pour le modal classique
            modalVisible: false,
            modalTitre: '',
            modalMessage: '',

            // variable pour le modal destiné à l'objet bloqué par code
            modalCodeVisible: false,
            modalCodeTitre: '',      
            modalCodeIndice: '',     
            codeSaisi: '',           
            erreurCode: '',          
            objetBloqueActuel: null,

            // variable pour timer
            timer: "00:00",
            tempsEcoule: 0,
            score: 0,
            interval: null,

            // variable zone de drag & drop
            modalFinalVisible: false,
            objetEnDrag: null,
            objetsDeposes: [],
            slots: [null, null, null, null],

        }
    },
    methods: {
        initMap() {
            
            // carte centrée au début sur Paris
            this.map = L.map('map').setView([48.85, 2.35], 12);

            // fond de carte OpenStreetMap
            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; OpenStreetMap'
            }).addTo(this.map);

            // heatmap WMS
            this.heatmapLayer = L.tileLayer.wms('http://localhost:8080/geoserver/escapegame/wms', {
                layers: 'escapegame:objets',
                styles: 'heatmap',
                format: 'image/png',
                transparent: true,
                version: '1.1.0'
            });
        },
        
        // On voulait implémenter un code aléatoire à chaque nouvelle partie mais on n'a pas eu le temps 
        // genererCode() {
        //     // Génère un code à 4 chiffres aléatoire
        //     return Math.floor(1000 + Math.random() * 9000).toString();
        // },

        // gestion de l'affichage de la heatmap
        cocherHeatmap() {
            if (this.showHeatmap) {
                this.heatmapLayer.addTo(this.map);
            } else {
                this.map.removeLayer(this.heatmapLayer);
            }
        },

        // gestion modal des indices
        afficherModal(titre, message) {
            this.modalTitre = titre;
            this.modalMessage = message;
            this.modalVisible = true;
        },

        fermerModal() {
            this.modalVisible = false;
        },

        // gestion modal de l'objet code
        afficherModalCode(titre, indice, objet) {
            this.modalCodeTitre = titre;
            this.modalCodeIndice = indice;
            this.objetBloqueActuel = objet;
            this.codeSaisi = '';
            this.erreurCode = '';
            this.modalCodeVisible = true;
        },
        fermerModalCode() {
            this.modalCodeVisible = false;
        },

        // gestion modal final
        afficherModalFinal() {
            this.modalFinalVisible = true;
        },

        fermerModalFinal() {
            this.modalFinalVisible = false;
        },

        // validation du code saisi
        validerCode() {
            if (!this.objetBloqueActuel) return;

            const objetCode = this.inventaire.find(o => o.type_objet === 'code');

            // comparaison avec le code stocké dans la base
            if (this.codeSaisi !== objetCode.code_deverrouille) {
                this.erreurCode = "Pas le bon code, banane !";
                return;
            }

            // si code correct alors on débloque l'objet
            this.modalCodeVisible = false;

            // rajout dans inventaire
            if (!this.inventaire.includes(this.objetBloqueActuel)) {
                this.inventaire.push(this.objetBloqueActuel);
            }
            
            // enlève marker de la carte
            if (this.objetBloqueActuel.marker) {
                this.map.removeLayer(this.objetBloqueActuel.marker);
                this.objetBloqueActuel.marker.recupere = true;
            }

            // affiche indice suivant
            this.afficherModal(
                this.objetBloqueActuel.description,
                this.objetBloqueActuel.indice_suivant
            );

        },

        // sélection d'un objet dans l'inventaire pour débloquer l'objet bloqué
        utiliserObjetDepuisInventaire(obj) {
            this.objetSelectionneInventaire = obj;

            this.afficherModal(
                "Objet sélectionné : " + obj.nom,
                "Clique maintenant sur l'objet bloqué."
            );
        },

        // début du drag
        startDrag(obj, event) {
            event.dataTransfer.setData("text/plain", obj.id_objet); 
        },

        // drop dans les slots
        handleDrop(event, slotIndex) {
            const objId = event.dataTransfer.getData("text/plain");            
            const obj = this.inventaire.find(o => o.id_objet == objId); 

            if (obj.id_objet < 1 || obj.id_objet > 4) return;            
            if (this.slots.some(slot => slot && slot.id_objet == objId)) return;

            this.slots[slotIndex] = obj;
        },
        
        // validation des slots et envoi du score au serveur
        validerSlots() {
            const idsPlaces = this.slots
                .filter(s => s !== null)
                .map(s => s.id_objet)
                .sort();

            // vérifie que les 4 singes sont placés
            if (idsPlaces.length < 4) {
                this.afficherModal("Il manque des singes !", "Dépose les 4 singes.");
                return;
            }

            // calcule le score final et arrête le timer
            this.calculerScore();
            this.stopTimer();

            // données envoyées au serveur
            const donneesScore = {
                score: this.score,
                temps: this.tempsEcoule // Variable définie dans votre data()
            };

            // envoie au serveur avec fetch
            fetch('/api/score', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(donneesScore)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert("Bravo ! Score enregistré : " + this.score + " points.");
                    window.location.href = "/"; // retour à l'accueil (Hall of fame)
                } else {
                    alert("Erreur lors de la sauvegarde du score.");
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
            });
        },
        
        // chargement des objets depuis l'API 
        chargerObjets() {
            fetch('/api/objets')
            .then(r => r.json())
            .then(json => {
                this.objets = json;
                this.placerObjetsSurCarte();

                const objet1 = this.objets.find(o => o.id_objet == 1);
                if (objet1) {
                    this.afficherModal(objet1.indice_precedent, objet1.indice_propre);
                }
        
            });
        },

        // placement des objets sur la carte avec gestion du zoom
        placerObjetsSurCarte() {
            this.markers = [];

            this.objets.forEach(obj => {
                let icone = L.icon({
                    iconUrl: obj.icone,
                    iconSize: [80, 80]
                });

                let marker = L.marker([obj.lat, obj.lon], { icon: icone });
                marker.objet = obj;
                obj.marker = marker; 

                // gestion du clic sur le marker
                marker.on('click', () => this.gererClicObjet(marker));

                this.markers.push(marker);
            });

            // fonction pour mettre à jour l'affichage des markers selon le zoom
            const updateMarkers = () => {
                const zoomActuel = this.map.getZoom();

                this.markers.forEach(marker => {
                    const obj = marker.objet;
                    if (marker.recupere) return;
                    if (zoomActuel >= obj.niveau_zoom_min) {
                        if (!this.map.hasLayer(marker)) marker.addTo(this.map);
                    } else {
                        if (this.map.hasLayer(marker)) this.map.removeLayer(marker);
                    }
                });
            };

            updateMarkers();
            this.map.on('zoomend', updateMarkers);
        },

        // gestion du clic sur un objet
        gererClicObjet(marker) {
            const obj = marker.objet;

            if (obj.type_objet === 'recuperable') {
                if (!this.inventaire.includes(obj)) {
                    this.inventaire.push(obj);
                }

                this.map.removeLayer(marker);
                marker.recupere = true;
                
                this.afficherModal(obj.description, obj.indice_suivant);   
            }

            else if (obj.type_objet === 'code') {
                // récupération via l'API
                fetch('/api/objets/' + obj.id_objet)
                    .then(r => r.json())
                    .then(objetCode => {

                        if (!this.inventaire.includes(objetCode)) {
                            this.inventaire.push(objetCode);
                        }

                        this.map.removeLayer(marker);
                        marker.recupere = true;

                        const titre = `${objetCode.description} - Code : ${objetCode.code_deverrouille}`;
                        this.afficherModal(titre, objetCode.indice_suivant);
                    });
            }

            else if (obj.type_objet === 'bloque_code') {
                // récupération via l'API 
                fetch('/api/objets/' + obj.id_objet_precedent)
                    .then(r => r.json())
                    .then(objetCode => {

                        this.afficherModalCode(obj.nom, 'Code : ' + objetCode.code_deverrouille, obj);

                        this.objetCodeActuel = objetCode;
                    });
            }

            else if (obj.type_objet === 'bloque_objet') {

                const precedentRecupere = this.inventaire.find(o => o.id_objet === obj.id_objet_precedent);

                if (!precedentRecupere) {
                    // objet précédent non récupéré, on récupère ses infos via API pour affichage
                    fetch('/api/objets/' + obj.id_objet_precedent)
                        .then(r => r.json())
                        .then(objetPrecedent => {
                            this.afficherModal(
                                "Objet bloquant : " + objetPrecedent.nom,
                                "Indice associé : " + objetPrecedent.indice_propre
                            );
                        });
                    return;
                }

                // vérifie si l'objet inventaire est sélectionné
                if (!this.objetSelectionneInventaire) {
                    this.afficherModal(
                        "Objet bloqué",
                        "Sélectionne le bon objet débloquant dans ton inventaire."
                    );
                    return;
                }

                // vérifie si c’est le bon objet
                if (this.objetSelectionneInventaire.id_objet !== obj.id_objet_precedent) {
                    this.afficherModal(
                        "Mauvais objet",
                        "C'est pas le bon objet, banane ! Essaye un autre dans l'inventaire."
                    );
                    return;
                }

                // débloque l'objet
                this.inventaire.push(obj);
                this.map.removeLayer(marker);
                marker.recupere = true;

                this.afficherModal(obj.description, obj.indice_suivant);

                this.objetSelectionneInventaire = null;
            } 
            
            else if (obj.type_objet === 'final_objet') {
                this.afficherModalFinal();
            }   
            
            
        },

        // gestion du timer
        lancerTimer() {
        this.interval = setInterval(() => {
            this.tempsEcoule++;

            let minutes = String(Math.floor(this.tempsEcoule / 60)).padStart(2, '0');
            let secondes = String(this.tempsEcoule % 60).padStart(2, '0');

            this.timer = `${minutes}:${secondes}`;
        }, 1000);

        },
        stopTimer() {
            clearInterval(this.interval);
        },

        // méthode de calcul du score final
        calculerScore() {
            this.score = Math.max(0, 5000 - (this.tempsEcoule * 10));
        },

    },

    mounted() {
        this.initMap();
        this.chargerObjets();
        this.lancerTimer();
    },

}).mount('#app');
