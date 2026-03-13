# Day 30 - Monoids and Monads : Concepts

## Mathematical notions

### Monoid

A **monoid** is an algebraic structure consisting of:
- A **set** of elements
- A **binary operation** (associative): `combine(a, combine(b, c)) = combine(combine(a, b), c)`
- A **neutral element** (identity): `combine(a, zero) = combine(zero, a) = a`

Concrete examples in the exercises:
- **12-hour clock** (ex00): set = {1..12}, operation = modular addition, neutral = 12
- **Projects** (ex01): set = project tuples, operation = combine, neutral = ("", "", 0)
- **Arithmetic** (ex02): integers/floats with addition (neutral = 0) and multiplication (neutral = 1)

### Monad

A **monad** is a structure that provides:
- **return** (injection): wraps a value into the monadic context
- **bind** (chaining): applies a function to the wrapped value, producing a new monadic value

#### Monadic laws
1. **Left identity**: `bind (return a) f = f a`
2. **Right identity**: `bind m return = m`
3. **Associativity**: `bind (bind m f) g = bind m (fun x -> bind (f x) g)`

Concrete examples:
- **Try** (ex03): wraps computations that may fail (Success/Failure)
- **Set** (ex04): wraps collections with deduplication

---

## Exercise by exercise

### ex00 : Watchtower (Clock monoid)
- **Type**: `hour = int`, **neutral element**: `zero = 12`
- **add/sub**: modular arithmetic on a 12-hour clock
- Any result of 0 maps to 12 (there is no "hour 0" on a clock)
- Demonstrates associativity: `add (add 3 5) 4 = add 3 (add 5 4) = 12`
- Demonstrates neutral element: `add h 12 = h` for all h

### ex01 : App (Project monoid)
- **Type**: `project = string * string * int` (name, status, grade)
- **zero**: `("", "", 0)` — neutral element for combine
- **combine**: concatenates names, averages grades, status = "succeed" if average >= 80, "failed" otherwise
- **fail**: sets grade to 0 and status to "failed"
- **success**: sets grade to 80 and status to "succeed"

### ex02 : INT, FLOAT, Calc (Arithmetic functor)
- **Module type MONOID**: defines `element`, `zero1` (additive neutral), `zero2` (multiplicative neutral), `add`, `sub`, `mul`, `div`
- **INT** and **FLOAT**: concrete monoid implementations for `int` and `float`
- **Functor Calc**: takes a MONOID and provides generic `add`, `sub`, `mul`, `div`, `power`, `fact`
- `power x n`: recursive, multiplies x by itself n times (base case: `zero2`)
- `fact x`: recursive factorial (base case: if `x = zero1` then `zero2`)
- `div`: raises `Failure "Division by zero"` when dividing by `zero1`
- **Instantiation**: `Calc_int = Calc(INT)`, `Calc_float = Calc(FLOAT)`

### ex03 : Try (Exception monad)
- **Type**: `'a t = Success of 'a | Failure of exn`
- **return**: wraps a value in `Success`
- **bind**: applies a function to `Success` value, catches exceptions with `try/with` and wraps them in `Failure`; propagates `Failure` unchanged
- **recover**: applies a recovery function only on `Failure`; passes `Success` through
- **filter**: converts `Success` to `Failure` if the predicate is not satisfied
- **flatten**: `Success (Success v) -> Success v`, `Success (Failure e) -> Failure e`, `Failure e -> Failure e`

### ex04 : Set (Set monad)
- **Type**: `'a t = 'a list` (with deduplication via `remove_duplicates`)
- **return**: creates a singleton `[x]`
- **bind**: applies function to every element, concatenates results, removes duplicates
- **union/inter/diff**: standard set operations
- **filter**: keeps elements satisfying a predicate
- **foreach**: iterates a side-effect function over all elements
- **for_all/exists**: universal and existential quantifiers
- Verifies monadic laws: left identity, right identity

---

## OCaml notions

### Module and module type (signature)

A **module type** (signature) defines an interface — the types and values a module must expose:

```ocaml
module type Watchtower =
  sig
    type hour = int
    val zero : hour
    val add : hour -> hour -> hour
    val sub : hour -> hour -> hour
  end
```

A **module** implements a signature:

```ocaml
module Watchtower : Watchtower =
  struct
    type hour = int
    let zero = 12
    let add h1 h2 = ...
    let sub h1 h2 = ...
  end
```

> When a `.ml` file defines a module `M`, it is accessed from other files as `Filename.M` (e.g., `Watchtower.Watchtower`, `Param.Try`).

### Functor

A **functor** is a module parameterized by another module. It enables generic programming over module types:

```ocaml
module Calc : functor (M : MONOID) -> sig
  val add : M.element -> M.element -> M.element
  val power : M.element -> int -> M.element
  ...
end
```

Instantiation creates concrete modules:
```ocaml
module Calc_int = Calc(INT)
module Calc_float = Calc(FLOAT)
```

### Parametric types (`'a t`)

A type parameterized by a type variable, allowing the same structure to hold any type:
```ocaml
type 'a t = Success of 'a | Failure of exn   (* Try monad *)
type 'a t = 'a list                           (* Set monad *)
```

### Pattern matching on algebraic types

Used extensively in monadic operations:
```ocaml
let bind m f =
  match m with
  | Success v -> (try f v with e -> Failure e)
  | Failure e -> Failure e
```

### Exception handling with try/with

Used in `Try.bind` to capture exceptions raised by the function argument:
```ocaml
let bind m f =
  match m with
  | Success v ->
      (try f v
       with e -> Failure e)
  | Failure e -> Failure e
```

This is the core mechanism that makes `Try` a monad for exception handling: instead of propagating exceptions up the call stack, they are captured and wrapped in `Failure`.

---

## Module hierarchy summary

```
ex00/watchtower.ml
  module type Watchtower (signature)
  module Watchtower : Watchtower (implementation)

ex01/app.ml
  module type App (signature)
  module App : App (implementation)

ex02/monoid.ml
  module type MONOID (signature for arithmetic monoids)
  module INT : MONOID (int implementation)
  module FLOAT : MONOID (float implementation)
  module type Calc (functor signature)
  module Calc : Calc (functor implementation)
  module Calc_int = Calc(INT)
  module Calc_float = Calc(FLOAT)

ex03/param.ml
  exception Filter_failed
  module Try (exception monad)
    type 'a t = Success of 'a | Failure of exn
    return, bind, recover, filter, flatten

ex04/param.ml
  module Set (set monad)
    type 'a t = 'a list
    return, bind, union, inter, diff, filter, foreach, for_all, exists
```
