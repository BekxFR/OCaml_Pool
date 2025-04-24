let ft_sum (f: int -> float) (l: int) (u: int): float =
	let rec do_sum l acc =
		if l > u then acc
		else do_sum (l + 1) (f l +. acc)
	in
	if l > u then nan
	else do_sum l 0.0

let () =
	(* Exemple 1 : Somme des carrés des entiers de 1 à 10 *)
	let f1 i = float_of_int (i * i) in
	print_endline ("Somme des carrés de 1 à 10 : " ^ string_of_float (ft_sum f1 1 10));

	(* Exemple 2 : Somme des entiers de 1 à 5 *)
	let f2 i = float_of_int i in
	print_endline ("Somme des entiers de 1 à 5 : " ^ string_of_float (ft_sum f2 1 5));

	(* Exemple 3 : Somme des inverses des entiers de 1 à 4 *)
	let f3 i = 1.0 /. float_of_int i in
	print_endline ("Somme des inverses de 1 à 4 : " ^ string_of_float (ft_sum f3 1 4));

	(* Exemple 4 : Cas où la borne inférieure est supérieure à la borne supérieure *)
	print_endline ("Somme avec l > u (5 à 1) : " ^ string_of_float (ft_sum f1 5 1));

	(* Exemple 5 : Somme des cubes des entiers de 0 à 3 *)
	let f5 i = float_of_int (i * i * i) in
	print_endline ("Somme des cubes de 0 à 3 : " ^ string_of_float (ft_sum f5 0 3));