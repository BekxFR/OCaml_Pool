let () = Random.self_init ()

let test_deck_creation () =
  print_endline "=== Test de création de deck ===";
  let deck1 = Deck.newDeck () in
  let deck2 = Deck.newDeck () in
  
  let list1 = Deck.toStringList deck1 in
  let list2 = Deck.toStringList deck2 in
  
  Printf.printf "Taille du deck 1: %d cartes\n" (List.length list1);
  Printf.printf "Taille du deck 2: %d cartes\n" (List.length list2);
  
  let different = list1 <> list2 in
  Printf.printf "Les deux decks ont un ordre différent: %b\n" different;
  
  let rec take n = function
    | [] -> []
    | h :: t -> if n <= 0 then [] else h :: (take (n-1) t) in
  
  Printf.printf "5 premières cartes du deck 1: ";
  List.iter (function card -> Printf.printf "%s " card) (take 5 list1);
  print_newline ();
  Printf.printf "5 premières cartes du deck 2: ";
  List.iter (function card -> Printf.printf "%s " card) (take 5 list2);
  print_newline ()

let test_string_conversions () =
  print_endline "\n=== Test des conversions en chaînes ===";
  let deck = Deck.newDeck () in
  
  let string_list = Deck.toStringList deck in
  let verbose_list = Deck.toStringListVerbose deck in
  
  let rec take n = function
    | [] -> []
    | h :: t -> if n <= 0 then [] else h :: (take (n-1) t) in
  
  let first3_normal = take 3 string_list in
  let first3_verbose = take 3 verbose_list in
  
  Printf.printf "Format normal: ";
   List.iter (function card -> Printf.printf "%s " card) first3_normal;
  print_newline ();
  Printf.printf "Format verbose: ";
  List.iter (function card -> Printf.printf "%s " card) first3_verbose;
  print_newline ()

let test_draw_card () =
  print_endline "\n=== Test de tirage de cartes ===";
  let deck = Deck.newDeck () in
  
  let (card1, deck1) = Deck.drawCard deck in
  let (card2, deck2) = Deck.drawCard deck1 in
  let (card3, deck3) = Deck.drawCard deck2 in
  
  Printf.printf "Carte 1 tirée: %s\n" (Deck.Card.toString card1);
  Printf.printf "Carte 2 tirée: %s\n" (Deck.Card.toString card2);
  Printf.printf "Carte 3 tirée: %s\n" (Deck.Card.toString card3);
  
  Printf.printf "Taille du deck initial: %d\n" (List.length (Deck.toStringList deck));
  Printf.printf "Taille après 1 tirage: %d\n" (List.length (Deck.toStringList deck1));
  Printf.printf "Taille après 2 tirages: %d\n" (List.length (Deck.toStringList deck2));
  Printf.printf "Taille après 3 tirages: %d\n" (List.length (Deck.toStringList deck3));
  print_endline ""

let test_empty_deck () =
  print_endline "=== Test de deck vide (simulation) ===";
  let deck = Deck.newDeck () in
  
  let rec exhaust_deck deck =
    try
      let (_, remaining) = Deck.drawCard deck in
      exhaust_deck remaining
    with
    | Failure _ -> deck
  in
  
  let empty_deck = exhaust_deck deck in
  
  (try
    let _ = Deck.drawCard empty_deck in
    print_endline "ERREUR: drawCard sur deck vide n'a pas levé d'exception"
  with
  | Failure msg -> Printf.printf "OK: drawCard sur deck vide -> %s\n" msg);
  print_endline ""

let test_card_modules () =
  print_endline "=== Test des modules Card intégrés ===";
  
  Printf.printf "Couleurs disponibles: %s\n"
    (String.concat ", " (List.map Deck.Card.Color.toString Deck.Card.Color.all));
  Printf.printf "Valeurs disponibles: %s\n"
    (String.concat ", " (List.map Deck.Card.Value.toString Deck.Card.Value.all));
  
  let card = Deck.Card.newCard Deck.Card.Value.King Deck.Card.Color.Spade in
  Printf.printf "Carte créée: %s\n" (Deck.Card.toString card);
  Printf.printf "Carte créée (verbose): %s\n" (Deck.Card.toStringVerbose card);
  
  Printf.printf "La carte est un carrot: %b\n" (Deck.Card.isDiamond card);
  Printf.printf "La carte est un pique: %b\n" (Deck.Card.isSpade card);
  print_endline ""

let test_deck_exhaustion () =
  print_endline "=== Test d'épuisement complet du deck ===";
  let deck = Deck.newDeck () in
  
  let rec draw_all_cards deck count =
    try
      let (card, remaining_deck) = Deck.drawCard deck in
      Printf.printf "Carte %d: %s\n" count (Deck.Card.toString card);
      draw_all_cards remaining_deck (count + 1)
    with
    | Failure _ -> Printf.printf "Deck épuisé après %d cartes\n" (count - 1)
  in
  draw_all_cards deck 1;
  print_endline ""

let () =
  print_endline "=== Tests du module Deck ===\n";
  test_deck_creation ();
  test_string_conversions ();
  test_draw_card ();
  test_empty_deck ();
  test_card_modules ();
  test_deck_exhaustion ();
  print_endline "=== Fin des tests ==="
