
-- verschiedene Baeume und Funktionen auf Baeumen

-- Baum mit Blattmarkierungen

data BBaum a = Blatt a | Knoten (BBaum a) (BBaum a)
   deriving(Show)


-- ein Beispielbaum:

beispielBaum = 
  Knoten
    (Knoten
      (Knoten
          (Knoten (Blatt 1) (Blatt 2))
          (Knoten (Blatt 3) (Blatt 4))
      )
      (Knoten (Blatt 5) (Blatt 6))
    )
    (Knoten
      (Blatt 7)
      (Knoten 
          (Knoten (Blatt 8) (Blatt 9))
          (Knoten (Blatt 10) (Blatt 11))
      )
    )

-- Funktionen auf BBaum:

-- Summe aller Bl"atter:

bSum (Blatt a) = a
bSum (Knoten links rechts) = (bSum links) + (bSum rechts)

-- Liste aller Bl"atter:

bRand (Blatt a) = [a]
bRand (Knoten links rechts) = (bRand links) ++ (bRand rechts)

--  Variante 1
bRandschnell tr = reverse (bRandschnell_r [] tr)
bRandschnell_r r (Blatt a)  =  (a:r)
bRandschnell_r r (Knoten links rechts)  =  bRandschnell_r (bRandschnell_r r rechts) links

--  Variante 2
bRandschnell' tr = bRandschnell'_r tr []
bRandschnell'_r (Blatt a)  =  \x-> (a:x)
bRandschnell'_r (Knoten links rechts)  =  (bRandschnell'_r rechts)   . (bRandschnell'_r links) 


-- Map auf B"aume: Funktion auf alle Markierungen anwenden

bMap f (Blatt a) = Blatt (f a)
bMap f (Knoten links rechts) = Knoten (bMap f links) (bMap f rechts)

-- Beispiel: Verwendung von Map: Anzahl der Bl"atter berechnen
anzahlBlaetter  = bSum . bMap (\x -> 1)

-- Element-Test f"ur B"aume

bElem e (Blatt a)
 | e == a          = True
 | otherwise       = False
bElem e (Knoten links rechts) = (bElem e links) || (bElem e rechts)


-- Fold auf B"aumen: an die Stelle der inneren Knoten tritt der Operator

bFold op (Blatt a) = a
bFold op (Knoten a b) = op (bFold op a) (bFold op b)
 
 
 --  allgemeineres Fold \"uber  bin\"are B\"aume

foldbt :: (a -> b -> b) -> b -> BBaum a  -> b
foldbt op a (Blatt x)    = op x a
foldbt op a (Knoten x y) = (foldbt op (foldbt op a y) x)

--  foldbt :: (a -> b -> b) -> b -> BBaum a  -> b
-- foldbt op a (Blatt  x)    = op x a
-- foldbt op a (Knoten  x y) = (foldbt op (foldbt op a y) x)



-- N"arer Baum mit Blatt-Markierungen

data NBaum a = NBlatt a | NKnoten [NBaum a]
 deriving(Eq,Show)


-- Bin"arer Baum mit Markierung alle Knoten:

data BinBaum a = BinBlatt a | BinKnoten a (BinBaum a) (BinBaum a)
 deriving(Eq,Show)

-- ein Beispielbaum:

beispielBinBaum = 
 BinKnoten 'A'
  (BinKnoten 'B'
     (BinKnoten 'D' (BinBlatt 'H') (BinBlatt 'I'))
     (BinKnoten 'E' (BinBlatt 'J') (BinBlatt 'K'))
  )
  (BinKnoten 'C'
     (BinKnoten 'F' 
        (BinKnoten 'L' (BinBlatt 'N') (BinBlatt 'O'))
        (BinKnoten 'M' (BinBlatt 'P') (BinBlatt 'Q'))
     )
     (BinBlatt 'G')
  )

-- Berechnung aller Knotenmarkierung in ...

-- ... preorder Reihenfolge (Wurzel, links, rechts)

preorder :: BinBaum t -> [t]
preorder (BinBlatt a)      = [a]
preorder (BinKnoten a l r) = a:(preorder l) ++ (preorder r)


-- ... inorder Reihenfolge (links, Wurzel, rechts)

inorder (BinBlatt a) = [a]
inorder (BinKnoten a l r) = (inorder l) ++ a:(inorder r)


-- ... postorder Reihenfolge (links, rechts, Wurzel)

postorder (BinBlatt a) = [a]
postorder (BinKnoten a l r) = (postorder l) ++ (postorder r) ++ [a]


-- ... levelorder Reihenfolge (Knoten Stufenweise von oben nach unten)

-- Schlechte Variante (Baum wird f"ur jede Stufe, von oben neu durchsucht)

levelorderSchlecht b = concat [nodes_at_depth_i i b | i <- [0..depth b]]
 where
  nodes_at_depth_i 0 (BinBlatt a) = [a]
  nodes_at_depth_i i (BinBlatt a) = []
  nodes_at_depth_i 0 (BinKnoten a l r) = [a]
  nodes_at_depth_i i (BinKnoten a l r) = (nodes_at_depth_i (i-1) l) ++ (nodes_at_depth_i (i-1) r)
  depth (BinBlatt _) = 0
  depth (BinKnoten _ l r) = 1+(max (depth l) (depth r))

-- Bessere Variante (Baum wird nur einmal durchsucht)

levelorder b = loForest [b]
 where 
  loForest [] = [] 
  loForest xs = map root xs ++ loForest (concatMap subtrees xs)
  root (BinBlatt a) = a
  root (BinKnoten a _ _) = a
  subtrees (BinBlatt _) = []
  subtrees (BinKnoten _ l r) = [l,r]

-- Hilfsfunktion, um Testb"aume BinBaum erzeugen:
  --   balancierter Baum
genBinBaum [] = error "genBinBaum with Empty List"
genBinBaum [a] = BinBlatt a
genBinBaum xs = let lxs = length xs
                    l = div (lxs-1) 2
                    (ys,zs) = splitAt l (tail xs)   
                    y':y'':ys'' = xs                 
             in  if even lxs  then genBinBaum ((head xs) : xs)
                 else if even l then BinKnoten y' (BinBlatt y'') (genBinBaum ys'')
                 else BinKnoten (head xs) (genBinBaum ys) (genBinBaum zs)
 
showBBaum (BinBlatt a) = "(Blatt " ++ show a ++ ")"
showBBaum (BinKnoten a t1 t2) = "(Knoten " ++ show a ++ " (" ++ showBBaum t1 ++   ";" ++ showBBaum t2 ++   ")" 
      
 -- Hilfsfunktion, um Testb"aume erzeugen:            
 --   balancierter Baum
genBaum [] = error "genBaum with Empty List"
genBaum [a] = Blatt a
genBaum xs = let l = div (length xs) 2
                 (ys,zs) = splitAt l xs                 
             in Knoten (genBaum ys) (genBaum zs)

--   linkslastiger Baum
genBaum' [x]    = Blatt x
genBaum' (x:xs) = Knoten (genBaum' xs) (Blatt x)

--   rechtslastiger Baum
genBaum'' [x]    = Blatt x
genBaum'' (x:xs) = Knoten (Blatt x) (genBaum'' xs) 

-- Bin"arer Baum mit Knoten- und Kantenmarkierungen:

data BinBaumMitKM a b = BiBlatt a | BiKnoten a (b, BinBaumMitKM a b) (b,BinBaumMitKM a b)
 deriving(Eq,Show)


-- Beispielbaum

beispielBiBaum=
  BiKnoten 'A'
   (0,BiKnoten 'B' (2,BiBlatt 'D') (3,BiBlatt 'E'))
   (1,BiKnoten 'C' (4,BiBlatt 'F') (5,BiBlatt 'G'))


-- map f"ur B"aume mit Knoten- und Kantenmarkierungen: auf die beiden Arten von
-- Markierungen werden 2 verschiedene Funktionen angewendet:

biMap f g (BiBlatt a) = (BiBlatt $ f a)
biMap f g (BiKnoten a (kl,links) (kr,rechts)) = 
 BiKnoten (f a) (g kl, biMap f g links) (g kr, biMap f g rechts)
 
 
-- Arithmetische Ausdr"ucke 
 
data ArEx = ArEx :+: ArEx
          | ArEx :*: ArEx 
          | Zahl Int
  deriving(Show)
  
interpretArEx :: ArEx -> Int
interpretArEx (Zahl i) = i
interpretArEx (e1 :+: e2) = (interpretArEx e1) + (interpretArEx e2)
interpretArEx (e1 :*: e2) = (interpretArEx e1) * (interpretArEx e2)

bsp = ((Zahl 3) :+: (Zahl 4)) :*: ((Zahl 5) :+: ((Zahl 6) :+: (Zahl 7)))
           