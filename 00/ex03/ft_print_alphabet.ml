let ft_print_alphabet () =
    let rec letter_value (a: int) =
        if a > 122 then ()
        else (
            print_char (char_of_int a);
            letter_value (a + 1)
        )
    in
    letter_value 97;
    print_char '\n'

let () =
    ft_print_alphabet ();
