module type MONOID =
  sig
    type element
    val zero1 : element
    val zero2 : element
    val mul : element -> element -> element
    val add : element -> element -> element
    val div : element -> element -> element
    val sub : element -> element -> element
  end

module INT : (MONOID with type element = int) =
  struct
    type element = int
    let zero1 = 0
    let zero2 = 1
    let add = ( + )
    let sub = ( - )
    let mul = ( * )
    let div = ( / )
  end

module FLOAT : (MONOID with type element = float) =
  struct
    type element = float
    let zero1 = 0.0
    let zero2 = 1.0
    let add = ( +. )
    let sub = ( -. )
    let mul = ( *. )
    let div = ( /. )
  end

module type Calc =
  functor (M : MONOID) ->
    sig
      val add : M.element -> M.element -> M.element
      val sub : M.element -> M.element -> M.element
      val mul : M.element -> M.element -> M.element
      val div : M.element -> M.element -> M.element
      val power : M.element -> int -> M.element
      val fact : M.element -> M.element
    end

module Calc : Calc =
  functor (M : MONOID) ->
    struct
      let add = M.add
      let sub = M.sub
      let mul = M.mul
      let div x y = 
        if y = M.zero1 then 
          failwith "Division by zero"
        else 
          M.div x y
      
      let rec power x n =
        if n = 0 then M.zero2
        else if n = 1 then x
        else mul x (power x (n - 1))
      
      let rec fact x =
        if x = M.zero1 then M.zero2
        else mul x (fact (sub x M.zero2))
    end

module Calc_int = Calc(INT)
module Calc_float = Calc(FLOAT)
