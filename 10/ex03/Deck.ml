module Card = struct
  module Color = struct
    type t = Spade | Heart | Diamond | Club

    let all = [Spade; Heart; Diamond; Club]

    let toString = function
      | Spade -> "S"
      | Heart -> "H"
      | Diamond -> "D"
      | Club -> "C"

    let toStringVerbose = function
      | Spade -> "Spade"
      | Heart -> "Heart"
      | Diamond -> "Diamond"
      | Club -> "Club"
  end

  module Value = struct
    type t = T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10 | Jack | Queen | King | As

    let all = [T2; T3; T4; T5; T6; T7; T8; T9; T10; Jack; Queen; King; As]

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

  let newCard value color = (value, color)

  let allSpades = List.map (fun v -> newCard v Color.Spade) Value.all
  let allHearts = List.map (fun v -> newCard v Color.Heart) Value.all
  let allDiamonds = List.map (fun v -> newCard v Color.Diamond) Value.all
  let allClubs = List.map (fun v -> newCard v Color.Club) Value.all
  let all = allSpades @ allHearts @ allDiamonds @ allClubs

  let getValue (v, _) = v
  let getColor (_, c) = c

  let toString (v, c) =
    (Value.toString v) ^ (Color.toString c)

  let toStringVerbose (v, c) =
    "Card(" ^ (Value.toStringVerbose v) ^ ", " ^ (Color.toStringVerbose c) ^ ")"

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

  let max c1 c2 =
    if compare c1 c2 >= 0 then c1 else c2

  let min c1 c2 =
    if compare c1 c2 <= 0 then c1 else c2

  let best = function
    | [] -> invalid_arg "Empty list"
    | h :: t -> List.fold_left max h t

  let isOf (_, c) color = c = color
  let isSpade card = isOf card Color.Spade
  let isHeart card = isOf card Color.Heart
  let isDiamond card = isOf card Color.Diamond
  let isClub card = isOf card Color.Club
end

type t = Card.t list

(* Mélange de Fisher-Yates, aussi appelé mélange de Knuth *)
let shuffle lst =
  let rec shuffle_aux acc remaining =
    match remaining with
    | [] -> acc
    | _ ->
      let len = List.length remaining in
      let random_index = Random.int len in
      let rec split_at index lst acc_before =
        match lst with
        | [] -> (List.rev acc_before, [])
        | h :: t ->
          if index = 0 then
            (List.rev acc_before, h :: t)
          else
            split_at (index - 1) t (h :: acc_before)
      in
      let (before, after) = split_at random_index remaining [] in
      match after with
      | [] -> acc
      | chosen :: rest ->
        shuffle_aux (chosen :: acc) (before @ rest)
  in
  shuffle_aux [] lst

let newDeck () = shuffle Card.all

let toStringList deck = List.map Card.toString deck

let toStringListVerbose deck = List.map Card.toStringVerbose deck

let drawCard = function
  | [] -> raise (Failure "Cannot draw from empty deck")
  | h :: t -> (h, t)
