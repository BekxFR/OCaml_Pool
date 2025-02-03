let ft_is_palindrome (s: string) = 
    let rec checker b e =
        if b >= e then true
        else if String.get s b = String.get s e then checker (b + 1) (e - 1)
        else false
    in
    checker 0 (String.length s - 1)

(*
let ft_is_palindrome (s: string) = 
    let ft_string_all f s =
        let rec check n m =
            if n >= m then true
            else if f (String.get s n) (String.get s m) then check (n + 1) (m - 1)
            else false
        in
        check 0 (String.length s - 1)
    in
    let is_same c d = c = d in
    ft_string_all is_same s
*)

let () = 

    print_endline (string_of_bool(ft_is_palindrome "radar"));
    print_endline (string_of_bool(ft_is_palindrome "madam"));
    print_endline (string_of_bool(ft_is_palindrome "car"));
    print_endline (string_of_bool(ft_is_palindrome ""));
    print_endline (string_of_bool(ft_is_palindrome "ressasser"));
    print_endline (string_of_bool(ft_is_palindrome "KAYAK"));
    print_endline (string_of_bool(ft_is_palindrome "SATOR AREPO TENET OPERA ROTAS"));
    print_endline (string_of_bool(ft_is_palindrome "SATOR AREPO TENIT OPERA ROTAS"))
