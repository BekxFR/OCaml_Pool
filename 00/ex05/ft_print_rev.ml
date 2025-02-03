let ft_print_rev (s: string) =
    let rec print_letter s n =
        if n < 0 then ()
        else (
            print_char (String.get s n);
            print_letter s (n - 1)
        )
    in
    print_letter s (String.length s - 1);
    print_char '\n'

let () =
    ft_print_rev "Hello world !";
    ft_print_rev "";
    ft_print_rev "looc tse'c etivisrucer aL";
    ft_print_rev "SATOR AREPO TENET OPERA ROTAS"
