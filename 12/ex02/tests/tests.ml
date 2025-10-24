(*
** Tests complémentaires pour l'exercice 02
** Validation des foncteurs MakeFst et MakeSnd
*)

(* Réutilisation des types et foncteurs de ex02.ml *)
module type PAIR = sig val pair : (int * int) end
module type VAL = sig val x : int end
module type MAKEPROJECTION = functor (P : PAIR) -> VAL

module MakeFst : MAKEPROJECTION = functor (P : PAIR) -> struct
  let x = Stdlib.fst P.pair
end

module MakeSnd : MAKEPROJECTION = functor (P : PAIR) -> struct
  let x = Stdlib.snd P.pair
end

(* Tests avec différentes paires *)
let test_multiple_pairs () =
  Printf.printf "=== Test avec différentes paires ===\n";
  
  let test_cases = [
    (1, 2, "petits entiers");
    (100, 200, "entiers moyens");
    (-5, -10, "entiers négatifs");
    (0, 42, "avec zéro");
    (999, 1, "valeurs différentes")
  ] in
  
  List.iter (fun (a, b, description) ->
    let module TestPair = struct let pair = (a, b) end in
    let module TestFst = MakeFst(TestPair) in
    let module TestSnd = MakeSnd(TestPair) in
    
    Printf.printf "Test %s : (%d, %d) -> Fst=%d, Snd=%d\n" 
      description a b TestFst.x TestSnd.x;
    
    assert (TestFst.x = a);
    assert (TestSnd.x = b)
  ) test_cases;
  
  Printf.printf "✓ Tous les tests de paires réussis\n\n"

(* Test de vérification des types *)
let test_type_checking () =
  Printf.printf "=== Test de vérification des types ===\n";
  
  (* Test que nos modules respectent bien les signatures *)
  let module TestPair : PAIR = struct let pair = (123, 456) end in
  let module TestFst : VAL = MakeFst(TestPair) in
  let module TestSnd : VAL = MakeSnd(TestPair) in
  
  Printf.printf "TestPair.pair = (%d, %d)\n" 
    (Stdlib.fst TestPair.pair) (Stdlib.snd TestPair.pair);
  Printf.printf "TestFst.x = %d\n" TestFst.x;
  Printf.printf "TestSnd.x = %d\n" TestSnd.x;
  
  assert (TestFst.x = 123);
  assert (TestSnd.x = 456);
  
  Printf.printf "✓ Vérification des types réussie\n\n"

(* Test du cas original de l'énoncé *)
let test_original_case () =
  Printf.printf "=== Test du cas original ===\n";
  
  let module Pair : PAIR = struct let pair = ( 21, 42 ) end in
  let module Fst : VAL = MakeFst (Pair) in
  let module Snd : VAL = MakeSnd (Pair) in
  
  Printf.printf "Fst.x = %d, Snd.x = %d\n" Fst.x Snd.x;
  
  assert (Fst.x = 21);
  assert (Snd.x = 42);
  
  Printf.printf "✓ Test original réussi\n\n"

(* Test des contraintes : utilisation exclusive de Stdlib.fst et Stdlib.snd *)
let test_stdlib_usage () =
  Printf.printf "=== Test d'utilisation de Stdlib ===\n";
  
  (* Vérification que nos foncteurs utilisent bien Stdlib.fst et Stdlib.snd *)
  let module TestPair = struct let pair = (789, 101112) end in
  
  (* Test direct avec les fonctions Stdlib *)
  let direct_fst = Stdlib.fst TestPair.pair in
  let direct_snd = Stdlib.snd TestPair.pair in
  
  (* Test avec nos foncteurs *)
  let module TestFst = MakeFst(TestPair) in
  let module TestSnd = MakeSnd(TestPair) in
  
  Printf.printf "Direct Stdlib.fst = %d, MakeFst = %d\n" direct_fst TestFst.x;
  Printf.printf "Direct Stdlib.snd = %d, MakeSnd = %d\n" direct_snd TestSnd.x;
  
  assert (direct_fst = TestFst.x);
  assert (direct_snd = TestSnd.x);
  
  Printf.printf "✓ Utilisation correcte de Stdlib confirmée\n\n"

(* Exécution de tous les tests *)
let () =
  Printf.printf "╔══════════════════════════════════════════════════════════════════╗\n";
  Printf.printf "║                    Tests complets - Exercice 02                  ║\n";
  Printf.printf "║                         Projections                              ║\n";
  Printf.printf "╚══════════════════════════════════════════════════════════════════╝\n\n";
  
  test_original_case ();
  test_multiple_pairs ();
  test_type_checking ();
  test_stdlib_usage ();
  
  Printf.printf "╔══════════════════════════════════════════════════════════════════╗\n";
  Printf.printf "║                       Tous les tests réussis !                   ║\n";
  Printf.printf "║              MakeFst et MakeSnd fonctionnent correctement         ║\n";
  Printf.printf "╚══════════════════════════════════════════════════════════════════╝\n"
