(* Test spécifique de la fonction compare *)

let test_compare_detailed () =
  print_endline "=== Test détaillé de la fonction compare ===";
  
  (* Test comparaison par valeur *)
  let c2s = Card.newCard Card.Value.T2 Card.Color.Spade in
  let c3s = Card.newCard Card.Value.T3 Card.Color.Spade in
  let cjs = Card.newCard Card.Value.Jack Card.Color.Spade in
  let cas = Card.newCard Card.Value.As Card.Color.Spade in
  
  Printf.printf "2S vs 3S: %d (doit être -1)\n" (Card.compare c2s c3s);
  Printf.printf "3S vs 2S: %d (doit être 1)\n" (Card.compare c3s c2s);
  Printf.printf "JS vs AS: %d (doit être -1)\n" (Card.compare cjs cas);
  
  (* Test comparaison par couleur quand même valeur *)
  let c7s = Card.newCard Card.Value.T7 Card.Color.Spade in
  let c7h = Card.newCard Card.Value.T7 Card.Color.Heart in
  let c7d = Card.newCard Card.Value.T7 Card.Color.Diamond in
  let c7c = Card.newCard Card.Value.T7 Card.Color.Club in
  
  Printf.printf "7S vs 7H: %d (Spade < Heart)\n" (Card.compare c7s c7h);
  Printf.printf "7H vs 7D: %d (Heart < Diamond)\n" (Card.compare c7h c7d);
  Printf.printf "7D vs 7C: %d (Diamond < Club)\n" (Card.compare c7d c7c);
  Printf.printf "7C vs 7S: %d (Club > Spade)\n" (Card.compare c7c c7s);
  
  (* Test égalité *)
  let c5s1 = Card.newCard Card.Value.T5 Card.Color.Spade in
  let c5s2 = Card.newCard Card.Value.T5 Card.Color.Spade in
  Printf.printf "5S vs 5S: %d (doit être 0)\n" (Card.compare c5s1 c5s2);
  
  print_endline ""

let () = test_compare_detailed ()
