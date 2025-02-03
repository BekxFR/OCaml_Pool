(* pattern mathing *)
(* let rec ft_countdown = function
    | a when a <= 0 -> print_int (0); print_char ('\n')
    | a -> print_int (a); print_char ('\n'); ft_countdown (a - 1) *)

(* let rec ft_countdown (a: int) =
    if a <= 0 then (
        print_int (0); print_char ('\n')
    ) else (
        print_int (a); print_char ('\n'); ft_countdown (a - 1)
    ) *)

let ft_countdown (a: int) =
    let rec print_countdown (a: int) =
        if a <= 0 then (
            print_int (0);
            print_char ('\n')
        ) else (
            print_int (a);
            print_char ('\n');
            print_countdown (a - 1)
        )
    in
    print_countdown a

let () =
    ft_countdown 3;
    ft_countdown 0;
    ft_countdown (-1);
