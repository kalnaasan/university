
import Data.List hiding(partition)
import Data.Char


quadratfakultaet x =
   let quadrat z = z*z
       fakq    0 = 1
       fakq    x = (quadrat x)*fakq (x-1)
   in fakq x

verdopplefak x = 
   let fak 0  = 1
       fak x  = x*fak (x-1)
       fakx   = fak x
   in fakx + fakx

verdopplefakLangsam x = 
   let fak 0  = 1
       fak x  = x*fak (x-1)
   in fak x + fak x


sumprod 1 = (1,1)
sumprod n = 
   let (s',p') = sumprod (n-1)
   in (s'+n,p'*n)

sumprod' 1 = (1,1)
sumprod' n = (s'+n,p'*n) 
  where (s',p') = sumprod' (n-1)
   

f x
 | x == 0    = a
 | x == 1    = a*a
 | otherwise = a*f (x-1)
 where a = 10

-- Ungueltig
-- f x = \y -> mul
--    where mul = x * y


-- Fibonacci langsam

fib 0 = 0
fib 1 = 1
fib i = fib (i-1) + fib (i-2) 

-- Fibonacci mit Memoization


fibM i = 
     let fibs = [0,1] ++ [fibs!!(i-1) + fibs!!(i-2) | i <- [2..]]
     in fibs!!i -- i-tes Element der Liste fibs 

-- besser bei mehreren Aufrufen:

fibM'  = 
     let fibs = [0,1] ++ [fibs!!(i-1) + fibs!!(i-2) | i <- [2..]]
     in \i -> fibs!!i -- i-tes Element der Liste fibs 



-- PEANO ZAHLEN
data Pint = Zero | Succ Pint
 deriving(Eq,Show)

istZahl :: Pint -> Bool
istZahl x  =  case x of {Zero  -> True; (Succ y) ->  istZahl y} 

peanoPlus :: Pint -> Pint -> Pint
peanoPlus x y  = if istZahl x &&  istZahl y then pplus x y else bot 
  where
   pplus x  y  =  case x of  
                     Zero  -> y
                     Succ  z -> Succ (pplus z y) 
bot = bot

peanoEq :: Pint -> Pint -> Bool
peanoEq x y = if istZahl x &&  istZahl y then eq x y else bot 
 where
  eq Zero Zero          = True
  eq (Succ x) (Succ y)  = eq x y
  eq _        _         = False

peanoLeq :: Pint -> Pint -> Bool
peanoLeq x y = if istZahl x &&  istZahl y then leq x y else bot 
 where
  leq Zero y            = True
  leq x    Zero         = False
  leq (Succ x) (Succ y) = leq x y

peanoMult :: Pint -> Pint -> Pint
peanoMult x y  = if istZahl x &&  istZahl y then mult x y else bot 
  where
   mult x  y  =  case x of  
                     Zero   -> Zero
                     Succ z -> peanoPlus y (mult z y)
peanoMinus :: Pint -> Pint -> Pint
peanoMinus x y  = if istZahl x &&  istZahl y then pminus x y else bot 
  where
   pminus x  y  =  case y of  
                     Zero  -> x
                     Succ  yy -> case x of Zero -> error "Differenz negativ" 
                                           Succ xx -> pminus xx yy
                                                              
peanofakultaet n = case n of Zero -> Succ Zero
                             Succ _ -> peanoMult n (peanofakultaet (peanoMinus n (makePeano 1)))                          
unendlich = Succ unendlich

showPeano Zero = 0
showPeano (Succ x) = 1+ showPeano x

makePeano :: Integral a => a -> Pint
makePeano 0 = Zero
makePeano n = if n > 0 then Succ (makePeano (n-1))
              else error "negative Peanozahl"

test1 = showPeano $ peanoMult (makePeano 100) (makePeano 100)
test2 = showPeano (peanofakultaet (makePeano 7))
testPeanoQuadrat n = showPeano $ peanoMult (makePeano n) (makePeano n)

--    ===
data Wochentag = Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag
 deriving(Show)

istMontag :: Wochentag -> Bool
istMontag x = case x of 
                 Montag -> True
                 Dienstag -> False
                 Mittwoch -> False
                 Donnerstag -> False
                 Freitag -> False
                 Samstag -> False
                 Sonntag -> False

morgen x = case x of 
                 Montag -> Dienstag
                 Dienstag -> Mittwoch
                 Mittwoch -> Donnerstag
                 Donnerstag -> Freitag
                 Freitag -> Samstag
                 Samstag -> Sonntag
                 Sonntag -> Montag
gestern x = case x of 
                 Dienstag -> Montag 
                 Mittwoch -> Dienstag
                 Donnerstag ->  Mittwoch
                 Freitag -> Donnerstag
                 Samstag -> Freitag
                 Sonntag-> Samstag
                 Montag -> Sonntag

--    heute = Donnerstag

data Student = Student 
                  String  -- Name
                  String  -- Vorname
                  Int     -- Matrikelnr
 deriving(Show)

setzeName :: Student -> String -> Student
setzeName (Student name vorname mnr) name' = Student name' vorname mnr

data Student' = Student' {name :: String,
                          vorname:: String,
                          matrikelnr::Int}
 deriving(Show)

setzeName' student neuername = student {name = neuername}


from :: Integer -> [Integer]
from start = start:(from (start+1))

fromTo :: Integer -> Integer -> [Integer]
fromTo start end
 | start > end     = []
 | otherwise = start:(fromTo (start+1) end)

fromThen :: Integer -> Integer -> [Integer]
fromThen start next = start:(fromThen next (2*next - start))

fromThenTo :: Integer -> Integer -> Integer  -> [Integer]
fromThenTo start next end 
 | start > end = []
 | otherwise   = start:(fromThenTo next (2*next - start) end)


mylength :: [a] -> Int
mylength xs = length_it xs 0

length_it []     acc = acc
length_it (_:xs) acc = let acc' = 1+acc 
                       in seq acc' (length_it xs acc')

safeHead :: [a] -> Maybe a
safeHead xs = case xs of 
               [] ->     Nothing
               (y:ys) -> Just y
-- Bis hier

partition :: (a -> Bool) -> [a] -> ([a], [a])
partition p [] = ([],[])
partition p (x:xs)
  | p x       = (x:r1,r2) 
  | otherwise = (r1,x:r2)
  where (r1,r2) = partition p xs

quicksort []  = []
quicksort [x] = [x]
quicksort (x:xs) = let (kleiner,groesser) = partition (<x) xs
                   in quicksort kleiner ++ (x:(quicksort groesser))


merge []       ys  = ys
merge xs       []  = xs
merge a@(x:xs) b@(y:ys)
  | x <= y    = x:merge xs b
  | otherwise = y:merge a ys


--  Vorsicht:  is schlecht bei bereits sortierten Listen
qsort (x:xs) = qsort [y | y <- xs, y <= x] ++ [x] ++ qsort [y | y <- xs, y > x]
qsort x = x

 


reverse1 [] = []
reverse1 (x:xs) = reverse1 xs ++ [x]

nubSorted (x:y:xs)
  | x == y   = nubSorted (y:xs)
  | otherwise = x:(nubSorted (y:xs))
nubSorted y = y

mergeTask357 = nubSorted $ merge (map (3*) [1..])   (merge (map (5*) [1..]) (map (7*) [1..])) 
