open Param

(* Fonctions utilitaires *)
let print_int_try t =
  match t with
  | Try.Success v -> Printf.printf "Success(%d)\n" v
  | Try.Failure e -> Printf.printf "Failure(%s)\n" (Printexc.to_string e)

let print_string_try t =
  match t with
  | Try.Success v -> Printf.printf "Success(\"%s\")\n" v
  | Try.Failure e -> Printf.printf "Failure(%s)\n" (Printexc.to_string e)

let separator msg =
  Printf.printf "\n=== %s ===\n" msg

(* Test 1: return - Créer un Success *)
let test_return () =
  separator "Test 1: return";
  let t1 = Try.return 42 in
  print_endline "Try.return 42 =";
  print_int_try t1;
  
  let t2 = Try.return "hello" in
  print_endline "Try.return \"hello\" =";
  print_string_try t2

(* Test 2: bind - Appliquer des fonctions *)
let test_bind () =
  separator "Test 2: bind";
  
  (* Bind avec succès *)
  print_endline "Cas 1: Success -> fonction qui retourne Success";
  let t1 = Try.return 10 in
  let t2 = Try.bind t1 (fun x -> Try.return (x * 2)) in
  Printf.printf "bind (Success 10) (*2) = ";
  print_int_try t2;
  
  (* Bind avec Failure initial *)
  print_endline "\nCas 2: Failure -> fonction (pas appliquée)";
  let t3 = Try.Failure Division_by_zero in
  let t4 = Try.bind t3 (fun x -> Try.return (x * 2)) in
  Printf.printf "bind (Failure) (*2) = ";
  print_int_try t4;
  
  (* Bind qui capture une exception *)
  print_endline "\nCas 3: Success -> fonction qui lève une exception";
  let risky_divide x = 
    if x = 0 then raise Division_by_zero
    else Try.return (100 / x)
  in
  let t5 = Try.return 0 in
  let t6 = Try.bind t5 risky_divide in
  Printf.printf "bind (Success 0) (100/x) = ";
  print_int_try t6;
  
  (* Bind qui réussit *)
  print_endline "\nCas 4: Success -> fonction qui réussit";
  let t7 = Try.return 5 in
  let t8 = Try.bind t7 risky_divide in
  Printf.printf "bind (Success 5) (100/x) = ";
  print_int_try t8;
  
  (* Chaînage de bind *)
  print_endline "\nCas 5: Chaînage de plusieurs bind";
  let result = 
    Try.return 10
    |> (fun m -> Try.bind m (fun x -> Try.return (x + 5)))
    |> (fun m -> Try.bind m (fun x -> Try.return (x * 2)))
    |> (fun m -> Try.bind m (fun x -> Try.return (x - 10)))
  in
  Printf.printf "10 +5 *2 -10 = ";
  print_int_try result

(* Test 3: recover - Récupérer après erreur *)
let test_recover () =
  separator "Test 3: recover";
  
  (* Recover sur Success (pas d'effet) *)
  print_endline "Cas 1: recover sur Success (fonction non appelée)";
  let t1 = Try.return 42 in
  let t2 = Try.recover t1 (fun _ -> Try.return 0) in
  Printf.printf "recover (Success 42) = ";
  print_int_try t2;
  
  (* Recover sur Failure (récupération) *)
  print_endline "\nCas 2: recover sur Failure (récupération)";
  let t3 = Try.Failure Division_by_zero in
  let t4 = Try.recover t3 (fun e -> 
    Printf.printf "  Récupération de l'erreur: %s\n" (Printexc.to_string e);
    Try.return (-1)
  ) in
  Printf.printf "recover (Failure) avec valeur par défaut = ";
  print_int_try t4;
  
  (* Recover qui échoue aussi *)
  print_endline "\nCas 3: recover qui retourne aussi une Failure";
  let t5 = Try.Failure Not_found in
  let t6 = Try.recover t5 (fun e -> 
    Printf.printf "  Première erreur: %s\n" (Printexc.to_string e);
    Try.Failure (Invalid_argument "Cannot recover")
  ) in
  Printf.printf "recover (Failure) -> Failure = ";
  print_int_try t6

(* Test 4: filter - Filtrer selon prédicat *)
let test_filter () =
  separator "Test 4: filter";
  
  (* Filter avec prédicat satisfait *)
  print_endline "Cas 1: Success avec prédicat satisfait";
  let t1 = Try.return 42 in
  let t2 = Try.filter t1 (fun x -> x > 0) in
  Printf.printf "filter (Success 42) (>0) = ";
  print_int_try t2;
  
  (* Filter avec prédicat non satisfait *)
  print_endline "\nCas 2: Success avec prédicat non satisfait";
  let t3 = Try.return (-5) in
  let t4 = Try.filter t3 (fun x -> x > 0) in
  Printf.printf "filter (Success -5) (>0) = ";
  print_int_try t4;
  
  (* Filter sur Failure *)
  print_endline "\nCas 3: filter sur Failure (pas d'effet)";
  let t5 = Try.Failure Division_by_zero in
  let t6 = Try.filter t5 (fun x -> x > 0) in
  Printf.printf "filter (Failure) (>0) = ";
  print_int_try t6;
  
  (* Chaînage avec filter *)
  print_endline "\nCas 4: Chaînage bind + filter";
  let result =
    Try.return 100
    |> (fun m -> Try.bind m (fun x -> Try.return (x / 2)))
    |> (fun m -> Try.filter m (fun x -> x >= 50))
    |> (fun m -> Try.bind m (fun x -> Try.return (x * 2)))
  in
  Printf.printf "100 /2 filter(>=50) *2 = ";
  print_int_try result;
  
  let result2 =
    Try.return 100
    |> (fun m -> Try.bind m (fun x -> Try.return (x / 4)))
    |> (fun m -> Try.filter m (fun x -> x >= 50))
    |> (fun m -> Try.bind m (fun x -> Try.return (x * 2)))
  in
  Printf.printf "100 /4 filter(>=50) *2 = ";
  print_int_try result2

(* Test 5: flatten - Aplatir Try imbriqué *)
let test_flatten () =
  separator "Test 5: flatten";
  
  (* Success of Success *)
  print_endline "Cas 1: Success of Success";
  let t1 = Try.Success (Try.Success 42) in
  let t2 = Try.flatten t1 in
  Printf.printf "flatten (Success (Success 42)) = ";
  print_int_try t2;
  
  (* Success of Failure (devient Failure) *)
  print_endline "\nCas 2: Success of Failure (devient Failure)";
  let t3 = Try.Success (Try.Failure Division_by_zero) in
  let t4 = Try.flatten t3 in
  Printf.printf "flatten (Success (Failure)) = ";
  print_int_try t4;
  
  (* Failure of ... *)
  print_endline "\nCas 3: Failure (reste Failure)";
  let t5 = Try.Failure Not_found in
  let t6 = Try.flatten t5 in
  Printf.printf "flatten (Failure) = ";
  print_int_try t6;
  
  (* Exemple pratique *)
  print_endline "\nCas 4: Utilisation pratique avec bind";
  let parse_int s =
    try Try.return (int_of_string s)
    with _ -> Try.Failure (Invalid_argument "Not a number")
  in
  
  let nested = Try.return "42" in
  let double_nested = Try.bind nested (fun s -> Try.return (parse_int s)) in
  Printf.printf "Type double imbriqué: ";
  (* double_nested a le type int Try.t Try.t *)
  match double_nested with
  | Try.Success inner -> 
      (match inner with
       | Try.Success v -> Printf.printf "Success (Success %d)\n" v
       | Try.Failure e -> Printf.printf "Success (Failure %s)\n" (Printexc.to_string e))
  | Try.Failure e -> Printf.printf "Failure %s\n" (Printexc.to_string e);
  
  Printf.printf "Après flatten: ";
  print_int_try (Try.flatten double_nested)

(* Test 6: Scénario complet - Division sécurisée *)
let test_scenario_complet () =
  separator "Test 6: Scénario complet - Calculatrice sécurisée";
  
  (* Division sécurisée *)
  let safe_divide a b =
    if b = 0 then 
      Try.Failure Division_by_zero
    else 
      Try.return (a / b)
  in
  
  (* Racine carrée sécurisée *)
  let safe_sqrt x =
    if x < 0 then
      Try.Failure (Invalid_argument "Negative number")
    else
      Try.return (int_of_float (sqrt (float_of_int x)))
  in
  
  (* Test 1: Calcul réussi *)
  print_endline "Calcul: sqrt(100 / 4) * 2";
  let calc1 =
    safe_divide 100 4
    |> (fun m -> Try.bind m safe_sqrt)
    |> (fun m -> Try.bind m (fun x -> Try.return (x * 2)))
  in
  print_int_try calc1;
  
  (* Test 2: Division par zéro *)
  print_endline "\nCalcul: sqrt(100 / 0) * 2";
  let calc2 =
    safe_divide 100 0
    |> (fun m -> Try.bind m safe_sqrt)
    |> (fun m -> Try.bind m (fun x -> Try.return (x * 2)))
  in
  print_int_try calc2;
  
  (* Test 3: Racine négative *)
  print_endline "\nCalcul: sqrt(100 / (-5)) * 2";
  let calc3 =
    safe_divide 100 (-5)
    |> (fun m -> Try.bind m safe_sqrt)
    |> (fun m -> Try.bind m (fun x -> Try.return (x * 2)))
  in
  print_int_try calc3;
  
  (* Test 4: Avec récupération *)
  print_endline "\nCalcul avec récupération: sqrt(100 / 0) avec valeur par défaut";
  let calc4 =
    safe_divide 100 0
    |> (fun m -> Try.recover m (fun _ -> Try.return 25))
    |> (fun m -> Try.bind m safe_sqrt)
    |> (fun m -> Try.bind m (fun x -> Try.return (x * 2)))
  in
  print_int_try calc4;
  
  (* Test 5: Avec filter *)
  print_endline "\nCalcul avec filter: sqrt(100 / 4) >= 10";
  let calc5 =
    safe_divide 100 4
    |> (fun m -> Try.bind m safe_sqrt)
    |> (fun m -> Try.filter m (fun x -> x >= 10))
  in
  print_int_try calc5;
  
  print_endline "\nCalcul avec filter: sqrt(100 / 4) >= 3";
  let calc6 =
    safe_divide 100 4
    |> (fun m -> Try.bind m safe_sqrt)
    |> (fun m -> Try.filter m (fun x -> x >= 3))
  in
  print_int_try calc6

let () =
  print_endline "=== Tests du module Try (Monade d'exceptions) ===";
  
  test_return ();
  test_bind ();
  test_recover ();
  test_filter ();
  test_flatten ();
  test_scenario_complet ();
  
  print_endline "\n=== Tous les tests terminés ! ===";
