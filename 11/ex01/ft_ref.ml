type 'a ft_ref = { mutable contents : 'a }

let return a = { contents = a } (* ref x *)

let get ft_ref = ft_ref.contents (* !r *)

let set ft_ref value = ft_ref.contents <- value (* r := x *)

let bind ft_ref f = f (get ft_ref) 

let () =
	print_endline "##################### Tests de ft_ref ########################\n";
	
	print_endline "###### RETURN, GET, SET ######\n";
	print_endline "### INT ###";
	let a = return 42 in
	Printf.printf "Valeur initiale de a: %d\n" (get a);
	let b = return 24 in
	Printf.printf "Valeur initiale de b: %d\n" (get b);
	set a 100;
	Printf.printf "Après set a 100: %d\n" (get a);
	set b 200;
	Printf.printf "Après set b 200: %d\n\n" (get b);

	print_endline "### STRING ###";
	let name = return "Sophie" in
	Printf.printf "Nom initial: %s\n" (get name);
	set name "Gregoire";
	Printf.printf "Après changement: %s\n\n" (get name);

	print_endline "###### BIND ######";
	let ref_triple a = return (a * 3) in
	let ref_plus_five a = return (a + 5) in
	let y = return 5 in
	Printf.printf "y initial: %d\n" (get y);
	let triple_y = bind y ref_triple in
	Printf.printf "y après bind avec triple: %d\n" (get triple_y);
	let y_plus_five = bind y ref_plus_five in
	Printf.printf "y après bind avec + 5: %d\n" (get y_plus_five);
	let result = bind (return 6) (fun x -> 
		bind (return (x * 6)) (fun y ->
			return (y + 6))) in
	Printf.printf "Bind en chaîne (6 * 6 + 6): %d\n" (get result);
	let counter = return 0 in
	Printf.printf "Compteur initial: %d\n" (get counter);
	let rec loop c =
		if c < 5 then (
			let current = get counter in
			Printf.printf "Compteur dans la boucle: %d\n" current;
			set counter (current + 1);
			loop (c + 1)
		) else (
		let current = get counter in
			Printf.printf "Compteur final: %d\n" current
		)
	in
	loop 0;

	(* print_endline "\n##################### Tests de ref ########################";
	let c = ref 42 in
	Printf.printf "Valeur initiale de c (ref standard): %d\n" !c;
	c := 300;
	Printf.printf "Après set c 300 (ref standard): %d\n" !c;
	let refname = ref "Robert" in
	Printf.printf "refname initial : %s\n" !refname;
	refname := "Alice";
	Printf.printf "Après changement: %s\n" !refname;
	let classical_triple c = c * 3 in
	let x = ref 5 in
	Printf.printf "x initial (ref classique): %d\n" !x;
	let classical_x = classical_triple !x in
	Printf.printf "x après function classique triple: %d\n" classical_x;

	Printf.printf "\n=== Comparaison chaînage ===\n";
	(* ft_ref *)
	let chain_result = bind (return 10) (fun x -> 
		bind (return (x * 2)) (fun y ->
		return (y + 3))) in
	Printf.printf "Chaînage ft_ref (10 * 2 + 3): %d\n" (get chain_result);
	(* ref classique *)
	let temp_ref = ref 10 in
	let step1 = !temp_ref * 2 in
	temp_ref := step1;
	let step2 = !temp_ref + 3 in
	temp_ref := step2;
	Printf.printf "Chaînage ref classique (10 * 2 + 3): %d\n" !temp_ref *)
