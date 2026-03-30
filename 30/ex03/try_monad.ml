exception Filter_failed of string

type 'a t =
  | Success of 'a
  | Failure of exn

let return x = Success x

let bind m f =
  match m with
  | Success v ->
      (try f v
       with e -> Failure e)
  | Failure e -> Failure e

let recover m f =
  match m with
  | Success v -> Success v
  | Failure e -> f e

let filter m predicate =
  match m with
  | Success v ->
      if predicate v
      then Success v
      else Failure (Filter_failed "Predicate not satisfied")
  | Failure e -> Failure e

let flatten m =
  match m with
  | Success (Success v) -> Success v
  | Success (Failure e) -> Failure e
  | Failure e -> Failure e
