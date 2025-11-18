(*
** Exercice 03: Fixed point numbers
** 
** Description : Implémentation d'un système de nombres à virgule fixe
** via un foncteur paramétrable par le nombre de bits fractionnaires.
** 
** Concepts abordés :
** - Nombres à virgule fixe (fixed-point arithmetic)
** - Format Q notation (Qm.n)
** - Arithmétique entière avec décalage de bits
** - Foncteurs paramétriques avancés
** 
** Format Q :
** - Les nombres sont stockés comme des entiers
** - Les 'bits' LSB représentent la partie fractionnaire
** - Exemple Q28.4 : 28 bits entiers, 4 bits fractionnaires
** - Résolution = 1/(2^bits)
*)

(*
** Signature FRACTIONNAL_BITS
** Description : Module d'entrée spécifiant le nombre de bits fractionnaires
*)
module type FRACTIONNAL_BITS = sig
  val bits : int
end

(*
** Signature FIXED
** Description : Interface complète pour les nombres à virgule fixe
** 
** Type t : représentation interne du nombre à virgule fixe
** Conversions : float ↔ fixed, int ↔ fixed, string
** Constantes : zero, one
** Opérations unaires : succ, pred
** Comparaisons : min, max, gth, lth, gte, lte, eqp, eqs
** Arithmétique : add, sub, mul, div
** Utilitaires : foreach pour itération
*)
module type FIXED = sig
  type t
  val of_float : float -> t
  val of_int : int -> t
  val to_float : t -> float
  val to_int : t -> int
  val to_string : t -> string
  val zero : t
  val one : t
  val succ : t -> t
  val pred : t -> t
  val min : t -> t -> t
  val max : t -> t -> t
  val gth : t -> t -> bool
  val lth : t -> t -> bool
  val gte : t -> t -> bool
  val lte : t -> t -> bool
  val eqp : t -> t -> bool (** physical equality *)
  val eqs : t -> t -> bool (** structural equality *)
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val div : t -> t -> t
  val foreach : t -> t -> (t -> unit) -> unit
end

(*
** Signature MAKE
** Description : Signature du foncteur principal
** Déduction logique basée sur l'utilisation dans l'énoncé
*)
module type MAKE = functor (FB : FRACTIONNAL_BITS) -> FIXED

(*
** Foncteur Make
** Description : Générateur de modules de nombres à virgule fixe
** 
** Paramètre : FB (module spécifiant le nombre de bits fractionnaires)
** Retour : module respectant FIXED
** 
** Représentation interne :
** - Type t = int (stockage en entier)
** - Facteur d'échelle = 2^bits
** - Valeur réelle = valeur_entière / facteur_échelle
** 
** Exemple avec bits=4 :
** - 1.0 est stocké comme 16 (1 * 2^4)
** - 0.5 est stocké comme 8 (0.5 * 2^4)
** - Résolution = 1/16 = 0.0625
*)
module Make : MAKE = functor (FB : FRACTIONNAL_BITS) -> struct
  type t = int
  
  (* Facteur d'échelle : 2^bits *)
  let scale_factor = 1 lsl FB.bits
  let scale_factor_float = float_of_int scale_factor
  
  (*
  ** Conversions depuis les types standards
  *)
  
  (* Conversion float -> fixed *)
  let of_float f = 
    int_of_float (f *. scale_factor_float +. 0.5)
  
  (* Conversion int -> fixed *)
  let of_int i = 
    i lsl FB.bits
  
  (*
  ** Conversions vers les types standards
  *)
  
  (* Conversion fixed -> float *)
  let to_float x = 
    (float_of_int x) /. scale_factor_float
  
  (* Conversion fixed -> int (partie entière) *)
  let to_int x = 
    x asr FB.bits
  
  (* Conversion fixed -> string *)
  let to_string x = 
    let f = to_float x in
    if f = floor f then
      Printf.sprintf "%.0f." f
    else
      string_of_float f
  
  (*
  ** Constantes
  *)
  
  let zero = 0
  let one = scale_factor
  
  (*
  ** Opérations unaires
  *)
  
  let succ x = x + 1
  let pred x = x - 1
  
  (*
  ** Opérations de comparaison et sélection
  *)
  
  let min x y = if x < y then x else y
  let max x y = if x > y then x else y
  
  let gth x y = x > y
  let lth x y = x < y
  let gte x y = x >= y
  let lte x y = x <= y
  
  (* Égalité physique (même référence) *)
  let eqp x y = x == y
  
  (* Égalité structurelle (même valeur) *)
  let eqs x y = x = y
  
  (*
  ** Arithmétique
  *)
  
  (* Addition : directe sur les représentations *)
  let add x y = x + y
  
  (* Soustraction : directe sur les représentations *)
  let sub x y = x - y
  
  (* Multiplication : nécessite renormalisation *)
  let mul x y = (x * y) asr FB.bits
  
  (* Division : nécessite pré-scaling *)
  let div x y = (x lsl FB.bits) / y
  
  (*
  ** Fonction foreach
  ** Description : Itère de start à stop (inclusif) avec pas = plus petite unité
  ** 
  ** Note : Le pas est de 1 en représentation interne,
  ** soit 1/scale_factor en valeur réelle
  *)
  let foreach start stop f =
    let rec loop current =
      if current <= stop then begin
        f current;
        loop (succ current)
      end
    in
    loop start
end

(*
** Modules de test spécifiés dans l'énoncé
*)
module Fixed4 : FIXED = Make (struct let bits = 4 end)
module Fixed8 : FIXED = Make (struct let bits = 8 end)

(*
** Programme de test principal (spécifié dans l'énoncé)
*)
let () =
  let x8 = Fixed8.of_float 21.10 in
  let y8 = Fixed8.of_float 21.32 in
  let r8 = Fixed8.add x8 y8 in
  print_endline (Fixed8.to_string r8);
  Fixed4.foreach (Fixed4.zero) (Fixed4.one) (fun f -> print_endline (Fixed4.to_string f))

(*
** Tests complémentaires pour valider TOUTES les fonctions
** (Requis par l'énoncé pour la peer-evaluation)
*)

let test_all_functions () =
  print_endline "\n=== Tests complets de toutes les fonctions ===\n";
  
  (* Test des conversions *)
  print_endline "1. Tests des conversions :";
  let f4_1_5 = Fixed4.of_float 1.5 in
  let f4_3 = Fixed4.of_int 3 in
  Printf.printf "Fixed4.of_float 1.5 = %s\n" (Fixed4.to_string f4_1_5);
  Printf.printf "Fixed4.of_int 3 = %s\n" (Fixed4.to_string f4_3);
  Printf.printf "Fixed4.to_float %s = %f\n" (Fixed4.to_string f4_1_5) (Fixed4.to_float f4_1_5);
  Printf.printf "Fixed4.to_int %s = %d\n" (Fixed4.to_string f4_3) (Fixed4.to_int f4_3);
  
  (* Test des constantes *)
  print_endline "\n2. Tests des constantes :";
  Printf.printf "Fixed4.zero = %s\n" (Fixed4.to_string Fixed4.zero);
  Printf.printf "Fixed4.one = %s\n" (Fixed4.to_string Fixed4.one);
  
  (* Test des opérations unaires *)
  print_endline "\n3. Tests des opérations unaires :";
  let f4_1 = Fixed4.one in
  Printf.printf "Fixed4.succ %s = %s\n" (Fixed4.to_string f4_1) (Fixed4.to_string (Fixed4.succ f4_1));
  Printf.printf "Fixed4.pred %s = %s\n" (Fixed4.to_string f4_1) (Fixed4.to_string (Fixed4.pred f4_1));
  
  (* Test des comparaisons *)
  print_endline "\n4. Tests des comparaisons :";
  let f4_2 = Fixed4.of_float 2.0 in
  let f4_3 = Fixed4.of_float 3.0 in
  Printf.printf "min(%s, %s) = %s\n" (Fixed4.to_string f4_2) (Fixed4.to_string f4_3) (Fixed4.to_string (Fixed4.min f4_2 f4_3));
  Printf.printf "max(%s, %s) = %s\n" (Fixed4.to_string f4_2) (Fixed4.to_string f4_3) (Fixed4.to_string (Fixed4.max f4_2 f4_3));
  Printf.printf "%s > %s = %b\n" (Fixed4.to_string f4_3) (Fixed4.to_string f4_2) (Fixed4.gth f4_3 f4_2);
  Printf.printf "%s < %s = %b\n" (Fixed4.to_string f4_2) (Fixed4.to_string f4_3) (Fixed4.lth f4_2 f4_3);
  Printf.printf "%s >= %s = %b\n" (Fixed4.to_string f4_3) (Fixed4.to_string f4_3) (Fixed4.gte f4_3 f4_3);
  Printf.printf "%s <= %s = %b\n" (Fixed4.to_string f4_2) (Fixed4.to_string f4_3) (Fixed4.lte f4_2 f4_3);
  Printf.printf "%s == %s = %b (physical)\n" (Fixed4.to_string f4_2) (Fixed4.to_string f4_2) (Fixed4.eqp f4_2 f4_2);
  Printf.printf "%s = %s = %b (structural)\n" (Fixed4.to_string f4_2) (Fixed4.to_string (Fixed4.of_float 2.0)) (Fixed4.eqs f4_2 (Fixed4.of_float 2.0));
  
  (* Test de l'arithmétique *)
  print_endline "\n5. Tests de l'arithmétique :";
  let f4_1_25 = Fixed4.of_float 1.25 in
  let f4_2_75 = Fixed4.of_float 2.75 in
  Printf.printf "%s + %s = %s\n" (Fixed4.to_string f4_1_25) (Fixed4.to_string f4_2_75) (Fixed4.to_string (Fixed4.add f4_1_25 f4_2_75));
  Printf.printf "%s - %s = %s\n" (Fixed4.to_string f4_2_75) (Fixed4.to_string f4_1_25) (Fixed4.to_string (Fixed4.sub f4_2_75 f4_1_25));
  Printf.printf "%s * %s = %s\n" (Fixed4.to_string f4_1_25) (Fixed4.to_string f4_2_75) (Fixed4.to_string (Fixed4.mul f4_1_25 f4_2_75));
  Printf.printf "%s * %s = %s\n" (Fixed4.to_string f4_2) (Fixed4.to_string f4_3) (Fixed4.to_string (Fixed4.mul f4_2 f4_3));
  Printf.printf "%s / %s = %s\n" (Fixed4.to_string f4_2_75) (Fixed4.to_string f4_1_25) (Fixed4.to_string (Fixed4.div f4_2_75 f4_1_25));
  Printf.printf "%s / %s = %s\n" (Fixed4.to_string f4_3) (Fixed4.to_string f4_2) (Fixed4.to_string (Fixed4.div f4_3 f4_2));
  
  (* Test de foreach avec un petit intervalle *)
  print_endline "\n6. Test de foreach (petit échantillon) :";
  print_endline "Fixed4.foreach 0.0 0.25 :";
  Fixed4.foreach (Fixed4.zero) (Fixed4.of_float 0.25) (fun f -> 
    Printf.printf "  %s\n" (Fixed4.to_string f));
  (* Fixed8.foreach (Fixed8.zero) (Fixed8.of_float 0.25) (fun f -> 
    Printf.printf "  %s\n" (Fixed8.to_string f)); *)
  
  print_endline "\n✓ Tous les tests des fonctions terminés\n"

let () = test_all_functions ()
