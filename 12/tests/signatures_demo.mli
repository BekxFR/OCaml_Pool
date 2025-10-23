(* Fichier d'interface - définit la signature *)

module type ORDERED_TYPE = sig
  type t
  val compare : t -> t -> int
end

module type SET = sig
  type elt
  type t
  val empty : t
  val add : elt -> t -> t
  val mem : elt -> t -> bool
  val remove : elt -> t -> t
  val cardinal : t -> int
  val elements : t -> elt list
end

(* Foncteur pour créer des sets *)
module Make (Ord : ORDERED_TYPE) : SET with type elt = Ord.t
