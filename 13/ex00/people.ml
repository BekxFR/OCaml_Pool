class people =
object (self)
  val mutable name : string
  val mutable hp : int = 100
  method to_string =
    "Name: " ^ name ^ ", HP: " ^ string_of_int hp
  method talk =
    Stdlib.print_endline ("I'm " ^ name ^ "! Do you know the Doctor?")
  method die =
    Stdlib.print_endline ("Aaaarghh!")