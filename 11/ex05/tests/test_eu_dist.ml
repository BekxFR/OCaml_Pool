let eu_dist (a : float array) (b : float array) =
	let final_result = ref 0.0 in
	let rec loop_diff_carre = function
	| x when x < (Array.length a) -> 
		let diff = a.(x) -. b.(x) in
		let carre = diff ** 2.0 in
		final_result := !final_result +. carre;
		loop_diff_carre (x + 1)
	| _ -> ()
	in
	loop_diff_carre 0;
	sqrt !final_result

let () =
	Printf.printf "=== Tests de la fonction eu_dist ===\n\n";
	
	(* Test 1: points donnés dans l'exercice *)
	(* Calcul manuel: √[(1-4)² + (2-6)² + (3-3)²] = √[9 + 16 + 0] = √25 = 5 *)
	let result1 = eu_dist [| 1.0; 2.0; 3.0 |] [| 4.0; 6.0; 3.0 |] in
	Printf.printf "Test 1: (1,2,3) et (4,6,3) = %.2f (attendu: 5.00) %s\n" 
		result1 (if abs_float (result1 -. 5.0) < 0.01 then "✓" else "✗");
	
	(* Test 2: même point (distance = 0) *)
	let result2 = eu_dist [|1.0; 2.0|] [|1.0; 2.0|] in
	Printf.printf "Test 2: même point = %.2f (attendu: 0.00) %s\n" 
		result2 (if abs_float result2 < 0.01 then "✓" else "✗");
	
	(* Test 3: pythagore classique (3,4,5) *)
	let result3 = eu_dist [|0.0; 0.0|] [|3.0; 4.0|] in
	Printf.printf "Test 3: (0,0) et (3,4) = %.2f (attendu: 5.00) %s\n" 
		result3 (if abs_float (result3 -. 5.0) < 0.01 then "✓" else "✗");
	
	(* Test 4: 1 dimension *)
	let result4 = eu_dist [|5.0|] [|2.0|] in
	Printf.printf "Test 4: 1D (5) et (2) = %.2f (attendu: 3.00) %s\n" 
		result4 (if abs_float (result4 -. 3.0) < 0.01 then "✓" else "✗");
	
	(* Test 5: distance négative (doit être positive) *)
	let result5 = eu_dist [|0.0|] [|10.0|] in
	Printf.printf "Test 5: (0) et (10) = %.2f (attendu: 10.00) %s\n" 
		result5 (if abs_float (result5 -. 10.0) < 0.01 then "✓" else "✗");
	
	Printf.printf "\n=== Fin des tests ===\n"
