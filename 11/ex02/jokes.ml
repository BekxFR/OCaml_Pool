Random.self_init ()

let () =
  let jokes = [
    "What’s green and sings underwater? Elvis Parsley!";
    "What do you call a can opener that doesn’t work? A can't opener!";
    "Did you hear about the Italian chef who died? He pasta way.";
    "Did you hear the story about the claustrophobic astronaut? He just needed some space.";
    "What do you call an alligator in a vest? An investigator!";
  ] in
  let x = Random.int (List.length jokes) in
  
  let safe_init_array = Array.init 5 (fun i -> 
    if i < List.length jokes then List.nth jokes i 
    else "No joke in this index"
  ) in
  
  Printf.printf "Random joke: %s\n" (safe_init_array.(x));

  (* safe_init_array.(x) <- "New joke: I threw a boomerang a few years ago. I now live in constant fear.";
  Printf.printf "After modification, %s\n" (safe_init_array.(x));
  Array.set safe_init_array x "New joke: Why is Peter Pan always flying? He neverlands.";
  Printf.printf "After modification, %s\n" (safe_init_array.(x));

  let init_array = Array.init 5 (fun i -> List.nth jokes i) in

  let jokes_array = Array.of_list jokes in
  let from_array = Array.init 5 (fun i -> 
    if i < Array.length jokes_array then jokes_array.(i)
    else "Index trop grand"
    ) in
    
  Printf.printf "Blague aléatoire: %s\n" (List.nth jokes x);
  Printf.printf "init_array.(2): %s\n" (init_array.(2));
  Printf.printf "safe_init_array.(2): %s\n" (safe_init_array.(2));
  Printf.printf "from_array.(4): %s\n" (from_array.(4));
  
  print_endline "\nToutes les blagues avec Array.init:";
  Array.iteri (fun i joke -> Printf.printf "%d: %s\n" i joke) init_array; *)