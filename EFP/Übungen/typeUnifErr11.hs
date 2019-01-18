import Prelude hiding ((<*>),(*>),(<*))
import Data.List
import Data.Char
import TypeUnifLexer
import CombParserWithError11       
 
--   Parser f"ur polymorphe  Typen
--    Namen die mit Gro"sbuchstaben anfangen sind Typkonstruktoren,
--    Variablen: Namen die mit Kleinbuchstaben beginnen
--    
--   Aufrufe:   
--     parseEquation   inp
--                 gibt  Syntaxbaum aus
--     printUnif      inp
--                 parst, berechnet Unifilator und druckt den Unifikator
--
--    Kann nun auch Fehler-Position ausgeben in der semantischen Analyse
--    da der Syntaxbaum die Fehlerposition enthaelt
--
--    printUnifMul inp outtype  
--        inp ist Komma-separierte Liste von Geichungen, 
--           outtype   der Typ auf den der Unifiator angewendet werden soll
-- Beispiele

--   Achtung beim Testen:  Blanks werden erst durch prelex korrigiert" 
--   prelex hat kleine Macken: noch testen


-- main = do cont <- readFile  "typtest1.txt"  
--          print ((prelex . linPosNumbering) $ cont)
 --         printUnif cont 
          
main = do cont <- readFile  "typtest1.txt"  
          printUnif cont                     
          
ex1   = printUnif  "[a] = [b]"
ex2   = printUnif  "[a] = [Bool]"
ex3   = printUnif  "[Baum a b] = [Baum c (Baum Bool Bool)]"
ex4   = printUnif  "[Baum a (Baum c d)] = [Baum c (Baum Bool Bool)]"
ex5   = printUnif  "[Baum a (Baum c d)] = [Baum c a]"
ex6   = printUnif  "[a->(b->c)]  = [d->e]"
ex7   = printUnif  "[(a,b)]  = [(Bool,Farben)]"
ex8   = printUnif  "a -> b -> c = (Bool -> Bool) -> ([Int -> a]) -> f"
ex9   = printUnif  "d = (Baum a (Baum b c))"
ex10  = printUnif "(a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a) = (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)"
ex11str  = "Baum a -> Baum a -> [a] = Baum b -> Baum b -> [b]"
ex11  = printUnif ex11str
ex12input = "(a,b,c,d,e,f,g,h,i,j,k) = ((b,b),(c,c),(d,d),(e,e),(f,f),(g,g),(h,h),(i,i),(j,j),(k,k),(l,l))"
ex12 = printUnif ex12input
--  oder in ghci:    :t (let  (a,b,c,d,e,f,g,h,i,j,k) = ((b,b),(c,c),(d,d),(e,e),(f,f),(g,g),(h,h),(i,i),(j,j),(k,k),(1,True)) in a)

ex13 =  printUnif "a -> d = c -> Bau a b"
ex14 = printUnif "(a,b,c,d,e,f,g,h,i,j,k,kk,kkk,kkkk,kkkkk,kkkkkk) = aa"

exmaptyp = "(a->b) -> [a] -> [b]" 
exfoldrtyp = "(a1 -> b1 -> b1) -> b1 -> [a1] -> b1"
exfoldltyp = "(a2 -> b2 -> a2) -> a2 -> [b2] -> a2"

ex20 = printUnif (exmaptyp ++ "=" ++ "(" ++  exfoldrtyp ++ ")-> c1")
ex21 = printUnif (exfoldrtyp ++ "=" ++  exfoldltyp)
exstrict = printUnif ("(a,b,c->d,) = a" ++ bot)
bot = bot

exerr1   =  extractParse  (parseEquation "(a,a,a, ")
exerr2   =  extractParse  (parseEquation  "(a,a,a]")
exerr3   =  extractParse  (parseEquation  "(a,a,a)))")
exerr4   =  extractParse  (parseEquation  "(a,b) = [(a,a,a]")
exerr5   =  extractParse  (parseEquation  "(a,b) = [(a,a,a)])")
exerr6   =  extractParse  (parseEquation  "((a,b) = [(a,a,a)])")
exerr7   =  printUnif "a -> Bau = c -> Bau a b"


-- Datentyp fuer Terme    mit Fehlerpos als letztem Arg

data Term = Fn String [Term] (Int,Int)
          | Var String (Int,Int)
          deriving (Eq)

getTermTopName (Fn x y z) = x
getTermTopName (Var x y) = x

-- Show-Instanz fuer Terme
instance Show(Term) where
 show (Fn f [] _) = f
 show (Fn f args _) = if f == "->" then
                      "(" ++ (show (head args)) ++ " " ++ f ++ " " ++ (show (head (tail args)))  ++ ")"
                    else if f == "[]" then 
                       "[" ++ (show (head args)) ++  "]"
                    else if null args   then 
                        " " ++ f ++ " "
                     else
                       "(" ++ f ++ " " ++ concat (intersperse " " $ map show args) ++")"
 
 show (Var v _) = v

 
instance Read(Term) where 
   readsPrec p = \r -> let res1 = parseAT . typeLex $ r
                           res2 = if null res1 then error "impossible "
                                  else head res1
                           (res3,resrest) = case res2 of (_,Perror (pos,errStr)) -> error (errStr ++ " an Pos " ++ show pos )
                                                         (rest,POK term er) -> (term,rest)
                        in if null res1 
                           then  []
                           else [(res3,concatMap (gettoken .fst) resrest)]
                      

-- ==================================
--- Unifikation

unify :: [(Term,Term)] -> Maybe [(String,Term)] 
unify [] = Just []
unify (((Fn a argsA er1),(Fn b argsB er2)):xs) 
 | a == b    = if (length argsA) == (length argsB) then  unify $ (zip argsA argsB) ++ xs 
               else error ("Falsche Argumentzahl des Typkonstrukturs an Pos "++ (show er1))
 | otherwise = Nothing

unify ((Var v _,Var v' _):xs) 
 | v == v' = unify xs
unify ((Var v _,t):xs) 
 | v `occursInNonVar` t = Nothing
 | otherwise            = case unify (map (\(l,r) -> (subst v t l, subst v t r)) xs) of 
                            Just  ys -> Just ((v,apply ys t):ys)
                            _        -> Nothing

unify ((t,Var v er):xs)  = unify ((Var v er,t):xs)

unify x = error "Error in unify: "$ show x


occursInNonVar  v (Var _ _) = False
occursInNonVar  v t       = v `elem` (varsOf t)

varsOf (Var v _) = [v]
varsOf (Fn f args _) = concatMap varsOf args

-- Substitution
apply []         t2 = t2
apply ((v,t):xs) t2 = apply xs (subst v t t2)

subst v t (Var v' er)
 | v == v'       = t
 | otherwise     = Var v' er
subst v t (Fn f args er) = Fn f (map (subst v t) args) er

--unify_vollinstanz xs = 
--   let unif = unify xs
--   in case unif of Nothing -> Nothing
 --                  Just un -> Just (unifErs un  un)
 
unifErs xs [] = xs
unifErs xs (y:ys) = unifErs (unifErs1 y xs) (unifErs1 y ys) 
unifErs1:: (String,Term) -> [(String,Term)] -> [(String,Term)] 
unifErs1 (v,t) ys = map (\(vv,tt) -> (vv,subst  v t tt)) ys

unifToString :: (Show t) => Maybe [([Char], t)] -> [Char]
unifToString unif = case unif of Nothing -> "Kein Unifikator"
                                 Just xs -> unifComplistToString xs

unifComplistToString [] = []
unifComplistToString ((v,t):xs) = 
        if null xs then v ++ " |-> " ++ (show t)  
        else v ++ " |-> " ++ (show t)  ++ "; " ++  unifComplistToString  xs       
        
unifytest :: [(Term, Term)] -> Maybe [(String, Term)]
unifytest x = error ("unif" ++ show x)
-- ==================================
--  Prueffunktionen fuer gleiche Stelligkeit der TC
-- findTCarity :: Term -> [(String,[Int],(Int,Int))]
findTCarity t = findTCarityr t [] 
findTCarityr :: Term -> [(String,[Int],(Int,Int))] -> [(String,[Int],(Int,Int))]
findTCarityr (Var _ _) plist  =  plist
findTCarityr (Fn tc arglst pos) plist  =  
    findTCarityrlst arglst (insertplist tc (length arglst) pos plist)
findTCarityrlst:: [Term] -> [(String,[Int],(Int,Int))] -> [(String,[Int],(Int,Int))]
findTCarityrlst [] plist = plist
findTCarityrlst (t:ts)  plist = findTCarityrlst ts  (findTCarityr t plist)

-- insertplist:: a -> b -> c -> d -> [e]
insertplist key  len pos [] = [(key,[len],pos)]
insertplist key  len pos ((fkey,flen,fpos):rest) = 
       if fkey == key then  (if len `elem` flen then (key, flen,fpos) : rest
                             else (key,len:flen,fpos) : rest)
       else  (fkey,flen,fpos): insertplist key len pos  rest 

checkTcArity t = 
    let plist =  findTCarity t 
     in checkTcArityf plist
--checkTcArityf:: [(String,[Int],Int)] -> Maybe (String,Int)
checkTcArityf [] = Nothing
checkTcArityf ((key,lens,pos):rest) = if length lens > 1 then Just (key,pos)
       else checkTcArityf  rest 
checkTcArityEq (t1,t2) =  
    let plist1 =  findTCarity t1
        plist2 =  findTCarityr t2 plist1
     in checkTcArityf plist2
extractcheckTCerr (Just (key,pos)) =
       "Typkonstruktor " ++ key ++ " an Position  " ++ show pos ++ " mit inkonsistenter Stelligkeit"
       
checkTcArityEqs eqs =  
    let termliste = concatMap (\(x,y) -> [x,y]) eqs
        plist  =  foldr findTCarityr [] termliste
     in checkTcArityf plist 
-- ==========================
-- ==========================
-- Druckfunktionen

 
 

printUnif  inp  = do 
                 let outp = compUnifier inp
                 let eq =  extractParse (parseEquation inp)
                 let ariErr = checkTcArityEq eq
                 putStrLn "Gleichung:"
                 putStrLn "==============================="
                 putStrLn  (cleanstring inp)
  --               print (cleanstring inp)
  --               print  inp
                 putStrLn  " "
                 putStrLn "geparste Gleichung:"
                 putStrLn "==============================="
                 putStrLn  (show eq)
                 putStrLn  " "
                 if (ariErr /= Nothing)
                   then  do 
                           error (extractcheckTCerr ariErr)
                   else do putStrLn  " "
                 putStrLn "Unifikator:"
                 putStrLn "==============================="
                 putStrLn (unifToString outp)
                 putStrLn  " "
                 if (outp /= Nothing)
                     then   do 
                              putStrLn "Instanz-Typ:"
                              putStrLn "==============================="
                              putStrLn (show (apply (case outp of Just x -> x)  (fst eq )))
                     else   do   putStrLn  " "
 
 
printUnifMul inp outtype  = 
             do 
                 let outp = compUnifierMul inp
                 let eqs =  extractParse (parseEquations inp)
                 let ariErr = checkTcArityEqs eqs
                 let resulttype = extractParse (parseType outtype)
                 putStrLn "Gleichungen:"
                 putStrLn "==============================="
                 putStrLn  (cleanstring inp)
  --               print (cleanstring inp)
  --               print  inp
                 putStrLn  " "
                 putStrLn "geparste Gleichungen:"
                 putStrLn "==============================="
                 putStrLn  (show eqs)
                 putStrLn  " "
                 if (ariErr /= Nothing)
                   then  do 
                           error (extractcheckTCerr ariErr)
                   else do putStrLn  " "
                 putStrLn "Unifikator:"
                 putStrLn "==============================="
                 putStrLn (unifToString outp)
                 putStrLn "Instanz:"
                 putStrLn "==============================="
                 putStrLn ("instanziiert wird: "  ++(show resulttype))
                 putStrLn ("instanziierter Typ:" ++ (show (apply  (extractMaybe outp)  resulttype)) )
                   

---  ein BeispielAufruf aus der Typisierung von map: (Vorlesung EFP:)
---  
{-
let mapListe1 =  "a6 -> [a6]  ->  [a6] = a3  ->  a7, a7 = a4  ->  a8, a11 = a13 ->  a14,"
let mapListe2 =  " a10  ->  [a10] ->  [a10] = a15  ->  a11,a1 = a3  ->  a15, beta = a1  ->  a12,"  
let mapListe3 =  "a12 = a4  ->  a13, a2 = [a5], a2 = a8, a = a9, a = a14," 
let mapListe4 =  "beta = a1  ->  a2  ->  a "
let mapListe =  mapListe1 ++ mapListe2 ++mapListe3 ++mapListe4

mapTypExample = printUnifMul mapListe "a1 -> a2 -> a"
-}
--  ================================
compUnifierMul inp = let eq =  parseEquations inp
                  in 
                    case eq of POK eqr _  ->  unify  eqr      
                               Perror (pos,err)  ->  error (err ++ " an  Position:" ++ (show  pos))
                               
extractParse pres =    
       case pres of POK eqr _  ->   eqr
                    Perror (pos,err)  ->  error (err ++ " an  Position:" ++ (show  pos))

extractParseL [] = error "kein Parse (und keinen Fehler) gefunden"
extractParseL ((_,pres):_) =    
       case pres of POK eqr er  ->  (error ("Fehler an Pos " ++ show er))   `seq` eqr
                    Perror (pos,err)  ->  error (err ++ " an  Position:" ++ (show  pos))
                                                  
compUnifier inp = let eq =  parseEquation inp
                  in 
                    case eq of POK eqr _  ->  unify   [eqr]      
                               Perror (pos,err)  ->  error (err ++ " an  Position:" ++ (show  pos))

parseEquation inp  = let parseRes = (just parseEQ) (typeLex inp)
                      in if null parseRes then
                            error "Kein Parse gefunden"
                      else (snd . head) parseRes         

parseType inp  = let parseRes = (just parseAT) (typeLex inp)
                      in if null parseRes then
                            error "Kein Parse gefunden"
                      else (snd . head) parseRes   


parseEquations inp  = let parseRes = (just parseEQs) (typeLex inp)
                      in if null parseRes then
                            error "Kein Parse gefunden"
                      else (snd . head) parseRes      
                       

extractMaybe Nothing = error "???"
extractMaybe (Just x)  = x
-- einfachste Grammatik  (linksrekursiv)

{-
EQ := AT = AT
AT :=  AT -> AT | (AT) | Var | TCA
TCA := TC | (TC AT .... AT) | [AT]  | (AT_1,...,AT_n), n > 1
-}
-- Grammatik  (nicht linksrekursiv)

{-
EQ := AT = AT
AT :=  KT -> AT | (AT) | ST
KT := (AT) | ST 
ST  := Var | TCA
TCA := TC | (TC AT .... AT) | [AT] | [TC AT ... AT] | (AT_1,...,AT_n), n > 1
-}

{-
EQ := AT = AT
AT :=  KT -> AT | (AT) | ST
KT := (AT) | ST 
ST  := Var | TCA
TCA := TC | (TC TCA .... TCA) | [AT] | [TC TCA ... TCA] | (AT_1,...,AT_n), n > 1
-}


-- Grammatik (praediktiv  optimiert) 

{-
EQ := AT = AT
AT :=  NOAR  {NOARNX | epsilon} 
NOARNX := -> AT
NOAR   := Var | TCT | KLRUND | KLECK
NOARTC   := Var | TC  | KLRUND | KLECK
--  TCT := TC NOAR ... NOAR          max weit: Trennzeichen Blank!
TCT := TC NOARTC ... NOARTC          max weit: Trennzeichen Blank!
KLRUND := (AT_1,...,AT_n)   bei n = 1  normaler Type, bei n > 1  ein Tupeltyp
KLECK  := [AT]     Listentyp
-}
       
-- Kombinatoren

parseEQ  = (((parseAT <*>! "= erwartet ") (((parseSymbol '=') *>! "zweiter Typ der Gleichung fehlt") parseAT))
              <*! "Ueberfluessige Symbole") end

parseAT =     ((parseNOAR <*> (manyex  parseNOARNX)) <@@ (\(t1,t2) er -> if null t2 then t1 else Fn "->" (t1:t2) er))

parseNOARNX =   ((satisfy tokenIsArrow)  *>! "Zweiter Funktionstyp nach -> fehlt") parseAT

parseNOAR = parseVar <|> parseTCT <|>  parseKLRUND <|>  parseKLECK

parseNOARTC = parseVar <|> parseTC <|>  parseKLRUND <|>  parseKLECK

parseTCT = (parseTC <*>  (manyex parseNOARTC)) 
           <@@ (\(t1,t2) er -> if null t2 then Fn (getTermTopName t1) [] er else Fn (getTermTopName t1) t2 er) 

parseKLRUND =  (parseSymbol '('  *> (parseINKLRUND <*! ") erwartet")  (parseSymbol ')')) <@ id
parseINKLRUND = (parseAT <*> (manyex (((parseSymbol ',') *>! "Typ nach , erwartet") parseAT)))
                   <@@ (\(t1,t2) er -> if null t2 then t1 else   (Fn ("Tup"++(show ((length t2) +1))) (t1:t2) er))

parseKLECK =  (parseSymbol '[' *> ((parseAT <*! "] erwartet")  (parseSymbol ']')) <@@ \t er -> Fn "[]" [t] er)

parseVar = satisfy tokenIsVar <@@  \x er   -> Var (gettoken x) er      --  <@@ (\(x,xs) er  -> Var (x:xs) er) 
parseTC = satisfy tokenIsTC <@@ \x er   -> Fn (gettoken x) [] er 

parseSymbol s = satisfy (\t -> gettoken t == [s])

tokenIsArrow t =  (gettoken t) == "->"
tokenIsKomma t =  (gettoken t) == ","
tokenIsVar t =  case (gettoken t) of [] -> error "tokenIsVar: darf nicht vorkommen"
                                     (x:xs) -> isAlpha x && isLower x
tokenIsTC t =  case (gettoken t) of [] -> error "tokenIsTC: darf nicht vorkommen"
                                    (x:xs) -> isAlpha x && isUpper x                   

--  mehrere Gleichungen
parseEQs =  ((parseEQsingle <*> (manyex  parseKommaEQ)) <@@ (\(t1,t2) er -> if null t2 then  [t1] else (t1:t2)))
parseKommaEQ =   ((satisfy tokenIsKomma)  *>! "Gleichung nach Komma fehlt") parseEQsingle

parseEQsingle  = ((parseAT <*>! "= erwartet ") (((parseSymbol '=') *>! "zweiter Typ der Gleichung fehlt") parseAT))
            
              
-- parseVar = ((lower <*> manyex alphanum) <@@ \(x,xs) er  -> Var (x:xs) er) 
-- parseTC = (upper  <*> manyex alphanum <@ (\(x,xs) -> (x:xs)))



{-
 Testaufrufe
   :t foldr
   
  parseAT   . typeLex $  "(a -> b -> a) -> a  -> [b] -> a"
  
 ((parseAT <*! "zuviele ")  end) . typeLex $  "(a -> b -> a) -> a a -> [b] -> a"
 
 Main> parseAT   . typeLex $ "a->  b,c -> d"
[([(',',7),('c',8),('-',10),('>',11),('d',13)],POK (a -> b) 0)]
*Main> parseAT   . typeLex $ "a->  b c -> d"
[([(' ',7),('c',8),('-',10),('>',11),('d',13)],POK (a -> b) 0)]
*Main> parseAT   . typeLex $ "a->  b -> c -> d"
[([],POK (a -> (b -> (c -> d))) 0)]
*Main> parseAT   . typeLex $ "a->  b -> Baum  c -> d"
[([],POK (a -> (b -> ((Baum c) -> d))) 0)]
*Main> parseAT   . typeLex $ "[[a->  b -> Baum  c -> d]]"
[([],POK [[(a -> (b -> ((Baum c) -> d)))]] 0)]
*Main> parseAT   . typeLex $ "((([[a->  b -> Baum  c -> d]])))"
[([],POK [[(a -> (b -> ((Baum c) -> d)))]] 0)]
*Main> parseAT   . typeLex $ "((([[a->  b -> Baum  c -> d]])),Int)"
[([],POK (2-Tup [[(a -> (b -> ((Baum c) -> d)))]] Int))]
 
printUnif  "[(a,b)]  = [(Bool,Farben)]" 
 
 unify [(read "a->b->c", read "d->e")]

    map-Typ  =  filter-Typ:
    
printUnif "(a -> b) -> [a] -> [b] = (a1 -> Bool) -> [a1] -> [a1]"
-}

exampletypes = [("map","(a -> b) -> [a] -> [b]"),("length","[a]->Int"),(".","(b -> c) -> (a -> b) -> a -> c")]

printAppType s1 s2 =
   let t1 = case (lookup s1 exampletypes) of 
              Just x -> x
              Nothing-> error ("Typ von " ++ (show s1)++" fehlt in Tabelle")
       t2 = case (lookup s1 exampletypes) of 
               Just x -> x
               Nothing-> error ("Typ von " ++ (show s1)++" fehlt in Tabelle")
       pt1 = parseType t1 
       (tt11,tt12) = case pt1 of POK (Fn pfeil tlst tpos) _ -> (show (head tlst), show (tlst !! 1))
     in printUnif (tt11 ++ "=" ++ (typerenamed "x" t2))
       
typerenamed prefix inptype =
   let pt1 = parseType inptype    
       pt11 =  case pt1 of POK x _ -> x
     in show (typerename prefix pt11)
     
typerename prefix (Fn str t2 pos) = (Fn str (map (typerename prefix) t2) pos) 
typerename prefix (Var str pos)  = (Var (prefix ++ str) pos)
   
