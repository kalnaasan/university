
module MineSweeper where

import Data.List
-- ************************************************************************************************************
-- ************************************************************************************************************
-- ************************************************************************************************************

-- Spielzustand als Record-Datentyp, bestehend aus
--   * der Matrix
--   * den Koordinaten der Minen
--   * dem Zustand (gewonnen,verloren,offen)

data GameState = GameState { matrix :: Matrix, mines :: [Coordinates], state :: State }
-- Koordinaten sind Paare von (Int,Int)-Werten, wobei
-- (0,0) ist der Eintrag oben links
-- (x,y) ist die x.Spalte (von links nach rechts) und y.Zeile (von oben nach unten)
type Coordinates = (Int,Int)

-- eine Matrix ist eine Liste von Listen, deren Eintr"age vom Typ Entry sind
type Matrix = [[Entry]]
-- Eine Eintrag Entry stellt den Zustand des Felds aus Spielersicht dar:
--  * Marked: Das Feld ist verdeckt aber markiert
--  * Unmarked: Das Feld ist verdeckt und nicht markiert
--  * Open i: Das Feld ist freigelegt, beinhaltet keine Mine, daher wird die Anzahl i
--           der Nachbarfelder mit Minen anzeigt
--  * Mine:   Das Feld ist freigelegt und beinhaltet eine Mine
data Entry = Marked | Unmarked | Open Int | Mine
 deriving(Show)
-- Datentype f"ur den Gewinnzustand: Gewonnen (Won), Verloren (Lost), Offen (Undecided)
data State = Won | Lost | Undecided
 deriving(Show)

-- Eigene Show-Instanzen f"ur die Datentypen, damit man es besser Ausdrucken kann

instance Show GameState where
  show gs = unlines $ map showRow (matrix gs)
      where showRow = (concatMap showEntry)
            showEntry Marked = "X"
            showEntry Unmarked = " "
            showEntry (Open i) = show i
            showEntry Mine     = "M"

-- Datentyp f"ur die Spielz"uge
-- * Toogle (x,y)
--   markiert ein nicht markiertes Feld mit Koordinate (x,y)
--   entfernt Markierung von Feld mit Koordinate (x,y), wenn es vorher markiert ist
--   wirkungslos in allen anderen F"allen
-- * OpenEntry (x,y)
--   "offnet das Feld mit Koordinate (x,y),
--   wirkungslos, wenn das Feld schon offen ist
data Action = Toggle Coordinates | OpenEntry Coordinates
 deriving(Show)
-- =============
-- Beispiel
-- =============

exampleState  = GameState {matrix = exampleMatrix,
                           mines  = [(0,0),(1,0),(2,1),(1,3),(3,3)],
                             state  = Undecided }

exampleMatrix = [[Marked,  Unmarked,Open 2,  Open 1]
                ,[Unmarked,Unmarked,Mine,    Open 1]
                ,[Unmarked,Unmarked,Unmarked,Marked]
                ,[Unmarked,Unmarked,Unmarked,Unmarked]]

-- exampleMatrix = [[Marked,  Unmarked,Open 2,  Open 1]
--                 ,[Unmarked,Unmarked,Mine,    Open 1]
--                  ------------------------------------ SplitAt
--                 ,[Unmarked,Unmarked,Unmarked,Marked]
--                 ,[Unmarked,Unmarked,Unmarked,Unmarked]]




-- =============
-- AUFGABEN
-- =============

-- a)
(!!!) :: Matrix -> Coordinates -> Entry
matrix !!! (x,y) = (matrix!!y)!!x

-- b)
-- updateMatrix :: Matrix -> Coordinates -> Entry -> Matrix
-- updateMatrix matrix (x,y) val = splitAt x matrix
-- updateMatrix matrix x y val= (list1 matrix y) ++ ((list21 (list2 matrix y) x) ++ val ++ list22neu (list22 (list2 matrix y) x) )
hfun_a (a,b) = a
hfun_b (a,b) = b

list1 matrix y = hfun_a (splitAt y matrix)
t1 = list1 exampleMatrix 2
list2 matrix y = hfun_b (splitAt y matrix)
t2 = list2 exampleMatrix 2
list21 list2 x = hfun_a (splitAt x list2)!!1
t21 = list21 t2 1
list22 list2 x = hfun_b (splitAt x list2)
t22 = list22 t2 1

list21_neu list21 x = hfun_b(splitAt x list21)
t21_neu = list21_neu t21 2
-- t22_neu = hfun_b(splitAt 2 t22)
-- list22neu list22@(a:xs) = xs
-- t22neu = list22neu t22







-- c)
neighbours :: GameState -> Coordinates -> [Coordinates]
neighbours gs (x,y) = undefined

-- d)
minesAround :: Coordinates -> GameState -> Int
minesAround (x,y) gs = undefined
-- e)
updateSingleCell :: GameState -> Coordinates -> GameState
updateSingleCell gs (x,y) = undefined

--f)
updateCells :: GameState -> Coordinates -> GameState
updateCells gs (x,y) = undefined

-- g)
playStep :: Action -> GameState -> GameState
playStep action gs = undefined

-- h) Nicht hier sondern Main.hs kompilieren....