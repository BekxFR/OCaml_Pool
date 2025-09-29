type t = Spade | Heart | Diamond | Club

(** val all : t list # The list of all values of type t *)
let all = [Spade; Heart; Diamond; Club]

(** val toString : t -> string # "S", "H", "D" or "C" *)
let toString = function
  | Spade -> "S"
  | Heart -> "H"
  | Diamond -> "D"
  | Club -> "C"

(** val toStringVerbose : t -> string # "Spade", "Heart", etc *)
let toStringVerbose = function
  | Spade -> "Spade"
  | Heart -> "Heart"
  | Diamond -> "Diamond"
  | Club -> "Club"