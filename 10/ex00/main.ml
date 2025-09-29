let () =
  List.iter (fun color ->
    Printf.printf "Card with the color : %s, corresponds to the letter : %s\n"
      (Color.toStringVerbose color)
      (Color.toString color)
  ) Color.all