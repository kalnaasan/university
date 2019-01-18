{-
   Eine Kombinatorbibliothek mittels Parser-Kombinatoren  
   Jeder Teilparser akzeptiert eine indizierte Liste  [(a,(Int,Int)]  Zeile und Position in Zeile
       und gibt eine Liste aus Paaren zurueck:
              (Reststring, Parse-Ergebnis)
    Die Infix-Funktionen  <*>, <*, *>,  <*>!,<*!,*>!  koennen jeweils 2 Parser kombinieren
        und parsen; erst Parse 1, dann Parser 2, 
         der Unterschied liegt in der Weitergabe der Ergebnisse;
          die Parser mit Ausrufezeichen akzeptieren nur die erste Moeglichkeit 
    Die Infix-Funktionen  <|>, <!>   kombinieren Parser als alternative Moeglichkeiten
    der erste untersucht beide Moeglichkeiten, und  <!> nimmt maximal eine erfolgreiche.
    
    Kann   FehlerPosition genauer angeben
    
    Fehler-Pos ist im Syntaxbaum als Attribut
    
    Um einen deterministischen Parser zu erhalten, darf <|>   nicht vorkommen
-}

module CombParserWithError11  where
import Prelude hiding ((<*>),(*>),(<*))
import Data.Char

type ToL = [(Char, (Int,Int))] 

infixr 6 <*>, <*, *>,<*>!,<*!,*>!
infixr 4 <|>, <!>
infixl 5 <@, <@@

data ParseRes a = POK a (Int,Int)| Perror ((Int, Int), String)        --  Position Zeile Spalte Fehler
-- data ParseRes a = POK a Int | Perror  (Int,String)       --  Position Zeile  Fehler
    deriving (Show)
    
type Parser a b = [a] -> [([a],ParseRes b)]

       
-- symbol :: Eq s => s -> Parser s s
symbol a []                      = []
symbol a (x:xs)  | a == fst x         = [(xs,POK (fst x) (snd x))]
                 | otherwise     = []

-- token :: Eq s => [s] -> Parser s [s]
--  token :: Eq s => [s] -> Parser s [s]
token k xs | k == (map fst (take n xs))    = [(drop n xs, POK k (snd (head xs)))] 
           | otherwise           = []
                                 where n = length k
                                 
-- tokenulc :: Eq s => [s] -> Parser s [s]
--  vergleicht ohne auf upper/lower-case zu achten
tokenulc k xs | (map toUpper k) == (map (toUpper.fst) (take n xs))    = [(drop n xs, POK k (snd (head xs)))] 
           | otherwise           = []
                                 where n = length k                                

-- satisfy :: (s -> Bool) -> Parser s s
satisfy p [] = []
satisfy p (x:xs) = [(xs,POK (fst x) (snd x)) | p (fst x)]

--  parser nur erfolgreich, wenn erstes token b erfuellt
constraintp  b p (x:xs)  = if b (fst x) then p xs else [] 
   
--epsilon :: Parser s ()
epsilon xs = [(xs,POK () (snd (head xs)))]

--succeed :: r -> Parser s r
succeed v xs = [(xs,POK v (snd (head xs)))]

end xs = if null xs then [(xs,POK () (-1,-1))] else []

--pfail :: Parser s r
pfail xs = []

--parselCondErr :: Parser s r
--  damit kann man nach einem  Test (p:Token -> Bool) mit Fehler abbrechen
parseCondErr p errstr [] = []
parseCondErr p errstr (x:xs) = 
     let extras = ":  " ++ (take 20 (show (fst x)))
     in
      if (p (fst x)) then [(x:xs,Perror (snd x,errstr++extras))] else []

---infixr 6 <*>, <*, *>, <<*>>
--- infixr 4 <|>

(<*>) :: Parser s a -> Parser s b -> Parser s (a,b)
-- (p1 <*> p2) xs = [(xs2, POK (v1,v2)) 
--                 | (xs1,v1) <- p1 xs,
--                   (xs2,v2) <- p2 xs1]
(p1 <*> p2) xs = concatMap (combStarParser p2) (p1 xs)
combStarParser :: Parser s b ->  ([s],ParseRes a) -> [([s],ParseRes (a,b))]
combStarParser p2 (xs1,POK v1 er1) = map (combStarParserRes  (xs1,v1,er1))  (p2 xs1)
combStarParser p2 (xs1,Perror r)  = [(xs1,Perror r)]
combStarParserRes (xs1,v1,er1) (xs2,POK v2 er2)  = (xs2,POK (v1,v2) er1) 
combStarParserRes (xs1,v1,er1) (xs2,Perror t) = (xs2,Perror t)

--  Wenn p1 parst, dann darf p2 nicht fehlschlagen:
--(<*>!) :: Parser ToL a -> String -> Parser ToL b -> Parser ToL (a,b)
(<*>!) p1 errStr p2 xs  = concatMap (combStarParserB p2 errStr xs) (p1 xs)
-- combStarParserB :: Parser s b -> String -> ([s],ParseRes a) -> [([s],ParseRes (a,b))]
combStarParserB p2 errStr xs  (xs1,POK v1 er1)  = 
      let res2 = p2 xs1 
          errpos = if not (null xs1) then (snd (head xs1)) 
                   else     if not (null xs) then snd (last xs) else (99999,99999)
      in 
        if null res2 
        then [(xs1, Perror  (errpos,errStr))] 
        else  map (combStarParserRes (xs1,v1,er1))  res2
combStarParserB p2 errStr xs  (xs1,Perror r)  = [(xs1,Perror r)]       

-- inputEndPos xs1 = (sum (map (\x -> if x == '\n' then 1 else 0) xs1), length (takeWhile (\x -> x /= '\n') (reverse xs1)))
                   
--(<|>) :: Parser s a -> Parser s a -> Parser s a
(p1 <|> p2) xs = p1 xs ++ p2 xs

--   nimmt nur das erste Ergebnis einer Alternative:   
--(<!>) :: Parser s a -> Parser s a -> Parser s a
(p1 <!> p2) xs = take 1 (p1 xs ++ p2 xs)

--sp :: Parser Char a -> Parser Char a
sp p = p . dropWhile (== ' ')

--  wsp entfernt Leerzeichen  
--wsp :: Parser Char a -> Parser Char a
wsp p = p . filter (\x -> not (x == ' ' || x == '\n'))

--just :: Parser s a -> Parser s a
just p = (filter (\x -> ((null . fst) x || parseError x))) .  p

parseOK (_,POK _ _) = True
parseOK  _         = False

parseError (_,Perror _) = True
parseError _         = False
 
-- infixl 5 <@ 

-- (<@) :: Parser s a -> (a-> b) -> Parser s b

-- (p <@ f) xs = [(ys, f v) | (ys,v) <- p xs]
(p <@ f) xs =  map (combResAt f)  (p xs) 
combResAt f (ys, POK v er) = (ys, POK (f v) er)
combResAt f (ys, Perror t) = (ys, Perror t)

--    Fehlerposition geht in f ein
-- infixl 5 <@@ 

-- (<@@) :: Parser s a -> (a->Int -> b) -> Parser s b 

-- (p <@@ f) xs = [(ys, f v) | (ys,v) <- p xs]
(p <@@ f) xs =  map (combResAtAt f)  (p xs) 
combResAtAt f (ys, POK v er) = (ys, POK (f v er) er)
combResAtAt f (ys, Perror t) = (ys, Perror t)

       
--(<*) :: Parser s a -> Parser s b -> Parser s a
p <* q = p <*> q <@ fst

--  der  zweite parser darf nicht fehlschlagen
--(<*!) :: Parser s a -> String -> Parser s b -> Parser s a
(<*!) p errStr q = ((p <*>! errStr)  q)  <@ fst

--(*>) :: Parser s a -> Parser s b -> Parser s b
p *> q = p <*> q <@ snd

--(*>!) :: Parser s a -> String -> Parser s b -> Parser s b
(*>!) p errStr q = ((p <*>! errStr) q) <@ snd

list (x,xs) = x:xs

-- many :: Parser s a -> Parser s [a]
many p = p <*> many p <@ list
        <|> succeed []

many1 p = p <*> many p <@ list

--  manyCond p cond :  cond ist ein praedikat, wird angewendet auf Anzahl $n$ der Parses, wenn eine 
--  Liste der Ergebnisse produziert wird
--    zB  (== 10)
manyCond p cond inp =  let manyparser = p <*> many p <@ list  <|> succeed []    
                           res = (manyparser inp)   
                           resFiltered = filter (\(x,POK y _) -> cond (length y)) res
                         in resFiltered 

--      manyEqN p n liefert einen Erfolg, wenn Parser p n-mal erfolgreich ist, und liefert auch genau das
--      evtl. ineffizient, da er nicht stoppt, wenn er n geliefert hat, sonder weiterparst und dann verwirft                    
manyEqN p n =  manyCond p (== n)   
        
-- digit :: Parser Char Integer
-- digit::Integral a => Parser Char a
digit ::Integral a =>  [(Char, (Int, Int))] -> [([(Char, (Int, Int))], ParseRes a)]
digit = satisfy isDigit <@ f
         where f c = toEnum (ord c - ord '0')

upper = satisfy isUpper <@ id
lower = satisfy isLower <@ id
alphanum = satisfy isAlphaNum <@ id
notupper = satisfy (\x -> isAlphaNum x && not(isUpper x)) <@ id

--natural :: Parser Char Integer
natural :: Integral a =>  [(Char, (Int, Int))] -> [([(Char, (Int, Int))], ParseRes a)]
natural = many1 digit <@ foldl f 0
             where f a b = a*10 + b

-- manyex many1ex  parsen maximal weit ohne backtracking
--  Z.B.  naturalex 1234   ergibt nur 1234, nicht 1234, 123, 12, 1,[] 
--  Ist nur erlaubt, wenn die Grammatik diese Alternativen nicht benoetigt
    
--manyex :: Parser s a -> Parser s [a]
manyex p = p <*> many p <@ list
        <!> succeed []
        
--   mindestens 1 muss da sein
many1ex p = p <*> manyex p <@ list
option p = p <@ (\x->[x])
           <!> epsilon <@ (\x-> [])

--naturalex :: Parser Char Integer
naturalex :: Integral a =>  [(Char, (Int, Int))] -> [([(Char, (Int, Int))], ParseRes a)]
naturalex = many1ex digit <@ foldl f 0
             where f a b = a*10 + b

--pack:: Parser s a -> Parser s b -> Parser s c -> Parser s b
pack s1 p s2 = s1 *> p <* s2

opSeqInf psymb parg = (parg  <*> many (psymb *> parg))  <@ list

opSeqInfWE psymb parg txt = (parg  <*> manyex ((psymb *>! txt) parg))  <@ list

paarf f = \(x,y) -> f x y


 
