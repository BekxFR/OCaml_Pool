type t = T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10 | Jack | Queen | King | As

(** val all : t list # The list of all values of type t *)
let all = [T2; T3; T4; T5; T6; T7; T8; T9; T10; Jack; Queen; King; As]

(** val toInt : t -> int # Interger representation of a card value, from 1 for T2 to 13 for As *)
let toInt = function
  | T2 -> 1
  | T3 -> 2
  | T4 -> 3
  | T5 -> 4
  | T6 -> 5
  | T7 -> 6
  | T8 -> 7
  | T9 -> 8
  | T10 -> 9
  | Jack -> 10
  | Queen -> 11
  | King -> 12
  | As -> 13

(** val toString : t -> string #returns "2", ..., "10", "J", "Q", "K" or "A" *)
let toString = function
  | T2 -> "2"
  | T3 -> "3"
  | T4 -> "4"
  | T5 -> "5"
  | T6 -> "6"
  | T7 -> "7"
  | T8 -> "8"
  | T9 -> "9"
  | T10 -> "10"
  | Jack -> "J"
  | Queen -> "Q"
  | King -> "K"
  | As -> "A"

(** val toStringVerbose : t -> string # returns "2", ..., "10", "Jack", "Queen", "King" or "As" *)
let toStringVerbose = function
  | T2 -> "2"
  | T3 -> "3"
  | T4 -> "4"
  | T5 -> "5"
  | T6 -> "6"
  | T7 -> "7"
  | T8 -> "8"
  | T9 -> "9"
  | T10 -> "10"
  | Jack -> "Jack"
  | Queen -> "Queen"
  | King -> "King"
  | As -> "Ace"

(** val next : t -> t # Returns the next value, or calls invalid_arg if argument is As *)
let next = function
  | T2 -> T3
  | T3 -> T4
  | T4 -> T5
  | T5 -> T6
  | T6 -> T7
  | T7 -> T8
  | T8 -> T9
  | T9 -> T10
  | T10 -> Jack
  | Jack -> Queen
  | Queen -> King
  | King -> As
  | As -> invalid_arg "No valid card after As"

(** val previous : t -> t # Returns the previous value, or calls invalid_arg if argument is T2 *)
let previous = function
  | T2 -> invalid_arg "No valid card before 2"
  | T3 -> T2
  | T4 -> T3
  | T5 -> T4
  | T6 -> T5
  | T7 -> T6
  | T8 -> T7
  | T9 -> T8
  | T10 -> T9
  | Jack -> T10
  | Queen -> Jack
  | King -> Queen
  | As -> King
