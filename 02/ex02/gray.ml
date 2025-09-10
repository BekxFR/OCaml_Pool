let gray n =
  let pow2 k =
    let rec aux acc k =
      if k = 0 then acc
      else aux (acc * 2) (k - 1) in
    aux 1 k
  in
  let size = pow2 n in
  let rec print_gray i =
    if i = size then print_newline ()
    else
      let g = i lxor (i lsr 1) in
      let rec build_str j acc =
        if j < 0 then acc
        else
          let bit =
            if (g lsr j) land 1 = 0 then "0"
            else "1"
          in
          build_str (j - 1) (acc ^ bit)
      in
      let s = build_str (n - 1) "" in
      print_string s;
      if i <> size - 1 then print_string " ";
      print_gray (i + 1)
  in
  print_gray 0

(* lxor: operateur binaire "ou exclusif (XOR)" entre deux entiers. ex: 5 lxor 3 = 6 (0101 XOR 0011 = 0110) *)
(* lsr: operateur de decalage logique a droite (Logical Shift Right). ex: 5 lsr 1 = 2 (0101 devient 0010) *)
(* land: operateur binaire "et logique (AND)" entre deux entiers. ex: 5 land 3 = 1 (0101 AND 0011 = 0001) *)

let () =
  print_endline "Gray 1 :";
  gray 1;
  print_endline "Gray 2 :";
  gray 2;
  print_endline "Gray 3 :";
  gray 3;
  print_endline "Gray 4 :";
  gray 4;
  print_endline "Gray 5 :";
  gray 5;