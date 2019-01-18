module MineSweeper where

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

-- =============
-- AUFGABEN
-- =============

-- a)
(!!!) :: Matrix -> Coordinates -> Entry
matrix !!! (x,y) = (matrix!!y)!!x

-- b)
first (a:xs) = a
rest [] = []
rest (a:xs) = xs

updateMatrix :: Matrix -> Coordinates -> Entry -> Matrix
updateMatrix matrix (x,y) val = a++(c ++ val:(rest d)):(rest b)
 where (c,d) = splitAt x (first b)
       (a,b) = splitAt y matrix
-- c)
neighbours :: GameState -> Coordinates -> [Coordinates]
neighbours gs (x,y) = 
  filter (/= (x,y)) [(x',y') | x' <- [x - 1..x + 1], y' <- [y - 1..y + 1], 
  x' >= 0, y' >= 0, x' < (length (matrix gs)), y' < (length (matrix gs))]
 
 
-- d)
countMines list [] = 0
countMines list (a:xs) 
 | a `elem` list = 1 + (countMines list xs)
 | otherwise = 0 + (countMines list xs)
 
minesAround :: Coordinates -> GameState -> Int
minesAround (x,y) gs = countMines (mines gs) (neighbours gs (x,y))

-- e)

