# Precalentamiento en Haskell

**Paradigmas y Lenguajes de Programación**
UNPSJB – Facultad de Ingeniería

---

## Cómo trabajar con esta guía

La guía avanza en cinco niveles. Cada nivel introduce herramientas nuevas y las practica **reimplementando funciones clásicas del Prelude**. Al terminar se conoce el lenguaje y también cómo está construida su biblioteca estándar.

| Nivel | Tema |
|:-----:|------|
| 0 | Sintaxis y primeros pasos |
| 1 | Listas y recursión |
| 2 | Orden superior y composición |
| 3 | Plegados (*folds*) |
| 4 | Problemas integradores |

**Convención de nombres.** Para no chocar con el Prelude, las reimplementaciones llevan prefijo `v`: `vabs`, `vlength`, `vmap`, etc. 

**Modo de trabajo.**
- Escribir las definiciones en un archivo `.hs` y cargarlo en GHCi con `:l main.hs`.
- Agregar la **firma de tipo** a cada función y verificar con `:t` que coincide con la inferida por Haskell.
- Probar cada función con varios casos, incluidos los casos borde (lista vacía, cero, negativos).
- Cuando el ejercicio indica **Prelude: `f`**, contrastar el comportamiento de la propia definición con el de `f`.

**Los ejemplos** se muestran con `?` (prompt de GHCi) y `⇒` (resultado esperado).

---

# Nivel 0 — Primeros pasos con la sintaxis

**Objetivo:** escribir y probar funciones simples, leer tipos y familiarizarse con las formas de definir una función.

## Repaso de sintaxis

```haskell
-- Comentario de una línea
{- Comentario
   de varias líneas -}

-- Firma de tipo (opcional pero recomendada) y definición
doble :: Int -> Int
doble x = x * 2

-- Varios parámetros: cada flecha separa un argumento; el último tipo es el resultado
suma :: Int -> Int -> Int
suma x y = x + y

-- Condicional (siempre lleva else: es una expresión, no una sentencia)
signoTexto :: Int -> String
signoTexto n = if n < 0 then "negativo" else "no negativo"

-- Guardas
categoria :: Int -> String
categoria n
  | n < 0     = "negativo"
  | n == 0    = "cero"
  | otherwise = "positivo"

-- Pattern matching (se prueba de arriba hacia abajo)
esCero :: Int -> Bool
esCero 0 = True
esCero _ = False

-- Definiciones locales
hipotenusa :: Double -> Double -> Double
hipotenusa a b = sqrt (cuad a + cuad b)
  where cuad x = x * x

-- let ... in ...
area :: Double -> Double
area r = let pi' = 3.14159 in pi' * r * r

-- Tuplas y listas
par :: (Int, String)
par = (1, "uno")

lista :: [Int]
lista = [1, 2, 3]          -- endulzado de 1 : 2 : 3 : []

-- Rangos
-- [1..5]  [2,4..10]  [10,8..0]  ['a'..'e']

-- Operadores: infijo <-> prefijo
-- 7 `div` 2   ==  div 7 2        (+) 1 2  ==  1 + 2

-- Lambda
-- (\x -> x + 1) 5
```

**Comandos útiles de GHCi:** `:l archivo.hs` (cargar), `:r` (recargar), `:t expr` (tipo de una expresión), `:i nombre` (información), `:q` (salir).

`Int` es entero de tamaño fijo; `Integer` es de precisión arbitraria. En este nivel se usan indistintamente salvo que se indique lo contrario.

---

## Ejercicio 0.1 — Explorando con GHCi

Sin escribir ningún archivo, evaluar en GHCi y **predecir antes de ejecutar** el resultado o el tipo de:

```haskell
:t 'a'
:t "hola"
:t True
:t (+)
:t not
:t (1, 'a')
:t [1,2,3]
:t []
7 `div` 2
7 / 2
mod (-7) 2
rem (-7) 2
```

¿Qué diferencias observa entre `div` y `/`? ¿Y entre `mod` y `rem`? ¿Qué tipo tiene `[]` y por qué?

## Ejercicio 0.2 — Valor absoluto

Definir la función `vabs` que retorne el valor absoluto de un entero dado. Resolverla **dos veces**: con `if-then-else` y con guardas.

**Prelude:** `abs`

## Ejercicio 0.3 — Signo

Definir la función `vsignum` que retorne `-1`, `0` o `1` según el signo de un entero. Resolverla con guardas y luego con pattern matching sobre el caso `0`.

**Prelude:** `signum`

## Ejercicio 0.4 — Un saludo con pattern matching

Definir la función `hola` y **anticipar** el tipo que Haskell inferirá. Luego verificarlo con `:t`.

```haskell
hola "Juan" = "Hola, qué dia ¿no?"
hola nombre = "Buenas " ++ nombre ++ " ¿todo bien?"
```

Analizar además el objetivo y el tipo de `(++)`. ¿Qué pasa si se cambia el orden de los dos casos?

## Ejercicio 0.5 — Operadores lógicos

Definir `vnot :: Bool -> Bool` y los operadores infijos `(&&&)` y `(|||)` (conjunción y disyunción) usando **pattern matching**.

```haskell
? vnot True            ⇒ False
? True && False       ⇒ False
? False || True       ⇒ True
```

Desafío: ¿es posible definir `(&&&)` con solo dos casos? ¿Qué argumento se evalúa realmente en cada caso?

**Prelude:** `not`, `&&`, `||`

## Ejercicio 0.6 — Máximo y mínimo

Definir `vmax` y `vmin` tal que dados 2 enteros retornen el mayor/menor. Luego:

1. Analizar qué modificaciones se deben introducir para trabajar con **2 caracteres**. Ídem para **2 strings**.
2. Definir `vmax` y `vmin` **en forma genérica** para cualquier tipo que admita comparación. Consultar el tipo inferido: ¿qué significa `Ord a =>`?

```haskell
? vmax "hola" "chau"   ⇒ "hola"
? vmin 'b' 'z'         ⇒ 'b'
? vmin 17.5 (-20.8)    ⇒ -20.8
```

**Prelude:** `max`, `min`

## Ejercicio 0.7 — Factorial (tres estilos)

Definir `fact1`, `fact2` y `fact3`, que retornen el factorial de un entero dado, aplicando respectivamente:

- **Guardas**
- **Pattern Matching**
- **If Then Else**

Verificar el prototipo de cada cual inferido por Haskell. Probar con valores grandes en `Int` y en `Integer`: ¿qué observa?

## Ejercicio 0.8 — Tuplas

Definir `vfst`, `vsnd` y, como complemento, `vswap :: (a, b) -> (b, a)`. Comparar sus tipos con los de `fst` y `snd`.

**Prelude:** `fst`, `snd`

## Ejercicio 0.9 — Paridad

Definir `veven` y `vodd` usando `mod`. Definir `vodd` de dos maneras: directamente con `mod` y como negación de `veven`.

**Prelude:** `even`, `odd`

## Ejercicio 0.10 — Aplicación parcial y secciones

En GHCi, predecir el tipo y el resultado de:

```haskell
(+1) 5
(2*) 5
(subtract 1) 5
(`div` 2) 9
(2 `div`) 9
(suma 3)              -- ¿qué es esto? ¿se puede mostrar?
```

Luego, aplicando la siguiente función, definir `cuadrado`, `cubo` y `cuarta`, tales que dado un entero retornan la correspondiente potencia del mismo. **No** escribir el parámetro en las definiciones (`cuadrado = pot 2`).

```haskell
pot :: Integer -> Integer -> Integer
pot n x = x ^ n
```

¿Qué cambiaría en las definiciones si `pot` hubiera sido definida como `pot x n = x ^ n`?

**Prelude:** `(^)` (uso)

---

# Nivel 1 — Listas y recursión

**Objetivo:** dominar la recursión estructural sobre listas y entender que las funciones clásicas del Prelude son definiciones cortas de este tipo.

```haskell
f []     = ...                  -- caso base
f (x:xs) = ... x ... f xs       -- caso recursivo
```

## Ejercicio 1.1 — Conociendo las funciones de listas

Dada la lista

```haskell
alumnos = [("juan",7), ("ana",9), ("luis",6), ("maria",8)]
```

analizar cómo se comportan `length`, `head`, `tail`, `last`, `init`, `take n`, `drop n`, `sum`, `reverse` y `alumnos !! 2`. Determinar cuáles producen error de tipos, cuáles pueden fallar en tiempo de ejecución y con qué entradas.

## Ejercicio 1.2 — Reducciones numéricas

Definir `vlength`, `vsum` y `vproduct` por recursión.

```haskell
? vlength "hola"        ⇒ 4
? vsum [1,2,3,4]        ⇒ 10
? vproduct [1,2,3,4]    ⇒ 24
```

Preguntas: ¿por qué `vsum []` debe valer `0` y `vproduct []` debe valer `1`? Reescribir el factorial del Nivel 0 usando `vproduct`.

**Prelude:** `length`, `sum`, `product`

## Ejercicio 1.3 — Accediendo a los extremos

Definir `vhead`, `vtail`, `vlast` y `vinit`. ¿Qué deben hacer ante la lista vacía? Usar `error "mensaje"` y discutir por qué se las llama *funciones parciales*.

```haskell
? vlast [1,2,3]   ⇒ 3
? vinit [1,2,3]   ⇒ [1,2]
```

**Prelude:** `head`, `tail`, `last`, `init`

## Ejercicio 1.4 — Construyendo listas

Definir:

- `(+++)` (concatenación de dos listas) y verificar que su tipo coincide con el de `(++)`.
- `vreverse` (primero una versión ingenua usando `+++`; luego, opcionalmente, una versión con acumulador).
- `vconcat`, que aplana una lista de listas.

```haskell
? [1,2] +++ [3,4]                 ⇒ [1,2,3,4]
? vreverse "Haskell"              ⇒ "lleksaH"
? vconcat [[1],[2,3],[],[4]]      ⇒ [1,2,3,4]
```

**Prelude:** `++`, `reverse`, `concat`

## Ejercicio 1.5 — Tomar, descartar, repetir, indexar

Definir `vtake`, `vdrop`, `vreplicate` y `(!!!)`.

```haskell
? vtake 3 [1..10]        ⇒ [1,2,3]
? vdrop 3 [1..10]        ⇒ [4,5,6,7,8,9,10]
? vreplicate 3 'a'       ⇒ "aaa"
? [10,20,30] !!! 1       ⇒ 20
```

Analizar: ¿qué debe pasar con `vtake 10 [1,2]`, con `vtake (-1) xs`, y con un índice fuera de rango en `(!!!)`?

**Prelude:** `take`, `drop`, `replicate`, `!!`

## Ejercicio 1.6 — Pertenencia

Definir las funciones `velem` / `vnotElem` tal que dado un elemento y una lista verifican que el elemento pertenece / no pertenece a la lista. Indicar el prototipo (¿qué restricción de clase aparece y por qué?).

**Prelude:** `elem`, `notElem`

## Ejercicio 1.7 — Mayor y menor de una lista

Definir la función `vmaximum` / `vminimum` tal que dada una lista retorne el mayor / menor de sus elementos. Reutilizar `vmax` / `vmin` del Ejercicio 0.6. ¿Qué debería hacer con la lista vacía?

**Prelude:** `maximum`, `minimum`

## Ejercicio 1.8 — Conjunción y disyunción de listas

Definir `vand` y `vor` que operen sobre una lista de booleanos.

```haskell
? vand [True, True, False]   ⇒ False
? vor  [False, False, True]  ⇒ True
? vand []                    ⇒ ?      -- pensar el valor antes de probar
```

**Prelude:** `and`, `or`

## Ejercicio 1.9 — Emparejar y separar

Definir `vzip` y `vunzip`.

```haskell
? vzip [1,2,3] "abc"         ⇒ [(1,'a'),(2,'b'),(3,'c')]
? vzip [1,2,3] "ab"          ⇒ [(1,'a'),(2,'b')]
? vunzip [(1,'a'),(2,'b')]   ⇒ ([1,2],"ab")
```

**Prelude:** `zip`, `unzip`

## Ejercicio 1.10 — Máximo común divisor y mínimo común múltiplo

Definir `mcd` tal que dados 2 enteros retorne el Máximo Común Divisor (algoritmo de Euclides). Definir además `mcm` en función de `mcd`.

**Prelude:** `gcd`, `lcm`

## Ejercicio 1.11 — Listas por comprensión y rangos

Predecir el resultado y luego verificar:

```haskell
[x*x | x <- [1..10]]
[x | x <- [1..20], even x]
[(x,y) | x <- [1..3], y <- "ab"]
[x | x <- [1..30], mod 30 x == 0]
[7, 7+7 .. 50]
```

Definir `divisores :: Int -> [Int]` y, a partir de ella, `esPrimo :: Int -> Bool`.

## Ejercicio 1.12 — Un enigma con listas infinitas

Analizar las siguientes funciones, definir su objetivo y determinar los conceptos que se aplican. Probar con `queHace [4,6]` y `queHace [2,3,4]`, y comparar los resultados con los que produce `mcm` (Ejercicio 1.10).

```haskell
queHace :: [Int] -> Int
queHace [] = error "lista vacía!"
queHace [x] = x
queHace (x:y:ys) = queHace (queHaceAux1 x y : ys)

queHaceAux1 :: Int -> Int -> Int
queHaceAux1 x y | x > y     = queHaceAux2 y [x,x+x ..]
                | otherwise = queHaceAux2 x [y,y+y ..]

queHaceAux2 :: Int -> [Int] -> Int
queHaceAux2 x (y:ys) | mod y x == 0 = y
                     | otherwise    = queHaceAux2 x ys
```

## Ejercicio 1.13 — Rotando listas un lugar

Definir `izquierda` y `derecha`, que desplacen los elementos de una lista una posición hacia la izquierda / derecha. Usar las funciones del Ejercicio 1.3.

```haskell
? izquierda "Paradigmas"   ⇒ "aradigmasP"
? derecha "Paradigmas"     ⇒ "sParadigma"
```

---

# Nivel 2 — Orden superior y composición

**Objetivo:** tratar funciones como valores. Pasarlas como argumento, devolverlas como resultado y combinarlas.

## Ejercicio 2.1 — Transformar todos los elementos

Definir la función `vmap` tal que dada una función y una lista aplica la función a cada elemento de la lista y retorna la lista de resultados.

```haskell
? vmap (length) ["hola", "gente"]   ⇒ [4,5]
? vmap (*8) [2,4,3,5]               ⇒ [16,32,24,40]
```

Indicar el prototipo. ¿Por qué el tipo de entrada y el de salida pueden ser distintos?

**Prelude:** `map`

## Ejercicio 2.2 — Seleccionar elementos

Definir la función `vfilter` tal que dado un criterio de selección y una lista retorna los elementos de la lista que verifican el criterio.

```haskell
? vfilter even [2,7,-1,0,4]          ⇒ [2,0,4]
? vfilter (>'d') "probando letras"   ⇒ "pronoletrs"
```

**Prelude:** `filter`

## Ejercicio 2.3 — Composición de funciones

Analizar la función `(.)` definida en Prelude, definir su objetivo y determinar si los ejemplos de aplicación son correctos o no. Para los incorrectos, explicar el error de tipos y proponer una corrección.

```haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)
(f . g) x = f (g x)

g1 x = (not . esta) x
g2 x = not . esta x
g3 x xs = not . esta x xs
g4 = cuadrado . cuadrado
g5 x = (cubo . cubo) x
g6 = sum . map length
g7 = filter even . map length
g8 = (+1) . flip div 2
g9 x = length . (++ x)
g10 x y = length . (++ x)
```

Definir además `vcomp` (equivalente a `(.)`), `vflip`, `vid` y `vconst`.

**Prelude:** `.`, `flip`, `id`, `const`

## Ejercicio 2.4 — Curry y uncurry

Definir `vcurry` y `vuncurry` y explicar con sus palabras la diferencia entre `f :: (a, b) -> c` y `f :: a -> b -> c`. ¿Por qué en Haskell la segunda forma es la habitual?

```haskell
? vuncurry (+) (3, 4)     ⇒ 7
? vcurry fst 1 'x'        ⇒ 1
```

**Prelude:** `curry`, `uncurry`

## Ejercicio 2.5 — Evaluación perezosa

Dadas las siguientes funciones, determinar su comportamiento ante las invocaciones y el concepto que se aplica:

```haskell
ignoroArg1 x = "No me importa"   ? ignoroArg1 (1/0)
ignoroArg2 x = x                 ? ignoroArg2 (1/0)
```

Predecir además el resultado de:

```haskell
? take 5 [1..]
? fst (1, undefined)
? vconst 3 undefined
? vand [False, undefined]     -- usando la versión del Ejercicio 1.8
```

## Ejercicio 2.6 — Palabras sin consonantes, y otras transformaciones

**a)** Definir la función `f` tal que dada una lista de palabras retorne la lista con las palabras sin sus consonantes.

```haskell
? f ["Luis", "Pedro", "Marta"]   ⇒ ["ui", "eo", "aa"]
```

**b)** Definir la función `g` tal que dada una lista de palabras retorne la lista con la cantidad de consonantes de cada palabra.

```haskell
? g ["Luis", "Pedro", "Marta"]   ⇒ [2, 3, 3]
```

**c)** Definir la función `h` tal que dada una lista de palabras y una función pueda comportarse como las anteriores.

```haskell
? h f ["Luis", "Pedro", "Marta"]   ⇒ ["ui", "eo", "aa"]
? h g ["Luis", "Pedro", "Marta"]   ⇒ [2, 3, 3]
```

## Ejercicio 2.7 — Combinando dos listas con una función

Definir `vzipWith` y usarla para definir `vzip` (Ejercicio 1.9) y el producto escalar de dos listas.

```haskell
? vzipWith (+) [1,2,3] [10,20,30]     ⇒ [11,22,33]
? vzipWith max "abc" "cba"            ⇒ "cbc"
```

**Prelude:** `zipWith`

## Ejercicio 2.8 — Cortando listas según un criterio

Definir `vtakeWhile`, `vdropWhile` y `vspan`.

```haskell
? vtakeWhile even [2,4,5,6]    ⇒ [2,4]
? vdropWhile even [2,4,5,6]    ⇒ [5,6]
? vspan even [2,4,5,6]         ⇒ ([2,4],[5,6])
```

Aplicación: definir `palabras :: String -> [String]` (versión simplificada de `words`) usando `vdropWhile` y `vspan`.

**Prelude:** `takeWhile`, `dropWhile`, `span`

## Ejercicio 2.9 — Cuantificadores

Definir `vany` y `vall`. Luego redefinir `velem` y `vnotElem` (Ejercicio 1.6) en función de ellas.

```haskell
? vany even [1,3,5,6]      ⇒ True
? vall even [2,4,5]        ⇒ False
```

**Prelude:** `any`, `all`

## Ejercicio 2.10 — Repetición de funciones

Definir `viterate` (lista infinita) y `vuntil`.

```haskell
? take 5 (viterate (*2) 1)     ⇒ [1,2,4,8,16]
? vuntil (>100) (*2) 1         ⇒ 128
```

Aplicación: definir `desplaza`, aplicando `izquierda` y `derecha` (Ejercicio 1.13), que reciba como parámetro una función, un entero y una lista, y genere el desplazamiento de los *n* elementos de la misma en el sentido indicado por la función.

```haskell
? desplaza derecha 3 "Paradigmas"     ⇒ "masParadig"
? desplaza izquierda 4 "Paradigmas"   ⇒ "digmasPara"
```

**Prelude:** `iterate`, `until`

## Ejercicio 2.11 — Composición aplicada: duplas

**a)** Definir una función `listaDuplas` que reciba como parámetros una función y una lista, y devuelva la lista de duplas que resultan de aplicar la función a cada elemento de la lista.

**b)** Definir una función `filtraDuplas` que reciba como parámetros una función y una lista de duplas, y devuelva la lista de duplas cuya 2da. componente verifique la función.

**c)** Definir una función de orden superior `filtraListaDuplas`, aplicando el operador `(.)`, componiendo las dos anteriores.

```haskell
? filtraListaDuplas (<6) longitud ["buenas","tardes","a","todos"]
    ⇒ [("buenas",6),("tardes",6)]

? filtraListaDuplas (/='s') ultimo ["buenas","tardes","a","todos"]
    ⇒ [("buenas",'s'),("tardes",'s'),("todos",'s')]

? filtraListaDuplas ((=='h').primero) sinPrimero ["hola","ala","chau"]
    ⇒ [("hola","ola"),("ala","la")]
```

## Ejercicio 2.12 — Composición aplicada: aplicar y eliminar

**a)** Definir una función `aplicarFunciones` que reciba como parámetros una lista de funciones y una lista de valores, y devuelva la lista de duplas formadas por cada valor y los resultados que se obtienen al aplicar las funciones de la lista al mismo.

**b)** Definir una función `eliminarValores` que reciba como parámetros una función y una lista de duplas, y devuelva la lista de duplas sin aquellos valores de la 2da. componente que verifiquen la función.

**c)** Describir el objetivo y determinar si es correcta la siguiente definición de la función `aplicarYEliminar`. Si no fuera correcta, modificar la definición con el fin de lograr el mismo objetivo.

```haskell
aplicarYEliminar fs f = eliminarValores f . aplicarFunciones fs
```

```haskell
? aplicarYEliminar [cuadrado, cubo, (`mod` 3)] (>10) [4,3,2]
    ⇒ [(4,[1]), (3,[9,0]), (2,[4,8,2])]

? aplicarYEliminar [primero, ultimo] (/='a') ["a", "la", "loca","mora"]
    ⇒ [("a","aa"),("la","a"),("loca","a"),("mora","a")]
```

---

# Nivel 3 — Plegados (*folds*)

**Objetivo:** reconocer el patrón común detrás de casi todas las funciones recursivas sobre listas y expresarlo con `foldr` y `foldl`.

## Ejercicio 3.1 — Los dos plegados

Definir `vfoldr` y `vfoldl`, y sus variantes sin valor inicial `vfoldr1` y `vfoldl1`. Trazar a mano la evaluación de:

```haskell
vfoldr (-) 0 [1,2,3]
vfoldl (-) 0 [1,2,3]
```

¿Por qué dan resultados distintos? Dibujar el árbol de aplicaciones de cada uno.

**Prelude:** `foldr`, `foldl`, `foldr1`, `foldl1`

## Ejercicio 3.2 — Todo es un fold

Redefinir usando **únicamente** `vfoldr` o `vfoldl`, sin recursión explícita:

`vsum`, `vproduct`, `vlength`, `vmaximum`, `vand`, `vor`, `vconcat`, `vreverse`, `vmap`, `vfilter`, `vany`, `vall`, `velem`.

Completar una tabla que indique, para cada una, cuál es el valor inicial y cuál es la función combinadora.

## Ejercicio 3.3 — Resultados parciales

Definir `vscanl` (que devuelve la lista de todos los acumulados intermedios de un `foldl`).

```haskell
? vscanl (+) 0 [1,2,3,4]      ⇒ [0,1,3,6,10]
? vscanl max 0 [3,1,4,1,5]    ⇒ [0,3,3,4,4,5]
```

Aplicación: dada una lista de números que representan movimientos de una cuenta, obtener la evolución del saldo.

**Prelude:** `scanl`

## Ejercicio 3.4 — Aplicar una secuencia de funciones

Dada la función:

```haskell
f [] x = x
f (x:xs) y = f xs (x y)
```

**a)** Definir su prototipo y objetivo. Expresarla con `foldl`.

**b)** Calcular a mano `f [(+1), (*2), (subtract 3)] 5`. ¿Cambia el resultado si se invierte la lista de funciones? ¿Y si se usa `(.)` con `foldr`?

## Ejercicio 3.5 — Valores que verifican

Aplicando `f`, definir `verifican`, tal que dada una lista de valores y una lista de funciones, retorna aquellos valores que luego de aplicar las funciones devuelven un resultado que se encuentra en la lista de valores.

```haskell
? verifican [1,2,-1,0,9] [pot 2, suma 3, resta 2]                    ⇒ [1,-1,0]
? verifican ["a","hola","lo"] [reversa, aLaCabeza 'h', aLaCola 'a']  ⇒ ["lo"]
```

## Ejercicio 3.6 — Saldo de una cuenta

Dado el saldo inicial de una cuenta bancaria y una serie de movimientos, obtener el saldo final aplicando `f`. Los movimientos se indican con un código:

| Código | Operación |
|:------:|-----------|
| A | Acreditación de un cheque depositado |
| B | Débito de un cheque emitido |
| D | Depósito en efectivo |
| E | Extracción en efectivo |
| G | Gastos bancarios |

Definir `movimiento :: (Char, Double) -> (Double -> Double)`, que convierta cada movimiento en una función sobre el saldo, y luego `saldoFinal`.

```haskell
? saldoFinal [('D', 138), ('E', 180), ('B', 62.5), ('G', 3.6), ('E', 300), ('A', 120)] 200
    ⇒ -88.1
```

---

# Nivel 4 — Problemas integradores

**Objetivo:** combinar recursión, orden superior, composición y folds. Cada ejercicio admite varias soluciones: resolver primero de la forma más natural y luego refactorizar con las herramientas de los niveles anteriores.

## Ejercicio 4.1 — Años pares, capicúas y no bisiestos

Definir una función `listanios`, y todas sus auxiliares, que permitan generar una lista de números que representan años **pares, capicúas y no bisiestos**, a partir de un año dado como parámetro, siempre positivo. Recordar que un año bisiesto cumple las siguientes condiciones: es divisible por 4 y, si es divisible por 100, también debe serlo por 400.

```haskell
? listanios 800   ⇒ [818, 838, 858, 878, 898, 2002, 2222, ...]
```

Se dispone de la función `revers`, que dado un entero devuelve la reversa del entero:

```haskell
? revers 235   ⇒ 532

revers :: Int -> Int
revers n = reversa2 n 0

reversa2 :: Int -> Int -> Int
reversa2 n x | n < 10    = n + (x * 10)
             | otherwise = reversa2 (div n 10) ((mod n 10) + (x * 10))
```

Preguntas: ¿por qué el resultado puede ser una lista infinita? ¿Cómo se lo consume con `take`?

## Ejercicio 4.2 — Extremo según un criterio

Definir la función `extremo` tal que dado un criterio de selección y una lista retorna el elemento de la lista que verifica el criterio. Reescribir `mayor` y `menor` (Ejercicio 1.7) en función de `extremo`.

```haskell
? extremo (>) [7, -3, 2, 5]               ⇒ 7
? extremo (masCorta) ["hola", "gente"]    ⇒ "hola"
```

## Ejercicio 4.3 — Ordenar según un criterio

Definir la función `ordenar` tal que dado un criterio y una lista retorna la lista ordenada según el criterio. Se sugiere ordenamiento por inserción.

```haskell
? ordenar (>) [(segunda ("vvvv",1)),(segunda ("vv",2))]       ⇒ [2,1]
? ordenar (<) [(primera ("vvvv",1)),(primera ("vv",2))]       ⇒ ["vv","vvvv"]
? ordenar (>) [4,6,5,1,2,3]                                   ⇒ [6,5,4,3,2,1]
? ordenar (<) (map (longitud.primera) [("hola",1),("b",2)])   ⇒ [1,4]
```

Comparar con `sort` y `sortBy` (de `Data.List`).

## Ejercicio 4.4 — Aplicar funciones y localizar resultados

Definir la función `aplica` tal que dadas una lista de funciones, una lista de elementos y una lista de valores resultado, permita obtener una lista de tuplas:

`(elemento, resultado, posiciónDeLaPrimeraFunciónQueProduceElResultado)`

```haskell
? aplica [cuadrado,cubo,(+1)] [1,2,3] [1,3,9]
    ⇒ [(1,1,1),(2,3,3),(3,9,1)]

? aplica [primero,ultimo] ["hola","linda","chau"] ['h','l','u']
    ⇒ [("hola",'h',1),("linda",'l',1),("chau",'u',2)]
```

## Ejercicio 4.5 — Igualdad de funciones

Definir la función `igualValor` que reciba como parámetro una lista de funciones, y devuelva el menor entero positivo para el cual todas las funciones retornan el mismo resultado.

```haskell
? igualValor [((+5).(+1)),cuadrado]   ⇒ 3
```

## Ejercicio 4.6 — El elemento saltarín

Definir la función `soloUnSaltarin` tal que reciba como parámetros dos listas comparables y verifique que la segunda lista presenta a lo sumo un elemento "saltarín", que cambió su posición original respecto de la primera lista, avanzando sobre el resto de la lista.

```haskell
? soloUnSaltarin "causalidad" "casualidad"   ⇒ True
? soloUnSaltarin "amor" "mora"               ⇒ True
? soloUnSaltarin [1,2,3,4] [1,3,4]           ⇒ False
```

## Ejercicio 4.7 — Verificar incrementos

Definir una función `verifIncremento` tal que dadas dos listas de listas, verifica que las sublistas tomadas de a pares presentan *n* elementos diferentes, con *n* igual a la cantidad de elementos diferentes del par anterior incrementada en 1.

```haskell
? verifIncremento ["este","si"] ["esta","no"]                 ⇒ True
? verifIncremento ["este","si"] ["este","si?"]                ⇒ True
? verifIncremento [[1,1],[2,2,2]] [[1,2],[2,2,2,4]]           ⇒ False
? verifIncremento ["este","ejemplo","no"] ["este","ejemp."]   ⇒ False
```

## Ejercicio 4.8 — Funciones cerradas

**a)** Definir una función `esCerrada`, y todas las auxiliares necesarias, tal que dada una función y una lista de valores, verifica que la función aplicada a cada valor produce un resultado que se encuentra en la lista de valores.

```haskell
? esCerrada (concatenar "xx") ["esta","sera","cerrada?","s","e"]   ⇒ False
? esCerrada (inters "en") ["esta","sera","cerrada?","s","e",[]]    ⇒ True
? esCerrada not [True,False]                                       ⇒ True
? esCerrada (suma 1) [1,0,-1]                                      ⇒ False
```

**b)** Definir una función `obtieneCompCerradas`, y todas las auxiliares necesarias, tal que dadas dos listas de funciones y una lista de valores, devuelve la lista de funciones compuestas `(.)` de a pares (tomando una y una de cada lista), que verifican ser cerradas.

```haskell
? obtieneCompCerradas [suma 1, pot 3, resta 2] [suma 9, pot 4, suma 2] [-1,0,1]
    ⇒ [pot 3 . pot 4, resta 2 . suma 2]

? obtieneCompCerradas [suma 1, pot 3] [suma 9, pot 4] [10]
    ⇒ []

? obtieneCompCerradas [inters "bb", extraeNDesde 1 2] [extraeNDesde 1 2, concatenar "aa"] ["aa",[]]
    ⇒ [inters "bb" . extraeNDesde 1 2]
```

Las funciones `concatenar`, `inters` y `extraeNDesde` deben definirse infiriendo su comportamiento a partir de los ejemplos. Como GHCi no puede mostrar funciones, verificar los resultados de la parte **b)** aplicando las funciones obtenidas a valores concretos.

## Ejercicio 4.9 — Una función misteriosa (filtrado generalizado)

Dada la función:

```haskell
func _ _ _ [] = []
func f g x (y:ys) | f (g y) x = y : func f g x ys
                  | otherwise = func f g x ys
```

**a)** Definir su prototipo y objetivo. Compararla con `filter`.

**b)** Aplicando `func`, definir las siguientes funciones y todas las auxiliares necesarias:

- **b.1) `sublistas`**, tal que dada una lista de valores y una función, devuelve una lista conformada por sublistas que agrupan aquellos elementos que, al aplicarle la función, producen el mismo resultado.

  ```haskell
  ? sublistas [1,3,-2,-1,2] cuadrado
      ⇒ [[1,-1], [3], [-2,2]]

  ? sublistas ["hola","este","ejemplo","puede","andar"] longitud
      ⇒ [["hola","este"], ["ejemplo"], ["puede","andar"]]
  ```

- **b.2) `superanProm`**, tal que dada una lista de materias, una lista de tuplas `(alumno, materia, nota1, nota2)`, que contienen las notas obtenidas por distintos alumnos en dos parciales de distintas materias, y un promedio mínimo, permite obtener una lista de duplas `(materia, alumnosAprobados)`, que indican para cada materia la lista de alumnos que obtuvieron un promedio mayor al promedio mínimo indicado.

  ```haskell
  ? superanProm ["algoritmos","paradigmas"]
      [("juan","algoritmos",6,7), ("sofia","sintaxis",8,5), ("maria","paradigmas",9,7),
       ("diego","algoritmos",2,6), ("maria","algoritmos",6,8), ("pedro","paradigmas",7,4),
       ("jose","paradigmas",2,5)]
      6
      ⇒ [("algoritmos",["juan","maria"]),("paradigmas",["maria"])]
  ```

## Ejercicio 4.10 — Recorrer dos listas en paralelo

Dada la siguiente función:

```haskell
func _ [] [] = True
func _ _ [] = False
func _ [] _ = False
func g (x:xs) (y:ys) = g x y && func g xs ys
```

**1)** Definir su prototipo y objetivo. ¿En qué se parece y en qué se diferencia de `and (zipWith g xs ys)`?

**2)** Aplicando la función anterior, codificar las siguientes funciones, y todas las auxiliares necesarias:

- **a) `sumasDivisibles`**, que recibe un entero y dos listas de enteros, y verifica que la suma de cada par conformado por un elemento de cada lista es divisible por el entero indicado.

  ```haskell
  ? sumasDivisibles 3 [1,3,5,-2] [0,0,4,5]   ⇒ False
  ? sumasDivisibles 3 [1,3,5,-2] [8,0,4,5]   ⇒ True
  ```

- **b) `espejo`**, que recibe dos listas y verifica que las mismas sean iguales, o a lo sumo "iguales en espejo", es decir, que la primera sea igual a la segunda reflejada en un espejo.

  ```haskell
  ? espejo "hola" "aloh"                        ⇒ True
  ? espejo [1,2,3] [1,2,4]                      ⇒ False
  ? espejo ["Feliz","2004!"] ["Feliz","2004!"]  ⇒ True
  ```
