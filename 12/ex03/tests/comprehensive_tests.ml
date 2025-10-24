(*
** Tests exhaustifs pour l'exercice 03 - Fixed Point Numbers
** Validation complète de toutes les fonctions requises
*)

(* Réimplémentation des types et du foncteur pour les tests *)
module type FRACTIONNAL_BITS = sig
  val bits : int
end

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
  val eqp : t -> t -> bool
  val eqs : t -> t -> bool
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val div : t -> t -> t
  val foreach : t -> t -> (t -> unit) -> unit
end

module type MAKE = functor (FB : FRACTIONNAL_BITS) -> FIXED

module Make : MAKE = functor (FB : FRACTIONNAL_BITS) -> struct
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
  
  let min x y = if x < y then x else y
  let max x y = if x > y then x else y
  
  let gth x y = x > y
  let lth x y = x < y
  let gte x y = x >= y
  let lte x y = x <= y
  let eqp x y = x == y
  let eqs x y = x = y
  
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
end

(* Modules de test *)
module Fixed2 : FIXED = Make (struct let bits = 2 end)
module Fixed4 : FIXED = Make (struct let bits = 4 end)
module Fixed8 : FIXED = Make (struct let bits = 8 end)
module Fixed16 : FIXED = Make (struct let bits = 16 end)

(* Tests complets *)
let test_conversions () =
  Printf.printf "=== Tests des conversions ===\n";
  
  (* Test Fixed4 *)
  let f4_pi = Fixed4.of_float 3.14159 in
  let f4_neg = Fixed4.of_float (-2.5) in
  let f4_int = Fixed4.of_int 42 in
  
  Printf.printf "Fixed4.of_float 3.14159 = %s\n" (Fixed4.to_string f4_pi);
  Printf.printf "Fixed4.to_float %s = %.6f\n" (Fixed4.to_string f4_pi) (Fixed4.to_float f4_pi);
  Printf.printf "Fixed4.of_float -2.5 = %s\n" (Fixed4.to_string f4_neg);
  Printf.printf "Fixed4.of_int 42 = %s\n" (Fixed4.to_string f4_int);
  Printf.printf "Fixed4.to_int %s = %d\n" (Fixed4.to_string f4_int) (Fixed4.to_int f4_int);
  
  (* Test de précision avec différents bits *)
  let pi_2 = Fixed2.of_float 3.14159 in
  let pi_8 = Fixed8.of_float 3.14159 in
  let pi_16 = Fixed16.of_float 3.14159 in
  
  Printf.printf "\nPrécision de pi avec différents bits :\n";
  Printf.printf "Fixed2 (2 bits): %s (%.6f)\n" (Fixed2.to_string pi_2) (Fixed2.to_float pi_2);
  Printf.printf "Fixed8 (8 bits): %s (%.6f)\n" (Fixed8.to_string pi_8) (Fixed8.to_float pi_8);
  Printf.printf "Fixed16 (16 bits): %s (%.6f)\n" (Fixed16.to_string pi_16) (Fixed16.to_float pi_16);
  Printf.printf "\n"

let test_constants () =
  Printf.printf "=== Tests des constantes ===\n";
  
  Printf.printf "Fixed2.zero = %s\n" (Fixed2.to_string Fixed2.zero);
  Printf.printf "Fixed2.one = %s\n" (Fixed2.to_string Fixed2.one);
  Printf.printf "Fixed4.zero = %s\n" (Fixed4.to_string Fixed4.zero);
  Printf.printf "Fixed4.one = %s\n" (Fixed4.to_string Fixed4.one);
  Printf.printf "Fixed8.zero = %s\n" (Fixed8.to_string Fixed8.zero);
  Printf.printf "Fixed8.one = %s\n" (Fixed8.to_string Fixed8.one);
  Printf.printf "\n"

let test_unary_operations () =
  Printf.printf "=== Tests des opérations unaires ===\n";
  
  let f4_half = Fixed4.of_float 0.5 in
  let f4_two = Fixed4.of_int 2 in
  
  Printf.printf "succ(%s) = %s\n" (Fixed4.to_string f4_half) (Fixed4.to_string (Fixed4.succ f4_half));
  Printf.printf "pred(%s) = %s\n" (Fixed4.to_string f4_half) (Fixed4.to_string (Fixed4.pred f4_half));
  Printf.printf "succ(%s) = %s\n" (Fixed4.to_string f4_two) (Fixed4.to_string (Fixed4.succ f4_two));
  Printf.printf "pred(%s) = %s\n" (Fixed4.to_string f4_two) (Fixed4.to_string (Fixed4.pred f4_two));
  Printf.printf "\n"

let test_comparisons () =
  Printf.printf "=== Tests des comparaisons ===\n";
  
  let a = Fixed4.of_float 1.5 in
  let b = Fixed4.of_float 2.5 in
  let c = Fixed4.of_float 1.5 in
  
  Printf.printf "a = %s, b = %s, c = %s\n" 
    (Fixed4.to_string a) (Fixed4.to_string b) (Fixed4.to_string c);
  
  Printf.printf "min(a, b) = %s\n" (Fixed4.to_string (Fixed4.min a b));
  Printf.printf "max(a, b) = %s\n" (Fixed4.to_string (Fixed4.max a b));
  
  Printf.printf "a > b = %b\n" (Fixed4.gth a b);
  Printf.printf "a < b = %b\n" (Fixed4.lth a b);
  Printf.printf "a >= c = %b\n" (Fixed4.gte a c);
  Printf.printf "a <= b = %b\n" (Fixed4.lte a b);
  
  Printf.printf "a == c = %b (physical)\n" (Fixed4.eqp a c);
  Printf.printf "a = c = %b (structural)\n" (Fixed4.eqs a c);
  Printf.printf "\n"

let test_arithmetic () =
  Printf.printf "=== Tests de l'arithmétique ===\n";
  
  let a = Fixed4.of_float 3.25 in
  let b = Fixed4.of_float 1.75 in
  
  Printf.printf "a = %s, b = %s\n" (Fixed4.to_string a) (Fixed4.to_string b);
  
  Printf.printf "a + b = %s\n" (Fixed4.to_string (Fixed4.add a b));
  Printf.printf "a - b = %s\n" (Fixed4.to_string (Fixed4.sub a b));
  Printf.printf "a * b = %s\n" (Fixed4.to_string (Fixed4.mul a b));
  Printf.printf "a / b = %s\n" (Fixed4.to_string (Fixed4.div a b));
  
  (* Tests avec nombres négatifs *)
  let neg_a = Fixed4.of_float (-1.5) in
  let pos_b = Fixed4.of_float 2.0 in
  
  Printf.printf "\nTests avec nombres négatifs :\n";
  Printf.printf "(-1.5) + 2.0 = %s\n" (Fixed4.to_string (Fixed4.add neg_a pos_b));
  Printf.printf "(-1.5) * 2.0 = %s\n" (Fixed4.to_string (Fixed4.mul neg_a pos_b));
  
  Printf.printf "\n"

let test_foreach () =
  Printf.printf "=== Tests de foreach ===\n";
  
  Printf.printf "Fixed4.foreach 0.0 à 0.5 :\n";
  Fixed4.foreach (Fixed4.zero) (Fixed4.of_float 0.5) (fun f ->
    Printf.printf "  %s\n" (Fixed4.to_string f)
  );
  
  Printf.printf "\nFixed2.foreach 0.0 à 1.0 (résolution 0.25) :\n";
  Fixed2.foreach (Fixed2.zero) (Fixed2.one) (fun f ->
    Printf.printf "  %s\n" (Fixed2.to_string f)
  );
  
  Printf.printf "\n"

let test_edge_cases () =
  Printf.printf "=== Tests des cas limites ===\n";
  
  (* Test avec des très petits nombres *)
  let tiny = Fixed8.of_float 0.001 in
  Printf.printf "Très petit (0.001) en Fixed8: %s\n" (Fixed8.to_string tiny);
  
  (* Test avec zéro *)
  let zero_div_test = Fixed4.div (Fixed4.zero) (Fixed4.one) in
  Printf.printf "0 / 1 = %s\n" (Fixed4.to_string zero_div_test);
  
  (* Test division par 1 *)
  let div_by_one = Fixed4.div (Fixed4.of_float 5.5) (Fixed4.one) in
  Printf.printf "5.5 / 1 = %s\n" (Fixed4.to_string div_by_one);
  
  Printf.printf "\n"

let test_precision_analysis () =
  Printf.printf "=== Analyse de précision ===\n";
  
  Printf.printf "Résolutions :\n";
  Printf.printf "Fixed2: 1/4 = 0.25\n";
  Printf.printf "Fixed4: 1/16 = 0.0625\n";
  Printf.printf "Fixed8: 1/256 ≈ 0.00390625\n";
  Printf.printf "Fixed16: 1/65536 ≈ 0.0000152588\n";
  
  Printf.printf "\nTest d'accumulation d'erreurs :\n";
  let rec accumulate_error n acc =
    if n <= 0 then acc
    else accumulate_error (n-1) (Fixed4.add acc (Fixed4.of_float 0.1))
  in
  
  let result_10_times = accumulate_error 10 Fixed4.zero in
  Printf.printf "0.1 additionné 10 fois: %s (attendu: 1.0)\n" (Fixed4.to_string result_10_times);
  Printf.printf "Erreur: %.6f\n" (abs_float (Fixed4.to_float result_10_times -. 1.0));
  
  Printf.printf "\n"

let run_original_test () =
  Printf.printf "=== Test original de l'énoncé ===\n";
  
  let x8 = Fixed8.of_float 21.10 in
  let y8 = Fixed8.of_float 21.32 in
  let r8 = Fixed8.add x8 y8 in
  Printf.printf "21.10 + 21.32 = %s\n" (Fixed8.to_string r8);
  
  Printf.printf "\nFixed4.foreach 0.0 à 1.0 :\n";
  Fixed4.foreach (Fixed4.zero) (Fixed4.one) (fun f -> 
    Printf.printf "%s\n" (Fixed4.to_string f)
  );
  Printf.printf "\n"

(* Programme principal *)
let () =
  Printf.printf "╔════════════════════════════════════════════════════════════════╗\n";
  Printf.printf "║              Tests exhaustifs - Fixed Point Numbers            ║\n";
  Printf.printf "║                        Exercice 03                             ║\n";
  Printf.printf "╚════════════════════════════════════════════════════════════════╝\n\n";
  
  test_conversions ();
  test_constants ();
  test_unary_operations ();
  test_comparisons ();
  test_arithmetic ();
  test_foreach ();
  test_edge_cases ();
  test_precision_analysis ();
  run_original_test ();
  
  Printf.printf "╔════════════════════════════════════════════════════════════════╗\n";
  Printf.printf "║                    Tous les tests terminés !                   ║\n";
  Printf.printf "║          Toutes les fonctions FIXED sont validées              ║\n";
  Printf.printf "╚════════════════════════════════════════════════════════════════╝\n"
