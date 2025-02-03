let ft_print_comb2 () =
    let print_double_digit x =
        if x < 10 then (
            print_int 0;
            print_int x
        ) else (
            print_int x;
        );
    in

    let rec update_number n m =
        print_double_digit n;
        print_char ' ';
        print_double_digit m;
        if n > 97 && m > 98 then (
            print_char '\n'
        ) else (
            print_char ',';
            print_char ' ';
            if m > 98 then (
                update_number (n + 1) (n + 2)
            ) else (
                update_number n (m + 1)
            )
        )
    in
    update_number 0 1

let () =
    ft_print_comb2 ()
