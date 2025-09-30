(* Test avec Random.self_init () *)

let test_with_init () =
  Random.self_init (); (* Initialisation avec graine aléatoire *)
  print_endline "=== Test AVEC Random.self_init () ===";
  let deck1 = Deck.newDeck () in
  let deck2 = Deck.newDeck () in
  
  let list1 = Deck.toStringList deck1 in
  let list2 = Deck.toStringList deck2 in
  
  let rec take n = function
    | [] -> []
    | h :: t -> if n <= 0 then [] else h :: (take (n-1) t) in
  
  Printf.printf "Deck 1: %s\n" (String.concat ", " (take 5 list1));
  Printf.printf "Deck 2: %s\n" (String.concat ", " (take 5 list2));
  Printf.printf "Identiques: %b\n" (list1 = list2);
  print_endline ""

let () = test_with_init ()
