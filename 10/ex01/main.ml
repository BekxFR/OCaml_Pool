let () =
  List.iter (function value ->
    Printf.printf "Card with value : %s, corresponds to the integer : %d and can be call : %s.\n"
    (* Her previous card is : %s and her next is : %s.\n *)
      (Value.toStringVerbose value)
      (Value.toInt value)
      (Value.toString value)
      (* (Value.toStringVerbose (Value.previous value)) *)
      (* (Value.toStringVerbose (Value.next value)) *)
  ) Value.all;
  List.iter (function value ->
    (* Printf.printf "Card with value : %s, corresponds to the integer : %d and can be call : %s.\n" *)
    Printf.printf "Her previous card is : %s and her next is : %s.\n"
      (* (Value.toStringVerbose value)
      (Value.toInt value)
      (Value.toString value) *)
      (Value.toStringVerbose (Value.previous value))
      (Value.toStringVerbose (Value.next value))
  ) Value.all