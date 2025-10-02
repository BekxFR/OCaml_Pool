let test_color () =
  print_endline "=== Tests du module Color ===";
  Printf.printf "All colors: " ;
  List.iter (function card -> Printf.printf "%s " (Card.Color.toString card)) Card.Color.all;
  print_endline "";
  Printf.printf "Verbose: " ;
  List.iter (function card -> Printf.printf "%s " (Card.Color.toStringVerbose card)) Card.Color.all;
  print_endline "\n"

let test_value () =
  try
    print_endline "=== Tests du module Value ===";
    Printf.printf "All values: " ;
    List.iter (function card -> Printf.printf "%s " (Card.Value.toString card)) Card.Value.all;
    print_endline "";
    let card1 = Card.newCard Card.Value.T3 Card.Color.Diamond in
    let card2 = Card.newCard Card.Value.Queen Card.Color.Club in
    let card3 = Card.newCard Card.Value.As Card.Color.Spade in

    Printf.printf "toString T3=%s, Queen=%s, As=%s\n" 
      (Card.Value.toString (Card.getValue card1)) 
      (Card.Value.toString (Card.getValue card2)) 
      (Card.Value.toString (Card.getValue card3));

    Printf.printf "toInt T3=%d, Queen=%d, As=%d\n" 
      (Card.Value.toInt (Card.getValue card1)) 
      (Card.Value.toInt (Card.getValue card2)) 
      (Card.Value.toInt (Card.getValue card3));
    
    (* Test next/previous *)
    Printf.printf "previous T3 = %s, Queen = %s, As = %s\n"
      (Card.Value.toString (Card.Value.previous Card.Value.T3))
      (Card.Value.toString (Card.Value.previous Card.Value.Queen))
      (Card.Value.toString (Card.Value.previous Card.Value.As));
    Printf.printf "next T3 = %s, Queen = %s,"
      (Card.Value.toString (Card.Value.next Card.Value.T3))
      (Card.Value.toString (Card.Value.next Card.Value.Queen));
    Printf.printf " As = %s\n"
      (Card.Value.toString (Card.Value.next Card.Value.As));
  with
  | Invalid_argument msg -> Printf.printf " Erreur lors de previous: %s\n" msg;
  print_endline ""

let test_card () =
  print_endline "=== Tests du module Card ===";
  
  let card1 = Card.newCard Card.Value.T6 Card.Color.Diamond in
  let card2 = Card.newCard Card.Value.Jack Card.Color.Club in
  let card3 = Card.newCard Card.Value.King Card.Color.Spade in
  let card4 = Card.newCard Card.Value.King Card.Color.Heart in
  
  Printf.printf "toString: %s, %s, %s\n" 
    (Card.toString card1) (Card.toString card2) (Card.toString card3);
  
  Printf.printf "toStringVerbose: %s\n" (Card.toStringVerbose card1);
  Printf.printf "toStringVerbose: %s\n" (Card.toStringVerbose card2);
  Printf.printf "toStringVerbose: %s\n" (Card.toStringVerbose card3);
  
  Printf.printf "card1: value=%s, color=%s\n" 
    (Card.Value.toString (Card.getValue card1))
    (Card.Color.toString (Card.getColor card1));
  
  Printf.printf "Card.compare tests:\n";
  Printf.printf "Cards score values : Spades < Hearts < Diamonds < Clubs\n";
  Printf.printf "compare card1 vs card2: %d\n" (Card.compare card1 card2);
  Printf.printf "compare card2 vs card3: %d\n" (Card.compare card2 card3);
  Printf.printf "compare card3 vs card1: %d\n" (Card.compare card3 card1);
  Printf.printf "compare card1 vs card3: %d\n" (Card.compare card1 card3);
  Printf.printf "compare card3 vs card3: %d\n" (Card.compare card3 card3);
  Printf.printf "compare card3 vs card4: %d\n" (Card.compare card3 card4);
  
  let max_card = Card.max card1 card2 in
  let min_card = Card.min card1 card2 in
  Printf.printf "max(%s, %s) = %s\n" 
    (Card.toString card1) (Card.toString card2) (Card.toString max_card);
  Printf.printf "min(%s, %s) = %s\n" 
    (Card.toString card1) (Card.toString card2) (Card.toString min_card);
  let max_card = Card.max card3 card4 in
  let min_card = Card.min card3 card4 in
  Printf.printf "max(%s, %s) = %s\n" 
    (Card.toString card3) (Card.toString card4) (Card.toString max_card);
  Printf.printf "min(%s, %s) = %s\n" 
    (Card.toString card3) (Card.toString card4) (Card.toString min_card);
  
  let best_card = Card.best [card1; card2; card3; card4] in
  Printf.printf "best([%s, %s, %s, %s]) = %s\n" 
    (Card.toString card1) (Card.toString card2) (Card.toString card3) (Card.toString card4)
    (Card.toString best_card);
  
  Printf.printf "%s is Spade: %b\n" (Card.toString card1) (Card.isSpade card1);
  Printf.printf "%s is Club: %b\n" (Card.toString card2) (Card.isClub card2);
  Printf.printf "%s is Diamond: %b\n" (Card.toString card3) (Card.isDiamond card3);
  Printf.printf "%s is Heart: %b\n" (Card.toString card4) (Card.isHeart card4);
  print_endline ""

let test_lists () =
  print_endline "=== Tests des listes de cartes ===";
  Printf.printf "Nombre total de cartes: %d\n" (List.length Card.all);
  Printf.printf "Nombre de coeurs: %d\n" (List.length Card.allHearts);
  let rec take n = function
    | [] -> []
    | h :: t -> if n <= 0 then [] else h :: (take (n-1) t) in
  let take_values = take 10 Card.allHearts in
  Printf.printf "Premières cartes de coeur: ";
  List.iter (function card -> Printf.printf "%s " (Card.toString card)) take_values;
  print_endline "\n"

let test_exceptions () =
  print_endline "=== Tests des exceptions ===";
  
  (* Liste vide *)
  (try
    let _ = Card.best [] in
    print_endline "ERREUR: best([]) n'a pas levé d'exception"
  with
  | Invalid_argument msg -> Printf.printf "OK: best([]) -> %s\n" msg);
  
  (* Value.next avec As *)
  (try
    let _ = Card.Value.next Card.Value.As in
    print_endline "ERREUR: next(As) n'a pas levé d'exception"
  with
  | Invalid_argument msg -> Printf.printf "OK: next(As) -> %s\n" msg);
  
  (* Value.previous avec T2 *)
  (try
    let _ = Card.Value.previous Card.Value.T2 in
    print_endline "ERREUR: previous(T2) n'a pas levé d'exception"
  with
  | Invalid_argument msg -> Printf.printf "OK: previous(T2) -> %s\n" msg)

let () =
  print_endline "########### Tests du module Card ###########\n";
  test_color ();
  test_value ();
  test_card ();
  test_lists ();
  test_exceptions ();
