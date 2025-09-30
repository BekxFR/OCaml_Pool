(* ========================================================================== *)
(*                   EXPLICATION DÉTAILLÉE DE L'EXERCICE 03 - DECK          *)
(* ========================================================================== *)

(* 
   Ce fichier explique en détail les concepts et techniques utilisés dans
   l'exercice 03 concernant l'implémentation du module Deck en OCaml.
*)

(* ========================================================================== *)
(* 1. INTERFACES ET FICHIERS .mli *)
(* ========================================================================== *)

(*
   NOUVEAUTÉ : FICHIER DECK.MLI
   
   L'exercice 03 introduit le concept d'interface explicite avec le fichier .mli.
   C'est la première fois dans cette série d'exercices qu'on doit créer
   une interface séparée de l'implémentation.
   
   RÔLE DU FICHIER .MLI :
   
   1. CONTRAT : Définit ce que le module expose publiquement
   2. ABSTRACTION : Cache les détails d'implémentation
   3. DOCUMENTATION : Sert de documentation pour les utilisateurs du module
   4. COMPILATION : OCaml vérifie que l'implémentation respecte l'interface
   
   DIFFÉRENCE AVEC LES EXERCICES PRÉCÉDENTS :
   
   Ex01-02 : Pas d'interface explicite, tout est exposé
   Ex03    : Interface explicite, contrôle précis de l'exposition
*)

(*
   STRUCTURE D'UNE INTERFACE :
   
   • Types abstraits : type t (sans définition)
   • Types concrets : type t = Spade | Heart | ...
   • Signatures de fonctions : val newDeck : unit -> t
   • Modules intégrés : module Card : sig ... end
   
   EXEMPLE DANS DECK.MLI :
   
   type t                           (* Type abstrait *)
   val newDeck : unit -> t          (* Fonction publique *)
   val drawCard : t -> Card.t * t   (* Fonction publique *)
   
   L'utilisateur ne peut pas savoir que t = Card.t list
*)

(* ========================================================================== *)
(* 2. MODULE INTÉGRÉ ET RÉUTILISATION *)
(* ========================================================================== *)

(*
   INTÉGRATION DU MODULE CARD :
   
   L'exercice demande d'intégrer le module Card de l'ex02 dans le module Deck.
   Cela illustre la composition de modules en OCaml.
   
   TROIS APPROCHES POSSIBLES :
   
   1. COPIE COMPLÈTE (notre choix) :
   module Card = struct
     (* tout le code de Card copié *)
   end
   
   Avantages :
   - Autonomie complète du module Deck
   - Pas de dépendance externe
   - Conforme à la demande du sujet
   
   2. INCLUSION PAR RÉFÉRENCE :
   module Card = Card_from_ex02
   
   Problème : Nécessite que Card_from_ex02 soit compilé séparément
   
   3. OPEN ET UTILISATION DIRECTE :
   open Card_from_ex02
   
   Problème : Ne respecte pas la demande d'intégration
*)

(*
   HIÉRARCHIE DES MODULES RÉSULTANTE :
   
   Deck
   ├── Card
   │   ├── Color
   │   │   ├── type t
   │   │   ├── all
   │   │   ├── toString
   │   │   └── toStringVerbose
   │   ├── Value
   │   │   ├── type t
   │   │   ├── all, toInt, toString, etc.
   │   │   ├── next, previous
   │   │   └── ...
   │   ├── type t
   │   ├── newCard, all, getValue, etc.
   │   └── compare, max, min, best, etc.
   ├── type t (deck)
   ├── newDeck
   ├── toStringList, toStringListVerbose
   └── drawCard
   
   ACCÈS HIÉRARCHIQUE :
   Deck.Card.Color.Spade
   Deck.Card.Value.As
   Deck.Card.toString
   Deck.newDeck
*)

(* ========================================================================== *)
(* 3. TYPE ABSTRAIT POUR LE DECK *)
(* ========================================================================== *)

(*
   CHOIX D'IMPLÉMENTATION : type t = Card.t list
   
   Le sujet indique que la définition du type t est libre.
   Nous avons choisi une liste de cartes pour sa simplicité.
   
   ALTERNATIVES POSSIBLES :
   
   Option 1: Liste simple (notre choix)
   type t = Card.t list
   
   Avantages:
   - Simple à implémenter
   - Ordre naturel des cartes
   - Pattern matching facile
   - Fonctions List disponibles
   
   Inconvénients:
   - Accès séquentiel seulement
   - Pas d'accès aléatoire efficace
   
   Option 2: Array
   type t = Card.t array
   
   Avantages:
   - Accès aléatoire O(1)
   - Mélange plus efficace
   - Modification sur place
   
   Inconvénients:
   - Plus complexe à manipuler
   - Taille fixe
   - Pas de pattern matching naturel
   
   Option 3: Record avec métadonnées
   type t = { cards: Card.t list; size: int; shuffled: bool }
   
   Avantages:
   - Informations supplémentaires
   - Optimisations possibles
   
   Inconvénients:
   - Plus complexe
   - Maintenance de la cohérence
*)

(*
   ABSTRACTION ET ENCAPSULATION :
   
   En déclarant seulement "type t" dans le .mli, on cache l'implémentation.
   L'utilisateur ne peut pas :
   - Créer directement un deck avec [card1; card2; ...]
   - Utiliser :: ou @ sur un deck
   - Pattern matcher directement sur la liste
   
   Il doit utiliser les fonctions fournies :
   - newDeck() pour créer
   - drawCard pour extraire
   - toStringList pour inspecter
   
   Cela garantit l'intégrité des données et permet de changer
   l'implémentation sans casser le code client.
*)

(* ========================================================================== *)
(* 4. MODULE RANDOM ET MÉLANGE DE CARTES *)
(* ========================================================================== *)

(*
   NOUVEAUTÉ : MODULE RANDOM
   
   L'exercice 03 ajoute le module Random aux fonctions autorisées.
   Cela permet d'implémenter l'exigence d'ordre aléatoire des cartes.
   
   FONCTIONS RANDOM UTILISÉES :
   
   - Random.int n : Retourne un entier entre 0 et n-1
   - Random.self_init() : Initialise avec une graine aléatoire (horloge système)
   
   SANS Random.self_init(), le générateur produit toujours la même séquence !
*)

(*
   ALGORITHME DE MÉLANGE : FISHER-YATES
   
   let shuffle lst =
     let arr = Array.of_list lst in
     let n = Array.length arr in
     for i = n - 1 downto 1 do
       let j = Random.int (i + 1) in
       let temp = arr.(i) in
       arr.(i) <- arr.(j);
       arr.(j) <- temp
     done;
     Array.to_list arr
   
   FONCTIONNEMENT :
   
   1. Convertir la liste en tableau (accès aléatoire efficace)
   2. Pour chaque position i de la fin vers le début :
      a. Choisir un index j aléatoire entre 0 et i
      b. Échanger arr[i] et arr[j]
   3. Reconvertir en liste
   
   EXEMPLE AVEC [A, B, C, D] :
   
   Étape 1: i=3, j=random(0,3)=1 → [A, D, C, B]
   Étape 2: i=2, j=random(0,2)=0 → [C, D, A, B]  
   Étape 3: i=1, j=random(0,1)=1 → [C, D, A, B]
   
   Résultat : [C, D, A, B]
   
   PROPRIÉTÉS DE L'ALGORITHME :
   - Complexité : O(n)
   - Uniforme : Chaque permutation a la même probabilité
   - Sur place : Modifie le tableau directement
   - Optimal : Minimum d'opérations nécessaires
*)

(*
   ALTERNATIVES DE MÉLANGE (moins efficaces) :
   
   Tri aléatoire (MAUVAISE IDÉE) :
   let shuffle lst = 
     List.sort (fun _ _ -> Random.int 3 - 1) lst
   
   Problème : Ne produit pas une distribution uniforme
   
   Insertion aléatoire récursive :
   let rec shuffle = function
     | [] -> []
     | h :: t -> insert_random h (shuffle t)
   
   Problème : Complexité O(n²) et distribution non uniforme
*)

(* ========================================================================== *)
(* 5. GESTION D'EXCEPTIONS AVEC RAISE *)
(* ========================================================================== *)

(*
   NOUVEAUTÉ : FONCTION RAISE
   
   L'exercice ajoute "raise" aux fonctions autorisées.
   Différence avec invalid_arg des exercices précédents :
   
   invalid_arg : Fonction qui lève Invalid_argument
   raise : Fonction générale pour lever n'importe quelle exception
   
   DANS NOTRE CODE :
   
   let drawCard = function
     | [] -> raise (Failure "Cannot draw from empty deck")
     | h :: t -> (h, t)
   
   raise (Failure "message") ≡ failwith "message"
   
   MAIS on utilise raise pour être explicite sur le type d'exception.
*)

(*
   TYPES D'EXCEPTIONS STANDARDS :
   
   - Failure : Erreur générale avec message
   - Invalid_argument : Argument invalide (ex01-02)
   - Not_found : Élément non trouvé
   - Division_by_zero : Division par zéro
   - Stack_overflow : Débordement de pile
   - Out_of_memory : Mémoire insuffisante
   
   CRÉATION D'EXCEPTIONS PERSONNALISÉES :
   
   exception EmptyDeck
   exception InvalidCard of string
   
   let drawCard = function
     | [] -> raise EmptyDeck
     | h :: t -> (h, t)
   
   Dans notre cas, Failure est suffisant et plus standard.
*)

(*
   GESTION D'EXCEPTIONS DANS LES TESTS :
   
   (try
     let _ = Deck.drawCard empty_deck in
     print_endline "ERREUR: drawCard sur deck vide n'a pas levé d'exception"
   with
   | Failure msg -> Printf.printf "OK: drawCard sur deck vide -> %s\n" msg);
   
   STRUCTURE TRY-WITH :
   
   try
     (* code qui peut lever une exception *)
   with
   | Pattern1 -> (* gestion du cas 1 *)
   | Pattern2 -> (* gestion du cas 2 *)
   | _ -> (* gestion de tous les autres cas *)
*)

(* ========================================================================== *)
(* 6. FONCTIONS DE CONVERSION ET MAPPING *)
(* ========================================================================== *)

(*
   FONCTIONS DE CONVERSION DU DECK :
   
   val toStringList : t -> string list
   val toStringListVerbose : t -> string list
   
   IMPLÉMENTATION :
   
   let toStringList deck = List.map Card.toString deck
   let toStringListVerbose deck = List.map Card.toStringVerbose deck
   
   CES FONCTIONS ILLUSTRENT :
   
   1. COMPOSITION FONCTIONNELLE :
      On réutilise Card.toString sur chaque élément
   
   2. TRANSFORMATION DE TYPES :
      t (deck) → string list
   
   3. LIST.MAP :
      Applique une fonction à chaque élément d'une liste
   
   ÉQUIVALENT RÉCURSIF DE LIST.MAP :
   
   let rec map f = function
     | [] -> []
     | h :: t -> (f h) :: (map f t)
   
   map Card.toString [card1; card2; card3]
   = [Card.toString card1; Card.toString card2; Card.toString card3]
   = ["AS"; "7D"; "JC"]
*)

(*
   AVANTAGES DES FONCTIONS DE CONVERSION :
   
   1. ABSTRACTION : L'utilisateur n'accède pas directement à la liste
   2. FLEXIBILITÉ : Peut changer l'implémentation interne du deck
   3. SÛRETÉ : Impossible de modifier le deck par accident
   4. CLARTÉ : Intent explicite de conversion
   
   ALTERNATIVE SANS ABSTRACTION :
   
   Si le type était exposé comme Card.t list, l'utilisateur pourrait :
   
   List.map Card.toString my_deck
   
   Mais cela casse l'encapsulation et lie l'utilisateur à l'implémentation.
*)

(* ========================================================================== *)
(* 7. FONCTION DRAWCARD ET PATTERN MATCHING *)
(* ========================================================================== *)

(*
   FONCTION DRAWCARD :
   
   val drawCard : t -> Card.t * t
   
   Cette fonction illustre plusieurs concepts OCaml importants :
   
   1. TYPES PRODUITS (TUPLES) :
      Card.t * t signifie "une paire de (carte, deck)"
   
   2. PATTERN MATCHING SUR LES LISTES :
      function
      | [] -> (* cas liste vide *)
      | h :: t -> (* cas liste non vide : tête h, queue t *)
   
   3. GESTION D'ERREUR :
      Exception Failure pour le cas d'erreur
   
   4. IMMUTABILITÉ :
      On ne modifie pas le deck original, on retourne un nouveau deck
*)

(*
   USAGE TYPIQUE DE DRAWCARD :
   
   let deck = Deck.newDeck () in
   let (first_card, remaining_deck) = Deck.drawCard deck in
   let (second_card, final_deck) = Deck.drawCard remaining_deck in
   
   CHAÎNAGE D'OPÉRATIONS :
   
   deck                    (* 52 cartes *)
   ↓ drawCard
   (card1, deck1)         (* 51 cartes *)
   ↓ drawCard sur deck1
   (card2, deck2)         (* 50 cartes *)
   
   IMMUTABILITÉ GARANTIE :
   - deck contient toujours 52 cartes
   - deck1 contient toujours 51 cartes  
   - deck2 contient toujours 50 cartes
   
   Aucune modification destructive !
*)

(*
   ALTERNATIVES D'IMPLÉMENTATION :
   
   Version avec option (plus fonctionnelle) :
   val drawCard : t -> (Card.t * t) option
   
   let drawCard = function
     | [] -> None
     | h :: t -> Some (h, t)
   
   Avantage : Pas d'exception, gestion explicite des cas
   Inconvénient : Plus verbeux à utiliser
   
   Version avec référence (style impératif) :
   val drawCard : t ref -> Card.t
   
   Problème : Modifie le deck original, pas fonctionnel
*)

(* ========================================================================== *)
(* 8. TESTS ET VALIDATION *)
(* ========================================================================== *)

(*
   STRATÉGIE DE TESTS DANS MAIN.ML :
   
   1. TEST DE CRÉATION :
      - Vérifier que newDeck() crée 52 cartes
      - Vérifier que deux appels donnent des ordres différents
   
   2. TEST DE CONVERSION :
      - Vérifier toStringList et toStringListVerbose
      - Comparer les formats de sortie
   
   3. TEST DE TIRAGE :
      - Tirer plusieurs cartes successives
      - Vérifier la diminution de la taille du deck
   
   4. TEST DE CAS LIMITE :
      - Deck vide → Exception
      - Épuisement complet du deck
   
   5. TEST D'INTÉGRATION :
      - Modules Card.Color, Card.Value accessibles
      - Fonctions Card utilisables
*)

(*
   TECHNIQUES DE TEST AVANCÉES :
   
   TEST D'ALÉATOIRE :
   let different = list1 <> list2 in
   Printf.printf "Les deux decks ont un ordre différent: %b\n" different;
   
   Problème : Test non déterministe (peut échouer par hasard)
   Solution : Répéter le test ou utiliser une graine fixe pour debug
   
   TEST D'ÉPUISEMENT :
   let rec draw_all_cards deck count = ...
   
   Validation complète du comportement sur 52 cartes
   
   TEST D'EXCEPTION :
   (try ... with | Failure msg -> ...)
   
   Vérification explicite des cas d'erreur
*)

(* ========================================================================== *)
(* 9. BONNES PRATIQUES ILLUSTRÉES *)
(* ========================================================================== *)

(*
   SÉPARATION INTERFACE/IMPLÉMENTATION :
   
   .mli : Ce que l'utilisateur voit (contrat)
   .ml  : Comment c'est implémenté (détails)
   
   Permet l'évolution interne sans casser le code client.
   
   COMPOSITION DE MODULES :
   
   Réutiliser le module Card au lieu de le réécrire.
   Hiérarchie claire : Deck contient Card.
   
   IMMUTABILITÉ :
   
   Aucune fonction ne modifie ses arguments.
   Toujours retourner de nouvelles valeurs.
   
   GESTION D'ERREUR EXPLICITE :
   
   Exceptions pour les cas exceptionnels.
   Messages d'erreur informatifs.
   
   ABSTRACTION :
   
   Type deck abstrait.
   Fonctions d'accès contrôlées.
   
   TESTS COMPLETS :
   
   Cas normaux, cas limites, cas d'erreur.
   Validation de tous les comportements spécifiés.
*)

(* ========================================================================== *)
(* CONCLUSION *)
(* ========================================================================== *)

(*
   L'exercice 03 introduit des concepts OCaml avancés :
   
   1. INTERFACES EXPLICITES : Contrôle précis de l'exposition
   2. COMPOSITION DE MODULES : Réutilisation et hiérarchie
   3. TYPES ABSTRAITS : Encapsulation et évolutivité
   4. ALÉATOIRE : Module Random et algorithmes de mélange
   5. EXCEPTIONS CUSTOM : raise et gestion d'erreur
   6. TESTS AVANCÉS : Validation complète et cas limites
   
   Ces concepts préparent à la programmation OCaml à grande échelle
   où la modularité, l'abstraction et la robustesse sont essentielles.
*)
