(* Retourne la liste des éléments communs entre lst1 et lst2 *)
let rec crossover lst1 lst2 =
	match (lst1, lst2) with
	| (_, []) | ([], _) -> []
	| x :: xs, _ ->
		let rest = crossover xs lst2 in
		let rec checked x = function
			| [] -> false
			| y :: ys -> if x = y then true else checked x ys
		in
		if checked x lst2 then x :: rest
		else rest

let () =
	let lst1 = [1; 1; 1; 2] in
	let lst2 = [1; 2; 3] in
	let result = crossover lst1 lst2 in
	Printf.printf "crossover [1; 1; 1; 2] [1; 2; 3] = [%s]\n"
		(String.concat "; " (List.map string_of_int result));

	let lst3 = ["a"; "b"; "c"] in
	let lst4 = ["b"; "d"; "a"] in
	let result2 = crossover lst3 lst4 in
	Printf.printf "crossover [\"a\"; \"b\"; \"c\"] [\"b\"; \"d\"; \"a\"] = [%s]\n"
		(String.concat "; " result2);

	let lst5 = ["z"; "x"; "o"] in
	let lst6 = ["b"; "d"; "a"] in
	let result3 = crossover lst5 lst6 in
	Printf.printf "crossover [\"z\"; \"x\"; \"o\"] [\"b\"; \"d\"; \"a\"] = [%s]\n"
		(String.concat "; " result3);

	let result3 = crossover lst1 [] in
	Printf.printf "crossover [1; 1; 1; 2] [] = [%s]\n"
		(String.concat "; " (List.map string_of_int result3))