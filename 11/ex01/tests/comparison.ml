(* Comparaison ft_ref vs ref classique *)

(* Notre implémentation ft_ref *)
type 'a ft_ref = { mutable contents : 'a }
let return a = { contents = a }
let get ft_ref = ft_ref.contents
let set ft_ref value = ft_ref.contents <- value
let bind ft_ref f = f (get ft_ref)

let () =
  print_endline "=== Comparaison ft_ref vs ref classique ===\n";
  
  (* Fonctions de transformation *)
  let triple x = x * 3 in
  let add_five x = x + 5 in
  
  (* Fonctions qui retournent des ft_ref (pour bind) *)
  let ft_triple x = return (x * 3) in
  let ft_add_five x = return (x + 5) in
  
  print_endline "--- Approche ft_ref avec bind ---";
  let y = return 5 in
  Printf.printf "y initial: %d\n" (get y);
  
  let y_tripled = bind y ft_triple in
  Printf.printf "y après bind triple: %d\n" (get y_tripled);
  
  let y_plus_five = bind y ft_add_five in
  Printf.printf "y après bind +5: %d\n" (get y_plus_five);
  
  print_endline "\n--- Approche ref classique (équivalent) ---";
  let x = ref 5 in
  Printf.printf "x initial: %d\n" !x;
  
  (* Pas de bind avec ref, on fait manuellement *)
  let x_tripled = triple !x in
  Printf.printf "x après function triple: %d\n" x_tripled;
  
  let x_plus_five = add_five !x in
  Printf.printf "x après function +5: %d\n" x_plus_five;
  
  print_endline "\n--- Chaînage d'opérations ---";
  
  (* Avec ft_ref : élégant avec bind *)
  let chained_ft = bind (return 10) (fun x -> 
    bind (ft_triple x) (fun y ->
    ft_add_five y)) in
  Printf.printf "ft_ref chaîné (10 * 3 + 5): %d\n" (get chained_ft);
  
  (* Avec ref classique : plus verbeux *)
  let temp = ref 10 in
  let step1 = triple !temp in
  temp := step1;
  let step2 = add_five !temp in
  temp := step2;
  Printf.printf "ref classique chaîné (10 * 3 + 5): %d\n" !temp;
  
  print_endline "\n--- Différences clés ---";
  print_endline "• ft_ref avec bind : composition fonctionnelle élégante";
  print_endline "• ref classique : étapes manuelles, plus impérative";
  print_endline "• bind cache la gestion des références";
  print_endline "• ref nécessite ! et := explicites"
