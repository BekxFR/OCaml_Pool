# Exercice 03 : Monade Try

> *"Try or try not; there's no try. No, wait..."*

## 📋 Description

Implémentation d'une **monade Try** pour gérer les exceptions de manière fonctionnelle et élégante, remplaçant le style impératif `try/catch`.

## 🎯 Objectifs

Une instance de Try peut être :
- **Success of 'a** : Opération réussie contenant une valeur
- **Failure of exn** : Opération échouée contenant une exception

## 📝 Fonctions implémentées

| Fonction | Signature | Description |
|----------|-----------|-------------|
| `return` | `'a -> 'a Try.t` | Crée un Success avec la valeur |
| `bind` | `'a Try.t -> ('a -> 'b Try.t) -> 'b Try.t` | Applique une fonction, capture les exceptions |
| `recover` | `'a Try.t -> (exn -> 'a Try.t) -> 'a Try.t` | Récupère après une erreur |
| `filter` | `'a Try.t -> ('a -> bool) -> 'a Try.t` | Filtre selon un prédicat |
| `flatten` | `'a Try.t Try.t -> 'a Try.t` | Aplatit un Try imbriqué |

## 🏗️ Structure des fichiers

```
ex03/
├── param.ml                # Implémentation du module Try
├── param_commented.ml      # Version avec commentaires détaillés
├── main.ml                 # Suite de tests complète
├── Makefile               # Compilation et tests
├── ANALYSE_EXERCICE.md    # Analyse détaillée de conformité
└── README.md              # Ce fichier
```

## 🚀 Compilation et exécution

```bash
# Compilation
make

# Compilation + tests
make test

# Nettoyage
make fclean

# Recompilation complète
make re
```

## 💻 Exemples d'utilisation

### Exemple 1 : Division sécurisée

```ocaml
let safe_divide a b =
  if b = 0 then 
    Try.Failure Division_by_zero
  else 
    Try.return (a / b)

(* Utilisation *)
let result = safe_divide 10 2  (* Success 5 *)
let error = safe_divide 10 0   (* Failure Division_by_zero *)
```

### Exemple 2 : Chaînage avec bind

```ocaml
let result =
  Try.return 100
  |> (fun m -> Try.bind m (fun x -> safe_divide x 4))
  |> (fun m -> Try.bind m (fun x -> Try.return (x * 2)))
  
(* Résultat : Success 50 *)
```

### Exemple 3 : Récupération d'erreurs

```ocaml
let result =
  safe_divide 10 0
  |> (fun m -> Try.recover m (fun _ -> Try.return 0))
  
(* Résultat : Success 0 *)
```

### Exemple 4 : Filtrage

```ocaml
let result =
  Try.return 42
  |> (fun m -> Try.filter m (fun x -> x > 0))
  
(* Résultat : Success 42 *)

let error =
  Try.return (-5)
  |> (fun m -> Try.filter m (fun x -> x > 0))
  
(* Résultat : Failure (Filter_failed "Predicate not satisfied") *)
```

### Exemple 5 : Flatten

```ocaml
(* Success of Success → Success *)
let t1 = Try.flatten (Try.Success (Try.Success 42))  (* Success 42 *)

(* Success of Failure → Failure *)
let t2 = Try.flatten (Try.Success (Try.Failure Not_found))  (* Failure Not_found *)
```

## 🧪 Tests fournis

Le fichier `main.ml` contient **6 suites de tests complètes** :

1. ✅ **Test return** - Création de Success
2. ✅ **Test bind** - Application de fonctions et capture d'exceptions
3. ✅ **Test recover** - Récupération après erreurs
4. ✅ **Test filter** - Filtrage avec prédicats
5. ✅ **Test flatten** - Aplatissement de Try imbriqués
6. ✅ **Test scénario complet** - Calculatrice sécurisée réaliste

### Exemple de sortie

```
╔════════════════════════════════════════════╗
║  Tests du module Try (Monade d'exceptions) ║
╚════════════════════════════════════════════╝

=== Test 1: return ===
Try.return 42 =
Success(42)

=== Test 2: bind ===
Cas 1: Success -> fonction qui retourne Success
bind (Success 10) (*2) = Success(20)

Cas 3: Success -> fonction qui lève une exception
bind (Success 0) (100/x) = Failure(Division_by_zero)

[... plus de 20 tests ...]

╔════════════════════════════════════════════╗
║         Tous les tests terminés !          ║
╚════════════════════════════════════════════╝
```

## ✅ Conformité avec l'énoncé

### Vérification complète

- [x] Type `Success of 'a` implémenté
- [x] Type `Failure of exn` implémenté
- [x] Fonction `return` conforme
- [x] Fonction `bind` conforme + capture d'exceptions ⭐
- [x] Fonction `recover` conforme
- [x] Fonction `filter` conforme
- [x] Fonction `flatten` conforme
- [x] `Success of Failure` devient `Failure` ⭐

### Points critiques respectés

1. **bind capture les exceptions** : `try f v with e -> Failure e`
2. **filter utilise une vraie exception** : `exception Filter_failed of string`
3. **flatten traite Success of Failure comme Failure**

Voir [ANALYSE_EXERCICE.md](ANALYSE_EXERCICE.md) pour l'analyse détaillée.

## 🎓 Concepts abordés

- **Monades** : Pattern de composition fonctionnelle
- **Gestion d'erreurs fonctionnelle** : Alternative à try/catch
- **Types somme** : Success | Failure
- **Composition de fonctions** : bind, recover, filter
- **Capture d'exceptions** : Transformation en valeurs

## 📚 Lien avec le cours

Cette monade illustre les concepts de la [Section 6 du cours complet](../../COURS_COMPLET_OCAML.md#6-monades) :

- Définition formelle des monades
- Lois des monades (identité, associativité)
- Comparaison avec Option et Result
- Composition d'opérations risquées

## 🔗 Comparaison avec d'autres langages

### JavaScript (Promises)

```javascript
// Promise est une monade similaire à Try
fetch(url)
  .then(response => response.json())  // bind
  .catch(error => defaultValue)       // recover

// Équivalent Try OCaml
fetch url
|> bind parse_json
|> recover (fun _ -> return default_value)
```

### Rust (Result)

```rust
// Result<T, E> en Rust
fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err("Division by zero".to_string())
    } else {
        Ok(a / b)
    }
}

// Équivalent Try OCaml
let divide a b =
  if b = 0 then
    Try.Failure Division_by_zero
  else
    Try.return (a / b)
```

### Haskell (Either)

```haskell
-- Either e a en Haskell
safeDivide :: Int -> Int -> Either String Int
safeDivide _ 0 = Left "Division by zero"
safeDivide a b = Right (a `div` b)

-- Équivalent Try OCaml
let safe_divide a b =
  if b = 0 then
    Try.Failure Division_by_zero
  else
    Try.return (a / b)
```

## 🚀 Améliorations possibles

### Opérateurs infixes

```ocaml
let ( >>= ) = Try.bind
let ( <$> ) f m = Try.map f m

(* Usage plus élégant *)
safe_divide 100 4 >>= safe_sqrt >>= fun x -> return (x * 2)
```

### Fonctions utilitaires

```ocaml
let map f m = bind m (fun x -> return (f x))
let is_success = function Success _ -> true | _ -> false
let get_or_default d = function Success x -> x | _ -> d
```

## 📖 Documentation

- **param.ml** : Implémentation minimaliste
- **param_commented.ml** : Version avec documentation complète
- **main.ml** : Tests exhaustifs avec exemples
- **ANALYSE_EXERCICE.md** : Analyse de conformité détaillée

## 🎯 Résultat final

✅ **Code 100% conforme à l'énoncé**  
✅ **Tests exhaustifs fournis**  
✅ **Documentation complète**  
✅ **Prêt pour production**

---

**Exercice complété avec succès ! 🎉**
