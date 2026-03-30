type hour = int
let zero = 12
let add h1 h2 = let result = ((h1 mod 12) + (h2 mod 12) + 12 + 12) mod 12 in if result = 0 then 12 else result
let sub h1 h2 = let result = ((h1 mod 12) - (h2 mod 12) + 12 + 12) mod 12 in if result = 0 then 12 else result
