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
	let point_a = [| 1.0; 2.0; 3.0 |] in
	let point_b = [| 4.0; 6.0; 3.0 |] in
	let result = eu_dist point_a point_b in
	Printf.printf "result = %.2f\n" result