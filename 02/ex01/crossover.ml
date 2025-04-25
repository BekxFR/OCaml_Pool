let crossover lst1 lst2 =
	match (lst1, lst2) with
	| ([], []) | (_, []) | ([], _) -> []
	| _ -> print_endline "No Empty List";;

let () =
	let lst1 = [1; 1; 1; 2] in
	crossover lst1 [];;