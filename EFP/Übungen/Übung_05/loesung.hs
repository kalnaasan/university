module Speicherzelle where
import Text.Read(read, readMaybe)
import Data.Maybe

{-|
   Die Speicherzelle solle Zwischenwerte bei Berechnungen als String speichern 
   und wiederherstellen können, d.h. wenn die Werte in der Typklasse Read sind, sollen sie wiederherstellbar sein.
   Gehen Sie davon aus, das show und read invers zu einander sind,
   also show . read == id für Instanzen von Show und Read.
-}
class Speicherzelle c where
    -- 1) Geben Sie default Implementierungen an:
    -- 1a)
    -- | Speichere einen Wert in der Zelle mit leerer Historie
    speicher :: Show a => a -> c a
    speicher x = load x []
    
    -- 1b)
    {-| 
       Wenn der letzte Zwischenwert vom Typ b ist, soll er wiederhergestellt werden.
       Die Historie soll ebenfalls wiederhergestellt werden (also einen Schritt zurück springen).
       Wenn der letzte Wert nicht vom Typ b ist, soll Nothing zurück gegeben werden.
    -}
    revert :: (Show b, Read b) => c a -> Maybe (c b)
    revert m 
      | null hist = Nothing
      | otherwise = case readMaybe (head hist) of
         Just x -> load x (tail hist)
         Nothing -> Nothing
      where
         hist = historie m

    -- 2) Nicht hier sondern unten bearbeiten.
    -- 2a)
    {-| 
       (-->) erwartet eine Speicherzelle und 
            eine Funktion, die einen Wert berechnet und sich dabei die Zwsichenwerte wieder in einer
            Speicherzelle merkt.
            Anschließend gibt sie eine Speicherzelle mit der gesamten(kombinierten) Historie zurück. 
    -}
    (-->) :: (Show a, Show b) => c a -> (a -> c b) -> c b
    
    -- 2b)
    -- | Erstelle eine Zelle mit Historie
    load :: Show a => a -> [String] -> c a
    
    -- 2c)
    -- | Der head der Liste, sollte der letzte Zwischenwert sein.
    historie :: c a -> [String]    
      
    -- Hilfe (man braucht die Funktion nicht wirklich)  
    -- | Transformiert den Inhalt einer Zelle und speichert den Wert
    (<$$>) :: (Show a, Show b) => (a -> b) -> c a -> c b
    f <$$> z = z --> (\x -> speicher (f x))
    
    
-- Ein Dummy Beispiel    
data Dummy a = DumDum a deriving(Eq, Show)
 
instance Speicherzelle Dummy where
    (DumDum x) --> f = f x
    load x _ = DumDum x
    historie _ = []
    speicher x = DumDum x
    revert _ = Nothing
            
-- Aufgabe 2
-- Hier implementieren
data Memory a = Memory a [String] deriving (Show)
-- Memory :: * -> *
instance Speicherzelle Memory where 
   load a bs = Memory a bs
   historie (Memory _ bs) = bs
   (-->) (Memory x ls) f = let Memory y ls' = f x
      in Memory y (ls' ++ (show x):ls)


-- Aufgabe 3
-- Zur Erinnerung
collatz 1 = 1
collatz n = if even n 
             then collatz (n `div` 2) 
             else collatz (3*n+1)


collatzS :: Speicherzelle c => Int -> c Int
collatzS 1 = speicher 1
collatzS n = speicher n --> (\a -> if even a then collatzS (n `div` 2)
   else collatzS (3*n+1))
                
{-             
Folgende Eigenschaften können zum Testen benuttzt werden

historie ((collatzS 12) :: Memory Int) == ["2","4","8","16","5","10","3","6","12"]

historie . fromJust $  ((revert (collatzS 12)) :: Maybe (Memory Int)) == ["4","8","16","5","10","3","6","12"]
-}


-- ###############
-- ##:info Show ##
-- ###############