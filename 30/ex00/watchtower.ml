module type Watchtower =
  sig
    type hour = int
    val zero : hour
    val add : hour -> hour -> hour
    val sub : hour -> hour -> hour
  end

module Watchtower =
  struct
    type hour = int
    let zero = 12
    let add h1 h2 = let result = ((h1 mod zero) + (h2 mod zero) + zero + zero) mod zero in if result == 0 then zero else result
    let sub h1 h2 = let result = ((h1 mod zero) - (h2 mod zero) + zero + zero) mod zero in if result == 0 then zero else result
  end
