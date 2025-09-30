(* ========================================================================== *)
(*           EXPLICATION DU MÉLANGE FONCTIONNEL (SANS BOUCLES)              *)
(* ========================================================================== *)

(*
   PROBLÈME : L'algorithme de Fisher-Yates classique utilise des boucles for
   et des modifications destructives d'un tableau, ce qui est interdit dans
   les exercices OCaml de l'école 42.
   
   RÈGLES À RESPECTER :
   - Pas de boucles for/while
   - Pas de structures mutables (ref, array avec modifications)
   - Programmation fonctionnelle pure
   - Utilisation uniquement du module Random et des fonctions des ex précédents
*)

(* ========================================================================== *)
(* ALGORITHME FONCTIONNEL DE MÉLANGE *)
(* ========================================================================== *)

(*
   PRINCIPE : 
   Au lieu de modifier un tableau en place, on construit progressivement
   une nouvelle liste en choisissant aléatoirement des éléments de la liste
   restante.
   
   ALGORITHME :
   1. Commencer avec une liste vide (accumulateur) et la liste complète
   2. Tant qu'il reste des éléments :
      a. Choisir un index aléatoire dans la liste restante
      b. Extraire l'élément à cet index
      c. Ajouter l'élément à l'accumulateur
      d. Continuer avec la liste sans cet élément
   3. Retourner l'accumulateur
*)

(*
   IMPLÉMENTATION DÉTAILLÉE :
   
   let shuffle lst =
     let rec shuffle_aux acc remaining =
       match remaining with
       | [] -> acc                    (* Cas de base : plus d'éléments *)
       | _ ->
         let len = List.length remaining in
         let random_index = Random.int len in    (* Index aléatoire *)
         
         (* Séparer la liste en : avant_index + élément + après_index *)
         let rec split_at index lst acc_before =
           match lst with
           | [] -> (List.rev acc_before, [])     (* Ne devrait pas arriver *)
           | h :: t ->
             if index = 0 then
               (List.rev acc_before, h :: t)     (* On a trouvé l'index *)
             else
               split_at (index - 1) t (h :: acc_before)
         in
         
         let (before, after) = split_at random_index remaining [] in
         match after with
         | [] -> acc                   (* Ne devrait pas arriver *)
         | chosen :: rest ->
           (* Ajouter l'élément choisi à l'accumulateur *)
           (* Continuer avec before @ rest (sans l'élément choisi) *)
           shuffle_aux (chosen :: acc) (before @ rest)
     in
     shuffle_aux [] lst
*)

(* ========================================================================== *)
(* FONCTIONNEMENT ÉTAPE PAR ÉTAPE *)
(* ========================================================================== *)

(*
   EXEMPLE AVEC [A; B; C; D] :
   
   Étape 1:
   - acc = []
   - remaining = [A; B; C; D]
   - len = 4
   - random_index = Random.int 4 = 2 (par exemple)
   - split_at 2 [A; B; C; D] [] = ([A; B], [C; D])
   - chosen = C, rest = [D]
   - Récursion : shuffle_aux [C] ([A; B] @ [D]) = shuffle_aux [C] [A; B; D]
   
   Étape 2:
   - acc = [C]
   - remaining = [A; B; D]
   - len = 3
   - random_index = Random.int 3 = 0
   - split_at 0 [A; B; D] [] = ([], [A; B; D])
   - chosen = A, rest = [B; D]
   - Récursion : shuffle_aux [A; C] [B; D]
   
   Étape 3:
   - acc = [A; C]
   - remaining = [B; D]
   - len = 2
   - random_index = Random.int 2 = 1
   - split_at 1 [B; D] [] = ([B], [D])
   - chosen = D, rest = []
   - Récursion : shuffle_aux [D; A; C] [B]
   
   Étape 4:
   - acc = [D; A; C]
   - remaining = [B]
   - len = 1
   - random_index = Random.int 1 = 0
   - split_at 0 [B] [] = ([], [B])
   - chosen = B, rest = []
   - Récursion : shuffle_aux [B; D; A; C] []
   
   Étape 5:
   - acc = [B; D; A; C]
   - remaining = []
   - Retour : [B; D; A; C]
   
   Résultat : La liste originale [A; B; C; D] devient [B; D; A; C]
*)

(* ========================================================================== *)
(* FONCTION SPLIT_AT EXPLIQUÉE *)
(* ========================================================================== *)

(*
   La fonction split_at est cruciale pour l'algorithme :
   
   split_at : int -> 'a list -> 'a list -> ('a list * 'a list)
   
   split_at index lst acc_before = (avant, à_partir_de_index)
   
   EXEMPLE : split_at 2 [A; B; C; D; E] []
   
   Appel 1: index=2, lst=[A;B;C;D;E], acc_before=[]
   → index≠0, récursion : split_at 1 [B;C;D;E] [A]
   
   Appel 2: index=1, lst=[B;C;D;E], acc_before=[A]  
   → index≠0, récursion : split_at 0 [C;D;E] [B;A]
   
   Appel 3: index=0, lst=[C;D;E], acc_before=[B;A]
   → index=0, retour : (List.rev [B;A], [C;D;E]) = ([A;B], [C;D;E])
   
   Résultat : ([A; B], [C; D; E])
   
   Cela sépare la liste en deux parties : avant l'index 2 et à partir de l'index 2.
*)

(* ========================================================================== *)
(* COMPARAISON AVEC FISHER-YATES CLASSIQUE *)
(* ========================================================================== *)

(*
   FISHER-YATES CLASSIQUE (avec tableau) :
   
   for i = n-1 downto 1 do
     j = random(0, i)
     swap(arr[i], arr[j])
   done
   
   Complexité : O(n)
   Espace : O(1) (modification sur place)
   
   NOTRE VERSION FONCTIONNELLE :
   
   À chaque étape :
   - List.length : O(n)
   - split_at : O(n)
   - @ (concaténation) : O(n)
   - n étapes au total
   
   Complexité : O(n²)
   Espace : O(n) (nouvelles listes créées)
   
   COMPROMIS :
   + Respect de la programmation fonctionnelle
   + Pas de mutation
   + Code plus lisible et sûr
   - Moins efficace en temps et espace
   
   Pour un deck de 52 cartes, la différence de performance est négligeable.
*)

(* ========================================================================== *)
(* PROPRIÉTÉS MATHÉMATIQUES *)
(* ========================================================================== *)

(*
   UNIFORMITÉ :
   
   Notre algorithme préserve-t-il l'uniformité du mélange ?
   
   À chaque étape, on choisit uniformément un élément parmi ceux restants.
   C'est exactement le principe de Fisher-Yates.
   
   Probabilité pour une permutation donnée :
   - 1re carte : 1/52
   - 2e carte : 1/51  
   - 3e carte : 1/50
   - ...
   - 52e carte : 1/1
   
   Probabilité totale : (1/52) × (1/51) × ... × (1/1) = 1/52!
   
   Toutes les permutations ont la même probabilité → mélange uniforme ✓
   
   CORRECTION :
   
   L'algorithme termine-t-il toujours ?
   - À chaque étape, la taille de 'remaining' diminue de 1
   - remaining atteint [] après exactement n étapes
   - Terminaison garantie ✓
   
   Tous les éléments sont-ils préservés ?
   - On ne fait que déplacer les éléments, jamais de création/suppression
   - Conservation garantie ✓
*)

(* ========================================================================== *)
(* OPTIMISATIONS POSSIBLES *)
(* ========================================================================== *)

(*
   OPTIMISATION 1 : Éviter List.length répétés
   
   let shuffle lst =
     let rec shuffle_aux acc remaining len =
       match remaining with
       | [] -> acc
       | _ ->
         let random_index = Random.int len in
         let (before, after) = split_at random_index remaining [] in
         match after with
         | [] -> acc
         | chosen :: rest ->
           let new_remaining = before @ rest in
           shuffle_aux (chosen :: acc) new_remaining (len - 1)
     in
     shuffle_aux [] lst (List.length lst)
   
   OPTIMISATION 2 : split_at plus efficace
   
   On pourrait utiliser une approche avec des index pour éviter
   de reconstruire des listes intermédiaires.
   
   MAIS : Ces optimisations complexifient le code et ne sont pas
   nécessaires pour l'exercice. La clarté prime sur la performance.
*)

(* ========================================================================== *)
(* TESTS ET VALIDATION *)
(* ========================================================================== *)

(*
   TESTS À EFFECTUER :
   
   1. TEST DE TAILLE :
      List.length (shuffle lst) = List.length lst
   
   2. TEST DE CONTENU :
      List.sort compare (shuffle lst) = List.sort compare lst
   
   3. TEST D'ALÉATOIRE :
      shuffle lst ≠ lst (la plupart du temps)
      shuffle lst ≠ shuffle lst (la plupart du temps)
   
   4. TEST DE CAS LIMITES :
      shuffle [] = []
      shuffle [x] = [x]
   
   5. TEST DE DISTRIBUTION :
      Sur de nombreux échantillons, vérifier que chaque permutation
      apparaît avec une fréquence similaire.
*)

(* ========================================================================== *)
(* CONCLUSION *)
(* ========================================================================== *)

(*
   La version fonctionnelle du mélange de Fisher-Yates :
   
   ✓ Respecte les contraintes de programmation fonctionnelle
   ✓ Produit un mélange uniforme et correct
   ✓ Utilise uniquement les fonctions autorisées
   ✓ Code lisible et compréhensible
   
   ✗ Moins efficace que la version impérative (O(n²) vs O(n))
   ✗ Utilise plus de mémoire
   
   Pour l'exercice pédagogique et la taille des données (52 cartes),
   ces compromis sont tout à fait acceptables.
   
   Cette implémentation démontre comment adapter un algorithme classique
   impératif aux contraintes de la programmation fonctionnelle pure.
*)
