import Data.List

-- Beispielhafte Datentypen
data RGB = Rot | Gruen | Blau
 deriving(Show)

data BBaum a = Blatt a | Knoten (BBaum a) (BBaum a)

bMap f (Blatt a) = Blatt (f a)
bMap f (Knoten links rechts) = Knoten (bMap f links) (bMap f rechts)

data Wochentag = Montag | Dienstag | Mittwoch | Donnerstag | Freitag | Samstag | Sonntag
 deriving(Show)

-- Instanz der Klasse Eq f"ur den Datentyp Wochentag

instance Eq Wochentag where
 Montag     == Montag     = True
 Dienstag   == Dienstag   = True
 Mittwoch   == Mittwoch   = True
 Donnerstag == Donnerstag = True
 Freitag    == Freitag    = True
 Samstag    == Samstag    = True
 Sonntag    == Sonntag    = True
 _          == _          = False

-- Unsinnige Instanz f"ur RGB (keine Methoden implementiert, Gleichheitstest
-- verwendet Ungleichheitstest und umgekehrt, daher nichtterminierung,
-- z.B. Rot == Gruen terminiert nicht 
instance Eq RGB where

-- Mit Klasse die nur (===) als default definiert:
class MyEq a where
  (===), (=/=) :: a -> a -> Bool
  (===)  a b = not (a =/= b)

instance MyEq RGB where

-- Compiler gibt eine Warnung aus
--
--
--
-- TypklassenBeispiele.hs:37:9:
--    Warning: No explicit method nor default method for `=/='
--    In the instance declaration for `MyEq RGB'
--
-- Aufruf:
-- *Main> Rot =/= Gruen
-- *** Exception: TypklassenBeispiele.hs:37:9-16: No instance nor default method for 
-- class operation Main.=/=

-- Instanz der Klasse Ord f"ur den Datentyp Wochentag

instance Ord Wochentag where
 a <= b = (a,b) `elem`  [(a,b) | i <- [0..6], let a = ys!!i, b <- drop i ys]
  where ys = [Montag, Dienstag, Mittwoch, Donnerstag, Freitag, Samstag, Sonntag]

  
bRand (Blatt a) = [a]
bRand (Knoten links rechts) = (bRand links) ++ (bRand rechts)

-- Instanz der Klasse Eq f"ur den Datentyp Baum

instance Eq a => Eq (BBaum a) where
  Blatt a == Blatt b           = a == b
  Knoten l1 r1 == Knoten l2 r2 = l1 == l2 && r1 == r2 
  _  == _                      = False   --  muss da sein, sonst pattern Fehler
 

-- Gleichheit indirekt ueber Listengleichheit. ist nicht ganz die Baumgleichheit
--  instance Eq a => Eq (BBaum a) where
--  tr1 == tr2 = bRand tr1 == bRand tr2
 
 
    
    --   als ungeordnete Baeume
-- instance Eq a => Eq (BBaum a) where
--     Blatt a == Blatt b       = a == b
--     Knoten a b == Knoten c d =    (a == c && b == d) || (a == d && b == c)

-- Instanz der Klasse Show f"ur den Datentyp Baum
-- Bedingung: Die Blattmarkierungen sind selbst schon Instanz der Klasse Show

instance Show a => Show (BBaum a) where
 showsPrec _ = showsBBaum


showBBaum (Blatt a) = show a
showBBaum (Knoten l r) = "<" ++ showBBaum l ++ "|" ++ showBBaum r ++ ">"

showBBaum' b = showsBBaum b []

showsBBaum (Blatt a) = shows a
showsBBaum (Knoten l r) = 
  showChar '<' . showsBBaum l . showChar '|' . showsBBaum r . showChar '>'


-- Instanz der Klasse Read f"ur den Datentyp Baum
-- Bedingung: Die Blattmarkierungen sind selbst schon Instanz der Klasse Read


instance Read a => Read (BBaum a) where
 readsPrec _ = readsBBaum


readsBBaum :: (Read a) => ReadS (BBaum a)
readsBBaum ('<':xs) =  [(Knoten l r, rest) | (l, '|':ys) <- readsBBaum xs,
                                             (r, '>':rest) <- readsBBaum ys]
readsBBaum s         =  [(Blatt x, rest)     | (x,rest)      <- reads s] 


-- Hilfsfunktion, um Testb"aume erzeugen:
 
 
genBaum [] = error "genBaum with Empty List"
genBaum [a] = Blatt a
genBaum xs = let l = div (length xs) 2
                 (ys,zs) = splitAt l xs                 
             in Knoten (genBaum ys) (genBaum zs)

genBaum' [x]    = Blatt x
genBaum' (x:xs) = Knoten (genBaum' xs) (Blatt x)

genBaum'' [x]    = Blatt x
genBaum'' (x:xs) = Knoten (Blatt x) (genBaum'' xs) 

-- Instanz der Klasse Enum f"ur den Datentyp Wochentag

instance Enum Wochentag where
 toEnum i = tage!!(i `mod` 7)
 fromEnum t = case elemIndex t tage of
               Just i -> i
 -- succ a = toEnum (fromEnum a +1)   (automatisch definiert)
 -- pred a = toEnum (fromEnum a -1)

tage = [Montag, Dienstag, Mittwoch, Donnerstag, Freitag, Samstag, Sonntag]

newtype IntList = IntList [Int]
   deriving (Show)

instance Enum  IntList
   where 
    toEnum x = IntList[x]
    fromEnum (IntList [x]) = x





-- Instanz der Konstruktorklasse Functor fuer den Typkonstruktor BBaum

instance Functor BBaum where
 fmap = bMap

-- Instanz der Konstruktorklasse Functor fuer den Typkonstruktor Either a
--    (wirkt nur auf Right)

--   das ist bereits in Data.Either (in der neueren Version)
--  instance Functor (Either a) where
--      fmap f (Left a) = Left a
--      fmap f (Right a) = Right (f a)


-- -------------------------------------------------------- 
-- Demonstration: Aufl"osung der "Uberladung von Typklassen
-- -------------------------------------------------------- 
 
-- Aufl"osung der Eq-Klasse

-- class  Eq a  where
--      (==), (/=)  ::  a -> a -> Bool
--      x /= y  = not (x == y)
--      x == y  = not (x /= y)

-- Anstelle der Klassendefinition tritt ein Datentyp
 
data EqDict a = EqDict {
                  eqEq  :: a -> a -> Bool, -- ==
                  eqNeq :: a -> a -> Bool  -- /=
                }

-- Implementierung der Default-Implementierungen
default_eqEq eqDict  x y = not (eqNeq eqDict x y) -- x /= y  = not (x == y)
default_eqNeq eqDict x y = not (eqEq eqDict x y) -- x == y  = not (x /= y)


-- Statt der "uberladenen Funktionen == und /= werden
-- nun Funktionen generiert, die ein EqDict-Dictionary
-- als zus"atzliches Argument erhalten

overloadedeq :: EqDict a -> a -> a -> Bool -- Ersatz f"ur ==
overloadedeq dict a b = eqEq dict a b

overloadedneq :: EqDict a -> a -> a -> Bool -- Ersatz f"ur /=              
overloadedneq dict a b = eqNeq dict a b

-------  Dict fuer Bool

eqDictBool = EqDict {eqEq = eqBool, eqNeq =  default_eqNeq eqDictBool}
   where
    eqBool True  True  = True
    eqBool False False = True
    eqBool _     _     = False

--  Dict fuer Listen 

-- instance Eq a => Eq [a] where
--  ....
-- x:xs == y:ys = x == y && xs == ys 
 

eqDictList::  EqDict a -> EqDict [a]
eqDictList dict  =  EqDict {eqEq = eqList dict, eqNeq = default_eqNeq (eqDictList dict)}   where
     eqList dict  [] []          =  True
     eqList dict (x:xs)  (y:ys)  =
           overloadedeq dict x y && overloadedeq (eqDictList dict) xs ys 
     eqList dict _ _ = False
testEqListen1 = overloadedeq (eqDictList eqDictBool) [True] [True] 
testEqListen2 = overloadedeq (eqDictList eqDictBool) [True] [False] 

-- Dictionary f"ur die Wochentag-Instanz:

eqDictWochentag :: EqDict Wochentag
eqDictWochentag = EqDict {
                   eqEq = eqW,
                   eqNeq = default_eqNeq eqDictWochentag
                   }
  where
    eqW Montag     Montag     = True
    eqW Dienstag   Dienstag   = True
    eqW Mittwoch   Mittwoch   = True
    eqW Donnerstag Donnerstag = True
    eqW Freitag    Freitag    = True
    eqW Samstag    Samstag    = True
    eqW Sonntag    Sonntag    = True 
    eqW _          _          = False

-- Dictionary f"ur die BBaum a Instanz, 
-- Da die Instanz eine Klassenbeschr"ankung hat
-- erh"alt das Dictionary das entsprechende
-- EqDict-Dictionary als Parameter 

eqDictBBaum :: EqDict a -> EqDict (BBaum a)                                 
eqDictBBaum dict = EqDict {
                    eqEq  = eqBBaum dict,
                    eqNeq = default_eqNeq (eqDictBBaum dict)
              }
 where eqBBaum dict (Blatt a) (Blatt b) = overloadedeq dict a b 
       eqBBaum dict (Knoten l1 r1) (Knoten l2 r2) = eqBBaum dict l1 l2 && eqBBaum dict r1 r2
 
 
-- Instanz f"ur Ordering (brauchen wir unten)

eqDictOrdering = EqDict {
                   eqEq = eqOrdering,
                   eqNeq = default_eqNeq eqDictOrdering
                  }
           where
            eqOrdering LT LT = True
            eqOrdering EQ EQ = True
            eqOrdering GT GT = True
            eqOrdering _  _  = False        

-- Aufl"osung der Ord-Klasse

-- class  (Eq a) => Ord a  where
--     compare              :: a -> a -> Ordering
--     (<), (<=), (>=), (>) :: a -> a -> Bool
--     max, min             :: a -> a -> a
-- 
--     compare x y | x == y    = EQ
--                 | x <= y    = LT
--                 | otherwise = GT
-- 
--     x <= y  = compare x y /= GT
--     x <  y  = compare x y == LT
--     x >= y  = compare x y /= LT
--     x >  y  = compare x y == GT

--     max x y | x <= y    =  y
--             | otherwise =  x
--     min x y | x <= y    =  x
--             | otherwise =  y

-- Da Ord Unterklasse von Eq ist, erh"alt der Dictionary Datentyp das EqDict-Dictionary
-- als Komponente:

data OrdDict a =
 OrdDict {
  eqDict :: EqDict a,
  ordCompare :: a -> a -> Ordering,
  ordL  :: a -> a -> Bool,
  ordLT :: a -> a -> Bool,
  ordGT :: a -> a -> Bool,
  ordG  :: a -> a -> Bool,
  ordMax :: a -> a -> a,
  ordMin :: a -> a -> a
  }

-- default-Implementierungen
default_ordCompare dictOrd x y  
  | (eqEq (eqDict dictOrd)) x y = EQ 
  | (ordLT dictOrd) x y         = LT
  | otherwise                   = GT
  


default_ordLT dictOrd x y = let compare = (ordCompare dictOrd)
                                nequal  = eqNeq (eqDictOrdering)
                            in (compare x y) `nequal` GT
                              
default_ordL  dictOrd x y = let compare = (ordCompare dictOrd)
                                equal    = eqEq eqDictOrdering
                            in (compare x y) `equal` LT 

default_ordGT dictOrd x y = let compare = (ordCompare dictOrd)
                                nequal  = eqNeq eqDictOrdering
                            in (compare x y) `nequal` LT

default_ordG  dictOrd x y = let compare = (ordCompare dictOrd)
                                equal    = eqEq eqDictOrdering
                            in (compare x y) `equal` GT 

default_ordMax dictOrd x y 
 | (ordLT dictOrd) x y = y
 | otherwise           = x
                                                         
default_ordMin dictOrd x y 
 | (ordLT dictOrd) x y = x
 | otherwise           = y

-- Ersatz f"ur "uberladene Operatoren:

overloaded_compare :: OrdDict a -> a -> a -> Ordering
overloaded_compare dict = ordCompare dict

overloaded_ordL    :: OrdDict a -> a -> a -> Bool
overloaded_ordL dict = ordL dict

overloaded_ordLT   :: OrdDict a -> a -> a -> Bool
overloaded_ordLT dict = ordLT dict

overloaded_ordGT   :: OrdDict a -> a -> a -> Bool
overloaded_ordGT dict = ordGT dict

overloaded_ordG    :: OrdDict a -> a -> a -> Bool
overloaded_ordG  dict = ordG dict

overloaded_ordMax  :: OrdDict a -> a -> a -> a
overloaded_ordMax dict = ordMax dict

overloaded_ordMin  :: OrdDict a -> a -> a -> a
overloaded_ordMin  dict = ordMin dict

-- Dictionary f"ur Instanz f"ur Wochentag

ordDictWochentag = OrdDict {
  eqDict = eqDictWochentag,
  ordCompare = default_ordCompare ordDictWochentag,
  ordL  = default_ordL ordDictWochentag,
  ordLT = wt_lt,
  ordGT = default_ordGT ordDictWochentag,
  ordG  = default_ordG ordDictWochentag,
  ordMax = default_ordMax ordDictWochentag,
  ordMin = default_ordMin ordDictWochentag
  }
  where
   wt_lt  a b =  (a,b) `elem` [(a,b) | i <- [0..6], let a = ys!!i, b <- drop i ys]
   ys = [Montag, Dienstag, Mittwoch, Donnerstag, Freitag, Samstag, Sonntag]

-- Achtung: Eigentlich muesste elem noch aufgel"ost werden, etc, z.B.

elemEq :: EqDict a -> a -> [a] -> Bool
elemEq dict e []    = False
elemEq dict e (x:xs)
  | (eqEq dict) e  x   = True
  | otherwise          = elemEq dict e xs


-- Aufl"osung von Functor:


data FunctorDict a b t = FunctorDict {
  functorFmap :: (a -> b) -> t a -> t b
  }
  
overloaded_fmap :: (FunctorDict a b t) -> (a -> b) -> t a -> t b
overloaded_fmap dict = functorFmap dict 

functorDictBBaum = FunctorDict {
 functorFmap = bMap
 }
 
 
class Test a where
 test :: b -> a
 
instance Test Int where
      test = \x ->  0
      
newtype NTP a = NTP a
ntpbot = let x = x in x:: (NTP Int)
--  seq ntpbot 1


---  einige Typentests

tt1:: (f Int) -> (f Char)

-- *Main> :t (tt1 [[1]])
--
-- <interactive>:1:7:
--    Couldn't match expected type `Int' with actual type `[t0]'
--    In the expression: [1]
--    In the first argument of `tt1', namely `[[1]]'
--    In the expression: (tt1 [[1]])

--  *Main> :t (tt1 [1])
--  (tt1 [1]) :: [Char]


tt1 = tt1
 
