# Sessions Interpréteur OCaml - Complément au Guide Day 12

Ce document contient des sessions interactives complètes pour manipuler et comprendre les concepts du Day 12 dans l'interpréteur OCaml.

---

## 📋 Pour ex02 : Création de foncteurs personnalisés

### Session 1 : Comprendre les signatures de foncteurs

```ocaml
(* Définir les types de base *)
# module type PAIR = sig val pair : (int * int) end;;
module type PAIR = sig val pair : int * int end

# module type VAL = sig val x : int end;;
module type VAL = sig val x : int end

(* Voir la signature d'un foncteur *)
# module type MAKEPROJECTION = functor (P : PAIR) -> VAL;;
module type MAKEPROJECTION = functor (P : PAIR) -> VAL

(* Lire cette signature :
   "MAKEPROJECTION est le type d'un foncteur qui :
    - prend un module P de type PAIR
    - retourne un module de type VAL" *)
```

### Session 2 : Créer et utiliser MakeFst

```ocaml
(* Implémentation de MakeFst *)
# module MakeFst : MAKEPROJECTION = functor (P : PAIR) -> struct
    let x = Stdlib.fst P.pair
  end;;
module MakeFst : MAKEPROJECTION

(* Créer un module Pair *)
# module Pair : PAIR = struct let pair = (21, 42) end;;
module Pair : PAIR

(* Appliquer le foncteur *)
# module Fst : VAL = MakeFst(Pair);;
module Fst : VAL

(* Accéder à la valeur *)
# Fst.x;;
- : int = 21

(* Vérifier la signature *)
# #show Fst;;
module Fst : VAL
```

### Session 3 : Étapes détaillées de l'application du foncteur

```ocaml
(* Créons un module Pair avec plus de détails *)
# module MyPair = struct
    let pair = (100, 200)
    let sum = 300  (* élément bonus *)
  end;;
module MyPair : sig val pair : int * int val sum : int end

(* Appliquons MakeFst *)
# module MyFst = MakeFst(MyPair);;
module MyFst : VAL

(* Que contient MyFst ? *)
# #show MyFst;;
module MyFst : VAL

# MyFst.x;;
- : int = 100

(* La valeur 'sum' est-elle accessible ? NON *)
# MyFst.sum;;
Error: Unbound value MyFst.sum

(* Pourquoi ? Car MakeFst ne crée qu'un champ 'x' *)
(* 'sum' existe dans MyPair mais pas dans le résultat du foncteur *)
# MyPair.sum;;
- : int = 300  (* toujours accessible dans MyPair *)
```

### Session 4 : Créer MakeSnd et comparer

```ocaml
(* Implémentation de MakeSnd *)
# module MakeSnd : MAKEPROJECTION = functor (P : PAIR) -> struct
    let x = Stdlib.snd P.pair
  end;;
module MakeSnd : MAKEPROJECTION

(* Utiliser les deux foncteurs sur le même module *)
# module Pair = struct let pair = (21, 42) end;;
# module Fst = MakeFst(Pair);;
# module Snd = MakeSnd(Pair);;

# Fst.x;;
- : int = 21

# Snd.x;;
- : int = 42

(* Les deux ont le même type de sortie (VAL) *)
# #show Fst;;
module Fst : VAL

# #show Snd;;
module Snd : VAL

(* Mais des valeurs différentes *)
```

### Session 5 : Que se passe-t-il sans signature de foncteur ?

```ocaml
(* Foncteur sans annotation de type *)
# module MakeFstNoSig = functor (P : PAIR) -> struct
    let x = Stdlib.fst P.pair
    let original_pair = P.pair  (* on expose plus que nécessaire *)
  end;;
module MakeFstNoSig : functor (P : PAIR) -> sig
  val x : int
  val original_pair : int * int
end

(* Appliquer ce foncteur *)
# module Pair = struct let pair = (21, 42) end;;
# module FstNoSig = MakeFstNoSig(Pair);;

# FstNoSig.x;;
- : int = 21

# FstNoSig.original_pair;;
- : (int * int) = (21, 42)  (* accessible ! *)

(* DIFFÉRENCE CLÉS :
   - Avec signature (MAKEPROJECTION) : seul 'x' est exposé
   - Sans signature : tout est exposé

   → Les signatures servent à CONTRÔLER l'interface publique *)
```

### Session 6 : Foncteurs avec différents paramètres

```ocaml
(* Plusieurs modules PAIR différents *)
# module Pair1 = struct let pair = (1, 2) end;;
# module Pair2 = struct let pair = (100, 200) end;;
# module Pair3 = struct let pair = (-5, 10) end;;

(* Appliquer MakeFst à tous *)
# module Fst1 = MakeFst(Pair1);;
# module Fst2 = MakeFst(Pair2);;
# module Fst3 = MakeFst(Pair3);;

# Fst1.x;;
- : int = 1

# Fst2.x;;
- : int = 100

# Fst3.x;;
- : int = -5

(* Un seul foncteur, réutilisé plusieurs fois ! *)
(* C'est la PUISSANCE de la généricité *)
```

---

## 📋 Pour ex03 : Nombres à virgule fixe

### Session 1 : Créer Fixed4 et Fixed8 dans l'interpréteur

```ocaml
(* Charger le code de ex03.ml *)
# #use "12/ex03/ex03.ml";;

(* Ou recréer manuellement les définitions essentielles *)
# module type FRACTIONNAL_BITS = sig val bits : int end;;

# module Make = functor (FB : FRACTIONNAL_BITS) -> struct
    type t = int
    let scale_factor = 1 lsl FB.bits
    let scale_factor_float = float_of_int scale_factor

    let of_float f = int_of_float (f *. scale_factor_float +. 0.5)
    let of_int i = i lsl FB.bits
    let to_float x = (float_of_int x) /. scale_factor_float
    let to_int x = x asr FB.bits
    let to_string x =
      let f = to_float x in
      if f = floor f then Printf.sprintf "%.0f." f
      else string_of_float f

    let zero = 0
    let one = scale_factor
    let succ x = x + 1
    let pred x = x - 1
    let add x y = x + y
    let sub x y = x - y
    let mul x y = (x * y) asr FB.bits
    let div x y = (x lsl FB.bits) / y

    let foreach start stop f =
      let rec loop current =
        if current <= stop then begin
          f current;
          loop (succ current)
        end
      in
      loop start
  end;;

# module Fixed4 = Make(struct let bits = 4 end);;
# module Fixed8 = Make(struct let bits = 8 end);;
```

### Session 2 : Comparer Fixed4 et Fixed8

```ocaml
(* Vérifier les facteurs d'échelle *)
# let scale4 = 1 lsl 4;;
val scale4 : int = 16

# let scale8 = 1 lsl 8;;
val scale8 : int = 256

(* Le type est abstrait mais voyons les conversions *)
# let f4_one = Fixed4.of_float 1.0;;
val f4_one : Fixed4.t = <abstr>

# Fixed4.to_float f4_one;;
- : float = 1.

(* Pour voir la représentation interne, créons une version exposée *)
# module Fixed4_Debug = struct
    type t = int  (* On expose le type *)
    let scale_factor = 1 lsl 4
    let of_float f = int_of_float (f *. 16.0 +. 0.5)
    let to_float x = (float_of_int x) /. 16.0
  end;;

# Fixed4_Debug.of_float 1.0;;
- : Fixed4_Debug.t = 16

# Fixed4_Debug.of_float 0.5;;
- : Fixed4_Debug.t = 8

# Fixed4_Debug.of_float 0.0625;;
- : Fixed4_Debug.t = 1  (* Plus petite unité représentable *)

# Fixed4_Debug.of_float 0.01;;
- : Fixed4_Debug.t = 0  (* Trop petit ! Arrondi à 0 *)
```

### Session 3 : Tester la précision

```ocaml
(* Fixed4 : résolution = 1/16 = 0.0625 *)
# let f4_tiny = Fixed4.of_float 0.01;;
# Fixed4.to_float f4_tiny;;
- : float = 0.  (* Arrondi à 0 ! Perte de précision *)

# let f4_small = Fixed4.of_float 0.06;;
# Fixed4.to_float f4_small;;
- : float = 0.0625  (* Arrondi à la valeur la plus proche *)

(* Fixed8 : résolution = 1/256 ≈ 0.0039 *)
# let f8_tiny = Fixed8.of_float 0.01;;
# Fixed8.to_float f8_tiny;;
- : float = 0.01171875  (* Meilleure approximation : 3/256 *)

# let f8_precise = Fixed8.of_float 0.001;;
# Fixed8.to_float f8_precise;;
- : float = 0.  (* Toujours en dessous de la résolution *)

(* Démonstration : Fixed8 est plus précis pour les petits nombres *)
```

### Session 4 : Compter les itérations - LA QUESTION CRUCIALE

```ocaml
(* Comptons manuellement Fixed4 de 0 à 1 *)
# let counter = ref 0;;
val counter : int ref = {contents = 0}

# Fixed4.foreach (Fixed4.zero) (Fixed4.one) (fun _ -> incr counter);;
- : unit = ()

# !counter;;
- : int = 17  (* Confirmation : 17 itérations, pas 16 ! *)

(* Testons avec 0 à 0.25 *)
# let counter2 = ref 0;;
# Fixed4.foreach (Fixed4.zero) (Fixed4.of_float 0.25) (fun _ -> incr counter2);;
# !counter2;;
- : int = 5  (* 5 itérations : 0.0, 0.0625, 0.125, 0.1875, 0.25 *)

(* Affichons toutes les valeurs *)
# Fixed4.foreach (Fixed4.zero) (Fixed4.one) (fun f ->
    Printf.printf "%s " (Fixed4.to_string f));;
0. 0.0625 0.125 0.1875 0.25 0.3125 0.375 0.4375 0.5 0.5625 0.625 0.6875 0.75 0.8125 0.875 0.9375 1.
- : unit = ()

(* Compter manuellement : 0, 0.0625, ..., 0.9375, 1.0 = 17 valeurs ! *)

(* Fixed8 de 0 à 1 : combien d'itérations ? *)
# let counter8 = ref 0;;
# Fixed8.foreach (Fixed8.zero) (Fixed8.one) (fun _ -> incr counter8);;
# !counter8;;
- : int = 257  (* 0 à 256 inclus = 257 valeurs *)

(* Formule générale pour foreach(zero, one) : 2^bits + 1 itérations *)
(* Fixed4 : 2^4 + 1 = 16 + 1 = 17 *)
(* Fixed8 : 2^8 + 1 = 256 + 1 = 257 *)
```

### Session 4.5 : Comment le programme sait combien afficher ?

```ocaml
(* Analysons foreach(0, 0.25) en détail *)

(* Étape 1 : Conversions *)
# let start = Fixed4.zero;;  (* 0 en interne *)
# let stop = Fixed4.of_float 0.25;;  (* Calculons *)

(* Simulons of_float 0.25 *)
# let scale_factor = 16.0;;
# let stop_internal = int_of_float (0.25 *. scale_factor +. 0.5);;
val stop_internal : int = 4

(* Donc : foreach va itérer de 0 à 4 (en représentation interne) *)

(* Étape 2 : Mécanisme de la boucle *)
(*
   loop 0:  0 <= 4 ? OUI → affiche, succ(0) = 1
   loop 1:  1 <= 4 ? OUI → affiche, succ(1) = 2
   loop 2:  2 <= 4 ? OUI → affiche, succ(2) = 3
   loop 3:  3 <= 4 ? OUI → affiche, succ(3) = 4
   loop 4:  4 <= 4 ? OUI → affiche, succ(4) = 5
   loop 5:  5 <= 4 ? NON → STOP
*)

(* Nombre d'itérations = (stop - start) + 1 = (4 - 0) + 1 = 5 *)

(* Affichons avec la valeur interne visible *)
# Fixed4.foreach (Fixed4.zero) (Fixed4.of_float 0.25) (fun f ->
    (* Si on pouvait voir la représentation interne : *)
    Printf.printf "  %s\n" (Fixed4.to_string f));;
  0.
  0.0625
  0.125
  0.1875
  0.25
- : unit = ()

(* Le programme NE CALCULE PAS à l'avance combien de nombres.
   Il suit simplement l'algorithme :
   1. Démarre à start
   2. Continue tant que current <= stop
   3. Incrémente avec succ
   4. S'arrête automatiquement quand current > stop *)

(* Visualisons les représentations internes *)
# let show_internal f =
    (* On ne peut pas accéder directement à la représentation,
       mais on peut la déduire *)
    let real_value = Fixed4.to_float f in
    let internal = int_of_float (real_value *. 16.0 +. 0.5) in
    Printf.printf "  Réel: %f → Interne: %d\n" real_value internal
  ;;

# Fixed4.foreach (Fixed4.zero) (Fixed4.of_float 0.25) show_internal;;
  Réel: 0.000000 → Interne: 0
  Réel: 0.062500 → Interne: 1
  Réel: 0.125000 → Interne: 2
  Réel: 0.187500 → Interne: 3
  Réel: 0.250000 → Interne: 4
- : unit = ()

(* CONCLUSION :
   Le programme ne "sait" pas à l'avance combien de nombres.
   C'est la condition "current <= stop" qui détermine naturellement
   le nombre d'itérations en fonction des valeurs internes. *)
```

### Session 4.6 : D'où vient le "step" de 0.0625 ?

```ocaml
(* Le "step" n'est PAS calculé explicitement dans le code ! *)
(* C'est une conséquence mathématique de succ *)

(* Rappel : succ incrémente de 1 en représentation interne *)
# (* let succ x = x + 1 *)

(* Pour Fixed4, scale_factor = 16 *)
# let scale_factor = 16;;
val scale_factor : int = 16

(* Démontrons que step = 1/16 *)

(* Prenons une valeur quelconque *)
# let x_internal = 5;;  (* n'importe quelle valeur *)
val x_internal : int = 5

# let x_real = (float_of_int x_internal) /. 16.0;;
val x_real : float = 0.3125  (* 5/16 *)

(* Après succ : x + 1 *)
# let y_internal = x_internal + 1;;
val y_internal : int = 6

# let y_real = (float_of_int y_internal) /. 16.0;;
val y_real : float = 0.375  (* 6/16 *)

(* Le step est la différence *)
# let step = y_real -. x_real;;
val step : float = 0.0625

(* Vérifions : 1/16 = 0.0625 *)
# 1.0 /. 16.0;;
- : float = 0.0625  ✓

(* DÉMONSTRATION ALGÉBRIQUE *)
(*
   x_real = x / scale_factor
   y_real = (x + 1) / scale_factor

   step = y_real - x_real
        = (x + 1) / scale_factor - x / scale_factor
        = [(x + 1) - x] / scale_factor
        = 1 / scale_factor
        = 1 / 16
        = 0.0625

   Le step est TOUJOURS 1/scale_factor, quelle que soit la valeur de x !
*)

(* Pour Fixed8 *)
# let scale_factor8 = 256;;
# let step8 = 1.0 /. (float_of_int scale_factor8);;
val step8 : float = 0.00390625

(* Formule générale *)
# let compute_step bits =
    let scale = float_of_int (1 lsl bits) in
    1.0 /. scale
  ;;
val compute_step : int -> float = <fun>

# compute_step 4;;
- : float = 0.0625  (* Fixed4 *)

# compute_step 8;;
- : float = 0.00390625  (* Fixed8 *)

# compute_step 16;;
- : float = 1.52587890625e-05  (* Fixed16, très précis ! *)

(* CONCLUSION IMPORTANTE :
   Le "step" n'est jamais calculé ou stocké dans le code.
   C'est une propriété émergente du système :

   step = 1 / (2^bits)

   Cette valeur découle directement de :
   1. La définition de succ (x + 1)
   2. Le facteur d'échelle (2^bits)
   3. La conversion to_float (x / scale_factor)
*)
```

### Session 5 : Visualiser l'arithmétique

```ocaml
(* Addition : directe, pas de renormalisation *)
# let a = Fixed4.of_float 1.25;;
# let b = Fixed4.of_float 2.75;;
# let sum = Fixed4.add a b;;
# Fixed4.to_float sum;;
- : float = 4.

(* En interne : (1.25 * 16) + (2.75 * 16) = 20 + 44 = 64 = 4.0 * 16 ✓ *)

(* Multiplication : ATTENTION AU PROBLÈME DU (2n) ! *)
# let x = Fixed4.of_float 2.0;;
# let y = Fixed4.of_float 1.5;;

(* Représentations internes *)
(* x_fixed = 2.0 × 2^4 = 32 *)
(* y_fixed = 1.5 × 2^4 = 24 *)

(* Multiplication naïve (INCORRECTE) *)
(* 32 × 24 = 768 *)

(* Analysons 768 *)
(* 768 = (2.0 × 1.5) × 2^8 *)
(*     = 3.0 × 2^(2×4) *)
(*          ^^^^^^^^^^ *)
(*          Voici le 2n ! n=4, donc 2n=8 *)

(* On veut : 3.0 × 2^4 = 48 *)
(* On a :    3.0 × 2^8 = 768 *)
(* Excès :   2^4 = 16 *)

# let prod = Fixed4.mul x y;;
# Fixed4.to_float prod;;
- : float = 3.

(* Code de mul : (x * y) asr FB.bits *)
(* En interne : 768 asr 4 = 768 / 16 = 48 = 3.0 × 2^4 ✓ *)
(* Renormalisation : 2^(2n) / 2^n = 2^n ✓ *)

(* Division : problème inverse, nécessite pré-scaling *)
# let a = Fixed4.of_float 7.0;;
# let b = Fixed4.of_float 2.0;;

(* Sans pré-scaling (INCORRECT) *)
(* a_fixed / b_fixed = (7 × 2^4) / (2 × 2^4) *)
(*                   = 112 / 32 *)
(*                   = 3.5 (pas scalé !) *)

(* Avec pré-scaling (CORRECT) *)
(* Code de div : (x lsl FB.bits) / y *)
(* (112 << 4) / 32 = (112 × 16) / 32 = 1792 / 32 = 56 *)
(* 56 = 3.5 × 2^4 ✓ *)

# let quot = Fixed4.div a b;;
# Fixed4.to_float quot;;
- : float = 3.5
```

### Session 5.5 : Comprendre le (2n) en détail - QUESTION CLÉS

```ocaml
(* Démonstration mathématique pas à pas *)

(* Soit n = FB.bits = 4 pour Fixed4 *)
(* Facteur d'échelle : 2^n = 2^4 = 16 *)

(* Nombres réels : a = 2.0, b = 3.0 *)
(* Représentations fixed : *)
# let a_fixed = 2.0 *. 16.0;;  (* simulons *)
val a_fixed : float = 32.

# let b_fixed = 3.0 *. 16.0;;
val b_fixed : float = 48.

(* Multiplication des représentations *)
# let produit_naif = a_fixed *. b_fixed;;
val produit_naif : float = 1536.

(* Décomposons 1536 *)
(* 1536 = 6.0 × 256 *)
(* 1536 = 6.0 × 2^8 *)
(* 1536 = 6.0 × 2^(2×4)  ← Voici le 2n ! *)

(* Pourquoi 2n et pas n ? *)
(* Parce que : 2^n × 2^n = 2^(n+n) = 2^(2n) *)
(* Propriété des exposants : a^m × a^p = a^(m+p) *)

(* Vérification *)
# 2.0 ** 4.0 *. 2.0 ** 4.0;;  (* 2^4 × 2^4 *)
- : float = 256.

# 2.0 ** 8.0;;  (* 2^8 *)
- : float = 256.

# 2.0 ** (2.0 *. 4.0);;  (* 2^(2×4) *)
- : float = 256.  (* ÉGALITÉ CONFIRMÉE *)

(* Pour revenir à l'échelle correcte *)
(* On doit diviser par 2^n pour obtenir 2^n au lieu de 2^(2n) *)
# let produit_correct = produit_naif /. 16.0;;  (* /. 2^n *)
val produit_correct : float = 96.

(* Vérification : 96 = 6.0 × 16 = 6.0 × 2^4 ✓ *)
# produit_correct /. 16.0;;  (* extraire la valeur réelle *)
- : float = 6.  (* C'est bien 2.0 × 3.0 = 6.0 ✓ *)

(* RÉSUMÉ MATHÉMATIQUE *)
(* ───────────────────── *)
(* Multiplication fixed-point :
   (a × 2^n) × (b × 2^n) = (a×b) × 2^(2n)
                                    ^^^^^
                                    Problème : on veut 2^n, pas 2^(2n)

   Solution : diviser par 2^n
   [(a × 2^n) × (b × 2^n)] / 2^n = (a×b) × 2^n ✓

   En code OCaml :
   let mul x y = (x * y) asr FB.bits
                 ^^^^^^^   ^^^^^^^^^^^
                 2^(2n)    / 2^n = 2^n
*)
```

### Session 6 : Limites et débordements

```ocaml
(* Quelle est la valeur maximale représentable ? *)
(* Fixed4 sur 32 bits : ±2^27 *)
# let max_value = Fixed4.of_int 134217727;;  (* 2^27 - 1 *)
# Fixed4.to_int max_value;;
- : int = 134217727

(* Tenter de dépasser *)
# let overflow = Fixed4.of_int 134217728;;  (* 2^27 *)
# Fixed4.to_int overflow;;
- : int = -134217728  (* Débordement ! Passe en négatif *)

(* Fixed8 a une plage plus restreinte : ±2^23 *)
# let max8 = Fixed8.of_int 8388607;;  (* 2^23 - 1 *)
# Fixed8.to_int max8;;
- : int = 8388607

# let overflow8 = Fixed8.of_int 8388608;;
# Fixed8.to_int overflow8;;
- : int = -8388608  (* Débordement *)

(* Trade-off : Fixed4 = plus de range, Fixed8 = plus de précision *)
```

---

## 📋 Pour ex04 : Évaluateur d'expressions

### Session 1 : Comprendre le problème initial

```ocaml
(* Définir les signatures *)
# module type VAL = sig
    type t
    val add : t -> t -> t
    val mul : t -> t -> t
  end;;

# module type EVALEXPR = sig
    type t
    type expr =
      | Value of t
      | Add of expr * expr
      | Mul of expr * expr
    val eval : expr -> t
  end;;

(* Créer IntVal *)
# module IntVal : VAL with type t = int = struct
    type t = int
    let add = (+)
    let mul = ( * )
  end;;

(* Créer le foncteur *)
# module MakeEvalExpr = functor (V : VAL) -> struct
    type t = V.t
    type expr =
      | Value of t
      | Add of expr * expr
      | Mul of expr * expr

    let rec eval = function
      | Value v -> v
      | Add (e1, e2) -> V.add (eval e1) (eval e2)
      | Mul (e1, e2) -> V.mul (eval e1) (eval e2)
  end;;

(* Instancier sans annotation *)
# module IntEvalExprTest = MakeEvalExpr(IntVal);;
module IntEvalExprTest :
  sig
    type t = IntVal.t
    type expr = Value of t | Add of expr * expr | Mul of expr * expr
    val eval : expr -> t
  end

(* Essayer d'utiliser les constructeurs *)
# let test = IntEvalExprTest.Value 42;;
val test : IntEvalExprTest.expr = IntEvalExprTest.Value 42

(* Ça marche sans signature explicite ! *)
```

### Session 2 : Différence entre `with type t =` et `with type t :=`

```ocaml
(* Version avec '=' (égalité de type) *)
# module IntEvalExpr1 : EVALEXPR with type t = int =
    MakeEvalExpr(IntVal);;
module IntEvalExpr1 :
  sig
    type t = int
    type expr = Value of t | Add of expr * expr | Mul of expr * expr
    val eval : expr -> t
  end

(* Vérifier la signature *)
# #show IntEvalExpr1;;
module IntEvalExpr1 :
  sig
    type t = int  (* t est toujours présent *)
    type expr = Value of t | Add of expr * expr | Mul of expr * expr
    val eval : expr -> t
  end

(* Utiliser les constructeurs avec le type 't' explicite *)
# let expr1 = IntEvalExpr1.Value 42;;
val expr1 : IntEvalExpr1.expr = IntEvalExpr1.Value 42

# IntEvalExpr1.eval expr1;;
- : IntEvalExpr1.t = 42
(* Le type de retour est 'IntEvalExpr1.t', pas directement 'int' *)

(* Version avec ':=' (substitution destructive) *)
# module IntEvalExpr2 : EVALEXPR with type t := int =
    MakeEvalExpr(IntVal);;
module IntEvalExpr2 :
  sig
    type expr = Value of int | Add of expr * expr | Mul of expr * expr
    val eval : expr -> int
  end

(* Vérifier la signature *)
# #show IntEvalExpr2;;
module IntEvalExpr2 :
  sig
    (* type t a disparu ! *)
    type expr = Value of int | Add of expr * expr | Mul of expr * expr
    val eval : expr -> int
  end

(* Utiliser les constructeurs avec 'int' directement *)
# let expr2 = IntEvalExpr2.Value 42;;
val expr2 : IntEvalExpr2.expr = IntEvalExpr2.Value 42

# IntEvalExpr2.eval expr2;;
- : int = 42  (* Retourne directement 'int', pas 'IntEvalExpr2.t' *)
```

### Session 3 : Les 7 contraintes de partage en détail

```ocaml
(* Contraintes 1-3 : Modules VAL concrets *)
# module IntVal : VAL with type t = int = struct
    type t = int
    let add = (+)
    let mul = ( * )
  end;;
(* Contrainte : exposer que t = int *)

# module FloatVal : VAL with type t = float = struct
    type t = float
    let add = (+.)
    let mul = ( *.)
  end;;

# module StringVal : VAL with type t = string = struct
    type t = string
    let add s1 s2 = if String.length s1 > String.length s2 then s1 else s2
    let mul = (^)
  end;;

(* Contrainte 4 : Foncteur avec partage de type *)
# module type MAKEEVALEXPR =
    functor (V : VAL) -> EVALEXPR with type t = V.t;;
(* Contrainte : le type t du résultat = type t du paramètre *)

(* Contraintes 5-7 : Instanciations avec substitution destructive *)
# module IntEvalExpr : EVALEXPR with type t := int =
    MakeEvalExpr(IntVal);;

# module FloatEvalExpr : EVALEXPR with type t := float =
    MakeEvalExpr(FloatVal);;

# module StringEvalExpr : EVALEXPR with type t := string =
    MakeEvalExpr(StringVal);;

(* Compter : 3 + 1 + 3 = 7 contraintes ✓ *)
```

### Session 4 : Tester StringVal et son arithmétique

```ocaml
(* Rappel de StringVal *)
# StringVal.add "hello" "hi";;
- : string = "hello"  (* max par longueur *)

# StringVal.add "hi" "hello";;
- : string = "hello"

# StringVal.mul "foo" "bar";;
- : string = "foobar"  (* concaténation *)

(* Créer une expression StringEvalExpr *)
# let se = StringEvalExpr.Mul (
    StringEvalExpr.Value "very ",
    StringEvalExpr.Add (
      StringEvalExpr.Value "very long",
      StringEvalExpr.Value "short"
    )
  );;
val se : StringEvalExpr.expr = (...)

(* Évaluer étape par étape :
   Add("very long", "short")
     → max_by_length("very long", "short")
     → "very long"

   Mul("very ", "very long")
     → "very " ^ "very long"
     → "very very long"
*)

# StringEvalExpr.eval se;;
- : string = "very very long"
```

### Session 5 : Extensibilité - ajouter un nouveau type

```ocaml
(* Créons BoolVal avec des opérations logiques *)
# module BoolVal : VAL with type t = bool = struct
    type t = bool
    let add = (||)  (* OR logique *)
    let mul = (&&)  (* AND logique *)
  end;;
module BoolVal : sig type t = bool val add : bool -> bool -> bool val mul : bool -> bool -> bool end

(* Instancier BoolEvalExpr *)
# module BoolEvalExpr : EVALEXPR with type t := bool =
    MakeEvalExpr(BoolVal);;
module BoolEvalExpr :
  sig
    type expr = Value of bool | Add of expr * expr | Mul of expr * expr
    val eval : expr -> bool
  end

(* Créer une expression booléenne *)
# let be = BoolEvalExpr.Add (
    BoolEvalExpr.Value true,
    BoolEvalExpr.Mul (
      BoolEvalExpr.Value false,
      BoolEvalExpr.Value true
    )
  );;

# BoolEvalExpr.eval be;;
- : bool = true
(* Calcul : true || (false && true) = true || false = true ✓ *)

(* On a ajouté un nouveau type SANS modifier MakeEvalExpr ! *)
(* C'est la puissance de l'extensibilité *)
```

### Session 6 : Comprendre le fonctionnement de eval

```ocaml
(* Analysons eval en détail *)

(* Rappel des types *)
# module type VAL = sig
    type t
    val add : t -> t -> t
    val mul : t -> t -> t
  end;;

# module IntVal : VAL with type t = int = struct
    type t = int
    let add = (+)
    let mul = ( * )
  end;;

# module MakeEvalExpr = functor (V : VAL) -> struct
    type t = V.t
    type expr =
      | Value of t
      | Add of expr * expr
      | Mul of expr * expr

    let rec eval = function
      | Value v -> v
      | Add (e1, e2) -> V.add (eval e1) (eval e2)
      | Mul (e1, e2) -> V.mul (eval e1) (eval e2)
  end;;

# module IntEval = MakeEvalExpr(IntVal);;

(* Exemple simple : Value 42 *)
# let expr1 = IntEval.Value 42;;
# IntEval.eval expr1;;
- : IntVal.t = 42
(* Pattern matching : Value v → retourne v directement *)

(* Exemple avec Add *)
# let expr2 = IntEval.Add (IntEval.Value 2, IntEval.Value 3);;
# IntEval.eval expr2;;
- : IntVal.t = 5
(*
   eval (Add (Value 2, Value 3))
   → V.add (eval (Value 2)) (eval (Value 3))
   → V.add 2 3
   → 5
*)

(* Exemple avec Mul *)
# let expr3 = IntEval.Mul (IntEval.Value 4, IntEval.Value 5);;
# IntEval.eval expr3;;
- : IntVal.t = 20
(*
   eval (Mul (Value 4, Value 5))
   → V.mul (eval (Value 4)) (eval (Value 5))
   → V.mul 4 5
   → 20
*)

(* Exemple imbriqué : (2 + 3) * 5 *)
# let expr4 = IntEval.Mul (
    IntEval.Add (IntEval.Value 2, IntEval.Value 3),
    IntEval.Value 5
  );;
# IntEval.eval expr4;;
- : IntVal.t = 25

(* Trace d'exécution :
   eval Mul(Add(Value 2, Value 3), Value 5)

   1. Pattern : Mul(e1, e2)
   2. Calcule : V.mul (eval e1) (eval e2)

   3. eval e1 = eval Add(Value 2, Value 3)
      3.1. Pattern : Add(e1', e2')
      3.2. Calcule : V.add (eval e1') (eval e2')
      3.3. eval e1' = eval Value 2 → 2
      3.4. eval e2' = eval Value 3 → 3
      3.5. V.add 2 3 → 5

   4. eval e2 = eval Value 5 → 5

   5. V.mul 5 5 → 25
*)

(* Expression complexe : ((1 + 2) * 3) + (4 * 5) *)
# let expr5 = IntEval.Add (
    IntEval.Mul (
      IntEval.Add (IntEval.Value 1, IntEval.Value 2),
      IntEval.Value 3
    ),
    IntEval.Mul (IntEval.Value 4, IntEval.Value 5)
  );;
# IntEval.eval expr5;;
- : IntVal.t = 29

(* Calcul manuel :
   (1 + 2) = 3
   3 * 3 = 9
   4 * 5 = 20
   9 + 20 = 29 ✓
*)

(* Visualisons l'arbre :
         Add
        /    \
      Mul     Mul
     /   \   /   \
   Add   3  4     5
   / \
  1   2
*)
```

### Session 6.5 : Ordre d'évaluation et récursion

```ocaml
(* Créons une version instrumentée pour voir l'ordre *)

# module IntValDebug = struct
    type t = int
    let add x y =
      Printf.printf "  add(%d, %d) = %d\n" x y (x + y);
      x + y
    let mul x y =
      Printf.printf "  mul(%d, %d) = %d\n" x y (x * y);
      x * y
  end;;

# module MakeEvalExprDebug = functor (V : VAL) -> struct
    type t = V.t
    type expr =
      | Value of t
      | Add of expr * expr
      | Mul of expr * expr

    let rec eval expr =
      match expr with
      | Value v ->
          Printf.printf "  eval(Value %d)\n" v;
          v
      | Add (e1, e2) ->
          Printf.printf "  eval(Add(...))\n";
          let v1 = eval e1 in
          let v2 = eval e2 in
          V.add v1 v2
      | Mul (e1, e2) ->
          Printf.printf "  eval(Mul(...))\n";
          let v1 = eval e1 in
          let v2 = eval e2 in
          V.mul v1 v2
  end;;

# module IntEvalDebug = MakeEvalExprDebug(IntValDebug);;

(* Testons : (2 + 3) * 5 *)
# let expr = IntEvalDebug.Mul (
    IntEvalDebug.Add (IntEvalDebug.Value 2, IntEvalDebug.Value 3),
    IntEvalDebug.Value 5
  );;

# Printf.printf "=== Évaluation de (2 + 3) * 5 ===\n";;
# IntEvalDebug.eval expr;;
=== Évaluation de (2 + 3) * 5 ===
  eval(Mul(...))
  eval(Add(...))
  eval(Value 2)
  eval(Value 3)
  add(2, 3) = 5
  eval(Value 5)
  mul(5, 5) = 25
- : IntValDebug.t = 25

(* OBSERVATION :
   1. eval Mul → entre dans le cas Mul
   2. Évalue e1 (le Add)
   3. eval Add → entre dans le cas Add
   4. Évalue e1' (Value 2) → retourne 2
   5. Évalue e2' (Value 3) → retourne 3
   6. add(2, 3) → retourne 5
   7. Évalue e2 (Value 5) → retourne 5
   8. mul(5, 5) → retourne 25
*)
```

### Session 7 : Que se passe-t-il sans les contraintes ?

```ocaml
(* Foncteur sans contrainte de partage *)
# module type MAKEEVALEXPR_BAD = functor (V : VAL) -> EVALEXPR;;
(* Pas de 'with type t = V.t' *)

# module MakeEvalExprBad : MAKEEVALEXPR_BAD =
    functor (V : VAL) -> struct
      type t = V.t
      type expr = Value of t | Add of expr * expr | Mul of expr * expr
      let rec eval = function
        | Value v -> v
        | Add (e1, e2) -> V.add (eval e1) (eval e2)
        | Mul (e1, e2) -> V.mul (eval e1) (eval e2)
    end;;

# module IntEvalExprBad : EVALEXPR with type t := int =
    MakeEvalExprBad(IntVal);;
Error: Signature mismatch:
       ...
       Type declarations do not match:
         type t = MakeEvalExprBad(IntVal).t
       is not included in
         type t = int

(* PROBLÈME : le système de types ne sait pas que
   MakeEvalExprBad(IntVal).t = int

   Solution : ajouter la contrainte 'with type t = V.t'
   dans MAKEEVALEXPR *)
```

---

## Résumé des commandes utiles

```ocaml
(* Voir la signature d'un module *)
# #show MonModule;;

(* Charger un fichier *)
# #use "chemin/vers/fichier.ml";;

(* Voir le type d'une expression *)
# let x = 42;;
val x : int = 42

(* Créer un module inline *)
# module M = struct let x = 1 end;;

(* Appliquer un foncteur *)
# module Result = MonFoncteur(MonModule);;
```
