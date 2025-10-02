# Jokes Program - Exercise 03

## Description

Ce programme charge des blagues depuis un fichier externe et en affiche une au hasard.

## Utilisation

```bash
# Compilation
ocamlopt -o jokes jokes.ml

# Exécution avec fichier de blagues
./jokes programming_jokes.txt
./jokes blagues_fr.txt
```

## Format du fichier de blagues

### Règles simples :

- **Une blague par ligne**
- Lignes commençant par `#` = commentaires (ignorées)
- Lignes vides = ignorées
- Pas de limite de longueur

### Exemple :

```
# Mes blagues préférées
Pourquoi les programmeurs préfèrent l'hiver? Parce qu'il fait moins de bugs!

# Une autre section
Comment appelle-t-on un programmeur qui ne code que la nuit? Un vampire de code!
```

## Fichiers fournis

- `programming_jokes.txt` - Blagues en anglais sur la programmation
- `blagues_fr.txt` - Blagues en français sur l'informatique

## Ajouter vos propres blagues

1. Ouvrez un fichier de blagues dans votre éditeur
2. Ajoutez une nouvelle ligne avec votre blague
3. Sauvegardez et relancez le programme

## Fonctionnalités

- Chargement dynamique depuis n'importe quel fichier
- Statistiques du fichier (nombre de blagues, longueur moyenne)
- Sélection aléatoire
- Gestion d'erreurs robuste
- Interface utilisateur colorée

## Structure du code

- Lecture de fichier ligne par ligne
- Filtrage des commentaires et lignes vides
- Conversion en array pour accès aléatoire O(1)
- Gestion d'erreurs complète
