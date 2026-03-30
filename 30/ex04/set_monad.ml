type 'a t = 'a list

let rec remove_duplicates = function
  | [] -> []
  | x :: xs ->
      if List.mem x xs then remove_duplicates xs
      else x :: remove_duplicates xs

let return x = [x]

let bind m f =
  let result = List.concat (List.map f m) in
  remove_duplicates result

let union m1 m2 = remove_duplicates (m1 @ m2)
let inter m1 m2 = List.filter (fun x -> List.mem x m2) m1
let diff m1 m2 = List.filter (fun x -> not (List.mem x m2)) m1
let filter m predicate = List.filter predicate m
let foreach m f = List.iter f m
let for_all m predicate = List.for_all predicate m
let exists m predicate = List.exists predicate m
