a = "hola mundo"
f :: Int -> Int

f x = x * x
g x = x + x

hola x y = x + y

sisi x y = if x > y then x else y
nono x y | x > y = x | otherwise = y

vabs x | x > 0 = x | otherwise = -x

saludo "Rodrigo" = "Hola.."
saludo otraPersona = "Hola " ++ otraPersona ++ " chau"

fac1 x 
  | x <= 0 = 1 
  | otherwise = x * fac1 (x - 1)

fac2 x = 
  if x <= 0 then 1 
  else x * fac2 (x - 1)

fac3 0 = 1
fac3 x = x * fac3 (x - 1)

fib 0 = 0
fib 1 = 1
fib x = fib(x - 1) + fib (x - 2)

fib2 x 
  | x == 0 = 0 
  | x == 1 = 1 
  | otherwise = fib2 (x - 1) + fib2 (x - 2)

fib3 x = 
  if (x == 0 || x == 1) then x 
  else fib3 (x - 1) + fib3 (x - 2)

vsum [] = 0
vsum (x:xs) = x + vsum xs

vlen [] = 0
vlen (x:xs) = 1 + vlen xs

vnot :: Bool -> Bool
vnot v
  | v = False
  | otherwise = True

vnot' True = True
vnot' _ = True

(&&&) True True = True
(&&&) _ _ = False

(|||) False False = False
(|||) _ _ = True

vfst (x, _) = x
vsnd (_, y) = y
vswap (x, y) = (y, x)

vmap _ [] = []
vmap f (x:xs) = (f x) : vmap f xs

vfilter _ [] = []
vfilter f (x:xs) 
  | f x = x : vfilter f xs
  | otherwise = vfilter f xs

vfoldr _ x0 [] = x0
vfoldr f x0 (x:xs) = f x (vfoldr f x0 xs)

vzip [] _ = []
vzip _ [] = []
vzip (x:xs) (y:ys) = (x,y) : vzip xs ys

vunzip [] = ([],[])
--vunzip ((x,y):xs) = (x:ys,y:zs) where (ys,zs) = vunzip xs
--vunzip ((x,y):xs) = (x:(vfst.vunzip)xs, y:(vsnd.vunzip)xs)
vunzip xs = (vmap vfst xs, vmap vsnd xs)

vand [] = True
vand (x:xs) = x &&& vand xs

vor [] = False
vor (x:xs) = x ||| vor xs

vcurry f x y = f (x,y)

vuncurry f (x,y) = f x y
