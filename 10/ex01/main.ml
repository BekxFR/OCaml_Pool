let () =
  List.iter (function value ->
    try
      Printf.printf "Card with value : %s, corresponds to the integer : %d and can be call : %s.\n"
        (Value.toStringVerbose value)
        (Value.toInt value)
        (Value.toString value);
      match value with
      | value when value = Value.T2 ->
        Printf.printf "Her next is : %s, "
          (Value.toStringVerbose (Value.next value));
        Printf.printf "and her previous card is : %s"
          (Value.toStringVerbose (Value.previous value))
      | _ ->
        Printf.printf "Her previous card is : %s, "
          (Value.toStringVerbose (Value.previous value));
        Printf.printf "and her next is : %s\n"
          (Value.toStringVerbose (Value.next value))
    with
    | Invalid_argument msg -> 
      Printf.printf "%s -> Erreur : %s\n" (Value.toString value) msg
  ) Value.all