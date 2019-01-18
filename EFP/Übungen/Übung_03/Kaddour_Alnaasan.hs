-- Kaddour Alnnasan
-- 04.10.2018
-- Übung_02

-- Aufgabe_01
-- t = (((x:caseList x of fNil ! Nil; (Cons y ys) ! (y y)g) (Cons (z:z) Nil)) True)


-- Aufgabe 2
-- a)7,10 b) 5,6,9,10 c) 10  d) 10 e) 7,8,10

import Data.List

-- Datentyp fuer KFPT-Ausdruecke:
data Expression = 
    Variable String       
  | Lambda String Expression 
  | Application Expression Expression
  | CaseBool Expression Expression Expression
  | CaseList Expression Expression (String,String,Expression)
  | CONS Expression Expression                               
  | NIL                         
  | TRUE                        
  | FALSE                       
  deriving(Eq,Show)

-- Parallele Substitution (ohne Alpha-Umbenennung)  
-- Typ fuer Substitutionen: Listen von Paaren 
-- (jedes Paar bildet einen Variablennamen auf einen Ausdruck ab)
type Substitution = [(String,Expression)]

-- substitute fuehrt die parallele Substitution durch, d.h.
-- substitute [(x1,t1),...,(xn,tn)] s = s[t1/x1,...,tn/xn]

substitute :: Substitution -> Expression -> Expression
substitute substitution expression = 
 walk expression 
  where 
   walk (Variable u)             = case lookup u substitution of
                                     Just e -> e            -- Variable wird substituiert
                                     Nothing -> Variable u  -- Variable wird nicht substituiert
   walk (Application e1 e2)       = (Application (walk e1) (walk e2)) -- Rekursiv in beiden Ausdruecken ersetzen
   walk (CaseBool e1 e2 e3)       = (CaseBool (walk e1) (walk e2) (walk e3)) -- Rekursiv in allen Unterausdruecken ersetzen
   walk (CaseList e1 e2 (x,y,e3)) = 
     let e3' = (x,y,substitute (filter (\a -> fst a /= x && fst a /= y) substitution) e3) -- Substitutionen fuer x,y loeschen
     in (CaseList (walk e1) (walk e2) e3') -- Rekursiv in allen Unterausdruecken ersetzen
   walk (Lambda v e) = Lambda v (substitute (filter (\a -> fst a /= v) substitution) e) -- Substitution fuer v loeschen
   walk (CONS e1 e2) = CONS (walk e1) (walk e2) -- Rekursiv in die Argumente                              
   walk e = e                                   -- in allen anderen Faellen, aufhoeren (Konstanten)
         

-- Aufgaben:         
-- a)
isFWHNF,isCWHNF,isWHNF :: Expression -> Bool
isFWHNF (Lambda a b) = True
isFWHNF _ = False

isCWHNF (CONS _ _) = True
isCWHNF NIL = True
isCWHNF _ = False

isWHNF e 
 | (isFWHNF e) || (isCWHNF e) = True
 | otherwise = False

-- b)
betaReduce :: Expression -> Maybe Expression
betaReduce (Application (Lambda e1 e2) e3) = (Just (substitute [(e1,e3)] e2))
betaReduce _ = Nothing

-- c)
caseReduce :: Expression -> Maybe Expression
caseReduce (CaseBool TRUE e e1) =  (Just e)
caseReduce (CaseBool FALSE e e1) =  (Just e1)
caseReduce (CaseList NIL e (x,y,e1) ) =  (Just e1)
caseReduce (CaseList (CONS e1 e2) _ (x,y,e3 )) =  
 (Just (substitute [(y, e2)] (substitute [(x,e1)] e3 )))
caseReduce _ = Nothing
