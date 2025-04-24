let iter f x n =
	let rec aux x n =
		if n = 0 then x
		else aux (f x) (n - 1)
	in
	if n < 0 then -1
	else aux x n

(*
let () =
	let multiplyX x = x * x in
	let multiplyTwo x = x * 2 in
	let addOne x = x + 1 in

	print_endline (string_of_int(iter multiplyX 2 4)); (* 2^2^2^2^2 *)
	print_endline (string_of_int(iter multiplyTwo 2 4)); (* 2 * 2 * 2 * 2 * 2 *)
	print_endline (string_of_int(iter addOne 0 5)); (* 0 + 1 + 1 + 1 + 1 + 1 *)
	print_endline (string_of_int(iter addOne 10 0)); (* n=0, doit return x *)
	print_endline (string_of_int(iter multiplyX 2 4)) (* n<0, doit return -1 *)
*)

let () =
	let test_iter () =
		let multiplyX x = x * x in
		let multiplyTwo x = x * 2 in
		let addOne x = x + 1 in

		(* Test cases *)
		let tests = [
			("multiplyX, x=2, n=4", iter multiplyX 2 4, 65536); (* 2^2^2^2^2 *)
			("multiplyTwo, x=2, n=4", iter multiplyTwo 2 4, 32); (* 2 * 2 * 2 * 2 * 2 *)
			("addOne, x=0, n=5", iter addOne 0 5, 5); (* 0 + 1 + 1 + 1 + 1 + 1 *)
			("addOne, x=10, n=0", iter addOne 10 0, 10); (* n=0, should return x *)
			("multiplyX, x=3, n=-1", iter multiplyX 3 (-1), -1); (* n<0, should return -1 *)
		] in

		(* Run tests *)
		List.iter (fun (desc, result, expected) ->
			Printf.printf "Test: %s\n" desc;
			Printf.printf "Result: %d, Expected: %d\n" result expected;
			if result = expected then
				Printf.printf "Status: PASS\n\n"
			else
				Printf.printf "Status: FAIL\n\n"
		) tests
	in

	test_iter ()

(* 
La fonction iter est un concept fondamental en mathématiques et en informatique, connu sous le nom d'itération de fonction ou composition répétée.
Elle applique une fonction f de manière répétée n fois à une valeur initiale x.
Importance en informatique et en mathématiques :
- Fondement de la théorie des systèmes dynamiques : L'itération de fonctions est à la base de l'étude des systèmes dynamiques, qui modélisent comment les systèmes évoluent dans le temps.
- Théorie de la calculabilité : Ce concept est lié à la notion de fonction récursive primitive et joue un rôle dans la théorie de la calculabilité, établissant ce qui peut ou ne peut pas être calculé.
- Programmation fonctionnelle : L'itération de fonction est un pattern fondamental en programmation fonctionnelle, illustrant la puissance de la composition de fonctions.
- Algorithmes d'optimisation : De nombreux algorithmes d'optimisation, comme la méthode de Newton, reposent sur l'itération répétée d'une fonction jusqu'à convergence.
- Fractales et chaos : L'itération de fonctions simples peut produire des comportements complexes et chaotiques, comme dans l'ensemble de Mandelbrot qui est défini par l'itération de la fonction z² + c.
Le nombre d'appels récursifs est exactement n+1, la complexité temporelle est donc O(n).
Comme elle est récursive terminale (tail-recursive), un compilateur comme celui d'OCaml peut optimiser cette récursion en itération, réduisant ainsi la complexité spatiale à O(1).
 *)