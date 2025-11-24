# Solutions claires des énigmes (position et ordre des objets à trouver)

## Ordre de déblocage des objets

- Le jeu comporte 5 objets dont les 4 premiers sont obligatoires pour débloquer l’objet final.
- Un indice est donné pour l'objet suivant quand on récupère un objet dans l'ordre donné ci-dessus.
- Les objets 1 et 2 peuvent être récupérés indépendamment mais les indices amènent en premier à l'objet 1 puis à l'objet 2.

| Ordre |  Nom               | Type             | Débloqué par…     |
| ----- |  ----------------- | ---------------- | ----------------- |
| 1     |  Singe vietnamien  | récupérable      | -                 |
| 2     |  Singe normand     | code             | -                 |
| 3     |  Singe portugais   | bloqué par code  | Code de l'objet 2 |
| 4     |  Singe ukrainien   | bloqué par objet | Objet 3           |
| 5     |  Objet final (Zoo) | objet final      | Objets 1,2,3,4    |


## Positions et ordres des objets sur la carte

Les coordonnées sont exprimées dans le SRS  : EPSG:4326 (latitude, longitude).

### Objet 1 — Singe vietnamien

- Lieu : Senlis
- Coordonnées : 49.2066, 2.5845 
- Zoom minimum : 13
- ATTENTION : Cliquer sur l'Objet 1 pour le récupérer dans l'inventaire


### Objet 2 - Singe normand

- Lieu : Agen
- Coordonnées : 44.2028, 0.6174
- Zoom minimum : 15
- Code donné pour débloquer l'Objet 3 : 76470
- Objet ayant le code débloquant l'Objet 5
- ATTENTION : Cliquer sur l'Objet 2 pour afficher le code et le récupérer dans l'inventaire 


### Objet 3 - Singe portugais

- Lieu : Rumilly
- Coordonnées : 45.8672, 5.943
- Zoom minimum : 15
- Code nécessaire pour débloquer l'objet : 76470
- Ainsi il est nécessaire de trouver l'Objet 2 pour débloquer le code afin de débloquer l'Objet 3
- Objet débloquant l'Objet 4
- ATTENTION : Cliquer sur l'Objet 3 puis Renseigner le code de l'Objet 2 dans le formulaire puis Valider pour le récupérer dans l'inventaire 


### Objet 4 - Singe ukrainien

- Lieu : Fontenay-le-Fleury
- Coordonnées : 48.8112, 2.046
- Zoom minimum : 15
- Objet nécessaire pour débloquer l'objet : Objet 3
- Ainsi il est nécessaire de trouver l'Objet 3 pour débloquer l'Objet 4
- ATTENTION : Cliquer sur l'Objet 3 dans l'inventaire puis Cliquer sur l'Objet 4 pour le récupérer dans l'inventaire 


### Objet 5 - Banane 

- Lieu : Zoo d’Amiens
- Coordonnées : 49.9004, 2.277
- Zoom min : 16
- Objets nécessaires pour débloquer l'objet : Objet 1, Objet 2, Objet 3, Objet 4
- Ainsi il est nécessaire de trouver tous les objets précédents (Objet 1, Objet 2, Objet 3, Objet 4) pour débloquer l'Objet 5 (objet final)
- ATTENTION : Cliquer sur l'Objet 5 (un modal de drag and drop s'ouvre), DragDroper chaque objet dans un slot puis Valider








