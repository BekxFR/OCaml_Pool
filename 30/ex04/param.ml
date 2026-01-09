module Set = struct
  type 'a t = 'a list

  (* Helper function to remove duplicates from a list *)
  let rec remove_duplicates = function
    | [] -> []
    | x :: xs ->
        if List.mem x xs then remove_duplicates xs
        else x :: remove_duplicates xs

  (* return: 'a -> 'a Set.t 
    Creates a singleton containing the value given as an argument. *)
  let return x = [x]

  (* bind: 'a Set.t -> ('a -> 'b Set.t) -> 'b Set.t
    Applies the function to every element in the set and returns a new set *)
  let bind m f =
    let result = List.concat (List.map f m) in
    remove_duplicates result

  (* union: 'a Set.t -> 'a Set.t -> 'a Set.t
    Returns a new set containing the union of the two sets given as arguments. *)
  let union m1 m2 = remove_duplicates (m1 @ m2)

  (* inter: 'a Set.t -> 'a Set.t -> 'a Set.t
    Returns a new set containing the intersection of the two sets given as arguments. *)
  let inter m1 m2 = List.filter (fun x -> List.mem x m2) m1

  (* diff: 'a Set.t -> 'a Set.t -> 'a Set.t
    Returns a new set containing the difference between the two sets given as arguments. *)
  let diff m1 m2 = List.filter (fun x -> not (List.mem x m2)) m1

  (* filter: 'a Set.t -> ('a -> bool) -> 'a Set.t
    Returns a new set containing only the elements that satisfy the predicate given as an argument. *)
  let filter m predicate = List.filter predicate m

  (* foreach: 'a Set.t -> ('a -> unit) -> unit
    Executes the function provided as an argument on every element in the set. *)
  let foreach m f = List.iter f m

  (* for_all: 'a Set.t -> ('a -> bool) -> bool
    Returns true if all the elements in the set satisfy the predicate given as an argument; false otherwise. *)
  let for_all m predicate = List.for_all predicate m

  (* exists: 'a Set.t -> ('a -> bool) -> bool
    Returns true if at least one element in the set satisfies the predicate given as an argument; false otherwise. *)
  let exists m predicate = List.exists predicate m
end
