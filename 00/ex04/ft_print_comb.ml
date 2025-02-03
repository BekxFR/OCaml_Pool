let ft_print_comb () =
    let rec increment_comb a b c =
        print_int a;
        print_int b;
        print_int c;

        if a = 7 && b = 8 && c = 9 then ()
        else (
            print_string(", ");
            if c < 9 then increment_comb a b (c + 1)
            else if b < 8 then increment_comb a (b + 1) (b + 2)
            else increment_comb (a + 1) (a + 2) (a + 3)
        )
    in
    increment_comb 0 1 2;
    print_string("\n")

let () =
    ft_print_comb ();
