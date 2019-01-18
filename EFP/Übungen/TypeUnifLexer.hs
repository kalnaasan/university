module TypeUnifLexer where
import Data.List
import Data.Char
   
--   Lexer   f"ur polymorphe Typen
 
 ---    
 ---   in comb bib ist es aber als String, (int,Int)  
 

---  =========lexer Test:   aktiviere main
-- main = do  cont <- readFile "htmltestkurz.html"
--           return (prelex (linPosNumbering cont))
 

data Token = Token String
    deriving (Eq,Show)


test1 = (prelex . linPosNumbering) $ "(a,b,c,d,e,f,g,h,i,j,k) = " ++ '\n' : 
               "((b,b),(c,c),(d,d),(e,e),(f,f),(g,g),(h,h),(i,i),(j,j),(k,k),(l,l))"
test2 = (prelex . linPosNumbering) $ "[Baum a(Baum c d)]=[Baum c(Baum Bool Bool)]"

test3 = (prelex . linPosNumbering) $ "(aaa,bbb,cc,ddddd,ee,ffff,g,h,i,j,k) = " ++ '\n' : 
               "((b,b),(c,c),(d,d),(e,e),(f,f),(g,g),(h,h),(i,i),(j,j),(k,k),(l,l))"

gettoken (Token t) = t

linPosNumbering inp = 
      let lin0 = cleanstring inp
          lin1 = map (\x -> x ++ ['\n']) (lines lin0) 
          lin = (zip lin1 [1..]) 
          lin2 = map (\(linsin,linnum)-> (map (\(s,sn) -> (s,(linnum,sn))) (zip linsin [1..])))  lin
        in  concat lin2 
            
typeLex = prelex . linPosNumbering


cleanstring [] = []
cleanstring ('\r':'\n':xs) = '\n': cleanstring xs
cleanstring ('\r':xs) = '\n': cleanstring xs
cleanstring (x:xs) = x: cleanstring xs

--  Zustaende:  N:   normal,  W, Wort "A"  Arrow
--  Kann auch 13Tup   einlesen 
 
  --   prelexr:  Zustand, resultatliste, Startpos der Res-liste, zipped-input
  
prelex xs = prelexr "N" [] (0,0) xs       ----   (zip (xs)  [1..]) 

prelexr:: [Char] -> [Char] -> (Int, Int) -> [(Char, (Int,Int))] -> [(Token,(Int,Int))]
prelexr "N" _ _ []              = []
prelexr "W" xs pos []              = [(Token (reverse xs),pos)]
prelexr "A" xs pos []              = error "unvollstaendiger Typ-Pfeil am Ende"

prelexr "N" _ _ ((a,apos):rs)   
  | isSpace a  =    prelexr "N" [] (0,0) rs
  | isAlphaNum a  =    prelexr "W" [a] apos rs
  | a == '-'   =    prelexr  "A" [a] apos  rs
  | a `elem` "([]),="  =    (Token [a],apos) : prelexr  "N" [] (0,0) rs
  | otherwise  =    error ("N;falsches Symbol in Typ: "++ [a] ++ " an " ++ (show apos))

  
prelexr "W" xs pos ((a,na):rs)  
  | isSpace a            =   (Token (reverse xs), pos) :  prelexr "N" [] (0,0) rs
  | a `elem` "([]),-="   =   (Token (reverse xs), pos) :  prelexr "N" [] (0,0) ((a,na):rs)
  | isAlphaNum a            =  prelexr "W" (a:xs) pos rs 
  | otherwise            =   error ("W,falsches Symbol in Typ: "++ [a])

prelexr "A" xs pos ((a,na):rs)  
  | a == '>'   =   (Token "->", pos) :  prelexr "N" [] (0,0) rs
  | otherwise  =   error ("A,falsches Symbol in Typ: "++ [a] ++  ", aber > erwartet")
  

prelexr x1 x2 x3 x4 = error ("darf nicht vorkommen: " ++ (show (x1,x2,x3,x4)))
 --  Kommentar-Ende Token muss gefunden werden:

