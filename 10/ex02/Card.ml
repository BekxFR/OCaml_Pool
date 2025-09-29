module Color =
struct
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
end

module Value =
struct
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
end

type t = Value.t * Color.t

(* val newCard : Value.t -> Color.t -> t *)
let newCard value color = (value, color)

(* val allSpades : t list *)
let allSpades = List.map (fun v -> newCard v Color.Spade) Value.all
(* val allHearts : t list *)
let allHearts = List.map (fun v -> newCard v Color.Heart) Value.all
(* val allDiamonds : t list *)
let allDiamonds = List.map (fun v -> newCard v Color.Diamond) Value.all
(* val allClubs : t list *)
let allClubs = List.map (fun v -> newCard v Color.Club) Value.all
(* val all : t list *)
let all = allSpades @ allHearts @ allDiamonds @ allClubs

(* val getValue : t -> Value.t *)
let getValue (v, _) = v
(* val getColor : t -> Color.t *)
let getColor (_, c) = c

(* val toString : t -> string *)
let toString (v, c) =
  (Value.toString v) ^ (Color.toString c)
(* val toStringVerbose : t -> string *)
let toStringVerbose (v, c) =
  "Card(" ^ (Value.toStringVerbose v) ^ ", " ^ (Color.toStringVerbose c) ^ ")"

(* val compare : t -> t -> int *)
let compare (v1, c1) (v2, c2) =
  let val1 = Value.toInt v1 in
  let val2 = Value.toInt v2 in
  if val1 < val2 then -1
  else if val1 > val2 then 1
  else
    if c1 = c2 then 0
    else match (c1, c2) with
      | (Color.Spade, _) -> -1
      | (_, Color.Spade) -> 1
      | (Color.Heart, _) -> -1
      | (_, Color.Heart) -> 1
      | (Color.Diamond, Color.Club) -> -1
      | (Color.Club, Color.Diamond) -> 1
      | _ -> 0

(* val max : t -> t -> t *)
let max c1 c2 =
  if compare c1 c2 >= 0 then c1 else c2
(* val min : t -> t -> t *)
let min c1 c2 =
  if compare c1 c2 <= 0 then c1 else c2
(* val best : t list -> t *)
let best = function
  | [] -> invalid_arg "Empty list"
  | h :: t -> List.fold_left max h t

(* val isOf : t -> Color.t -> bool *)
let isOf (_, c) color = c = color
(* val isSpade : t -> bool *)
let isSpade card = isOf card Color.Spade
(* val isHeart : t -> bool *)
let isHeart card = isOf card Color.Heart
(* val isDiamond : t -> bool *)
let isDiamond card = isOf card Color.Diamond
(* val isClub : t -> bool *)
let isClub card = isOf card Color.Club