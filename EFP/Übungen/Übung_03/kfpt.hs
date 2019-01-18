-- *****************************************************************************************
-- *****************************************************************************************
-- ***** Der Datentyp fuer KFPT-Ausdruecke:                                            *****
-- *****                                                                               *****
-- *****                                                                               *****

data Expr a =
   Var a                                  -- x       = Var "x"
 | App (Expr a) (Expr a)                  -- (e1 e2) = App e1 e2 
 | Lam a (Expr a)                         -- \x.e    = Lam "x" e 
 | ListCons (Expr a) (Expr a)             -- a:as    = ListCons a as
 | ListNil                                -- []      = ListNil
 | BoolTrue                               -- True    = BoolTrue
 | BoolFalse                              -- False   = BoolFalse
 | CaseList (Expr a) (Expr a) (a,a,Expr a)-- case_List e of {[] -> e1; (x:xs) -> e2)
                                          -- = CaseList e (e1) ("x",xs",e2)
 | CaseBool (Expr a) (Expr a) (Expr a)    -- case_Bool e of {True -> e1; False -> e2)
                                          -- = CaseBool e e1 e2
  deriving(Eq,Show)
 
-- *****                                                                               *****
-- *****                                                                               *****
-- *****************************************************************************************
-- *****************************************************************************************

-- *****************************************************************************************
-- *****************************************************************************************
-- ***** Beispiele                                                                     *****
-- *****                                                                               *****
-- *****                                                                               *****

-- \x -> x
beispiel1 =  Lam "x" (Var "x")
 
-- [True,True,False]
beispiel2 =
 ListCons 
   BoolTrue
   (ListCons 
     BoolTrue
     (ListCons
       BoolFalse
       ListNil))

-- \x y z -> case_Bool x of
--            { True -> y;
--              False -> z} 
beispiel3 =
 Lam "x" 
  (Lam "y" 
   (Lam "z" 
     (CaseBool 
      (Var "x")
      (Var "y")
      (Var "z"))))

-- \x -> case_List x of
--            {[]       -> [];
--            (y:ys)   ->  ys} 
beispiel4 =
 Lam "x" 
   (CaseList
     (Var "x")
     (Var "x")
     ("y","ys",(Var "ys")))
     
     
-- (\x.x x) (\y.y y)
beispiel5 = 
  App (Lam "x" (App (Var "x") (Var "x"))) (Lam "y" (App (Var "y") (Var "y")))
  
  
beispiel6 = App beispiel4 beispiel2

-- *****                                                                               *****
-- *****                                                                               *****
-- *****************************************************************************************
-- *****************************************************************************************


-- *****************************************************************************************
-- *****************************************************************************************
-- ***** Substitution                                                                  *****
-- *****                                                                               *****
-- *****                                                                               *****

-- substitute e1 e2 x  entspricht e1[e2/x]
 
substitute (Var y) e x
  | x==y = e
  | otherwise = Var y
  
substitute (App e1 e2) e x=
 App (substitute e1 e x) (substitute e2 e x) 
 
substitute (Lam y e1) e2 x	
  | y == x    = (Lam y e1)
  | otherwise = (Lam y (substitute e1 e2 x))
 
substitute (ListCons e1 e2) e x =
 ListCons (substitute e1 e x) (substitute e2 e x) 

substitute (CaseBool e e1 e2) e3 x =
  CaseBool 
   (substitute e e3 x) 
   (substitute e1 e3 x)
   (substitute e2 e3 x)

substitute (CaseList e e1 (y1,y2,e2)) e3 x =
  CaseList 
   (substitute e e3 x) 
   (substitute e1 e3 x)
   (y1,y2, (if x `elem` [y1,y2] 
             then e2 
             else (substitute e2 e3 x)))
-- alle anderen Faelle       
substitute e e3 x = e         
-- *****                                                                               *****
-- *****                                                                               *****
-- *****************************************************************************************
-- *****************************************************************************************

-- *****************************************************************************************
-- *****************************************************************************************
-- *****  Aufgaben                                                                     *****
-- *****                                                                               *****
-- *****                                                                               *****

-- Aufgabe a)

isFWHNF e = undefined  -- zu implementieren
isCWHNF e = undefined  -- zu implementieren
isWHNF  e  = undefined  -- zu implementieren

-- Aufgabe b)

betaReduce e  = undefined  -- zu implementieren
  
-- Aufgabe c)

caseReduce e  = undefined  -- zu implementieren

-- Aufgabe d)
isUntyped  e  = undefined  -- zu implementieren

-- Aufgabe e) 
 
oneStepNormalOrder e  = undefined  -- zu implementieren
  
-- Aufgabe f)
data Result = TerminatesWith (Expr String)| Diverges
 deriving(Eq,Show)

calcResult e  = undefined  -- zu implementieren

-- *****                                                                               *****
-- *****                                                                               *****
-- *****************************************************************************************  
-- *****************************************************************************************  



  
	      