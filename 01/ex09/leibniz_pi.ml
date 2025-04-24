
let leibniz_pi (delta: float): int =
	let pi: float = 4.0 *. atan 1.0 in
	let ft_parity x =
		if x < 0. then x *. -1.0
		else x
	in
    let leibniz_formula x =
        ((-1.0 ** float_of_int x) /. (2.0 *. float_of_int x +. 1.0))
    in
	let rec find_min_delta x acc =
		let keep = (acc +. (leibniz_formula x)) in
		if ft_parity ((4.0 *. keep) -. pi) <= delta then x + 1
		else find_min_delta (x + 1) (keep)
	in
	if delta < 0.0 then -1
	else find_min_delta 0 0.0


(*
let leibniz_pi2 delta =
    if delta < 0.0 then -1
    else
        let real_pi = 4.0 *. atan 1.0 in
        let rec aux sum sign denominator iterations =
            let current_term = sign /. denominator in
            let new_sum = sum +. current_term in
			(*print_endline ("new_sum  = " ^ string_of_float (new_sum) ^ " delta = " ^ string_of_float delta);*)
            let approx_pi = 4.0 *. new_sum in
			(*print_endline ("approx_pi  = " ^ string_of_float (approx_pi) ^ " result = " ^ string_of_float (abs_float (approx_pi -. real_pi)));*)
			(*print_endline ("real_pi = " ^ string_of_float real_pi);*)
            if abs_float (approx_pi -. real_pi) <= delta then begin
				iterations + 1
            end else aux new_sum (-.sign) (denominator +. 2.0) (iterations + 1)
        in
        aux 0.0 1.0 1.0 0
*)

let () =
	(* Exemple 1 : Delta vaut 1.0 *)
	print_endline ("Le nombre d'iteration est de : " ^ string_of_int (leibniz_pi 1.0));
	(* Exemple 1 : Delta vaut 0.01 *)
	print_endline ("Le nombre d'iteration est de : " ^ string_of_int (leibniz_pi 0.01));
	(* Exemple 1 : Delta vaut 0.000001 *)
	print_endline ("Le nombre d'iteration est de : " ^ string_of_int (leibniz_pi 0.000001));
	(* Exemple 1 : Delta vaut 0.00000001 *)
	print_endline ("Le nombre d'iteration est de : " ^ string_of_int (leibniz_pi 0.00000001));
	(* Exemple 1 : Delta vaut -42.0 *)
	print_endline ("Le nombre d'iteration est de : " ^ string_of_int (leibniz_pi (-42.0)));
	
