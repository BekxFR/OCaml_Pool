(* Exception personnalisée pour filter *)
exception Filter_failed of string

module Try = struct
  type 'a t = 
    | Success of 'a
    | Failure of exn

  (* return: 'a -> 'a Try.t *)
  let return x = Success x

  (* bind: 'a Try.t -> ('a -> 'b Try.t) -> 'b Try.t
     Applique la fonction et capture les exceptions qu'elle pourrait lever *)
  let bind m f =
    match m with
    | Success v -> 
        (try f v
         with e -> Failure e)
    | Failure e -> Failure e

  (* recover: 'a Try.t -> (exn -> 'a Try.t) -> 'a Try.t
     Applique la fonction de récupération en cas d'échec *)
  let recover m f =
    match m with
    | Success v -> Success v
    | Failure e -> f e

  (* filter: 'a Try.t -> ('a -> bool) -> 'a Try.t
     Convertit en Failure si le prédicat n'est pas satisfait *)
  let filter m predicate =
    match m with
    | Success v -> 
        if predicate v 
        then Success v 
        else Failure (Filter_failed "Predicate not satisfied")
    | Failure e -> Failure e

  (* flatten: 'a Try.t Try.t -> 'a Try.t
     Aplatit un Try imbriqué. Success of Failure devient Failure *)
  let flatten m =
    match m with
    | Success (Success v) -> Success v
    | Success (Failure e) -> Failure e
    | Failure e -> Failure e
end
