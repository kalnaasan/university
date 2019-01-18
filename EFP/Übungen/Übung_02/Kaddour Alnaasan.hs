-- Kaddour Alnnasan
-- 28.10.2018
-- Übung_02

-- Aufgabe_01

-- a)
--         (((\x1.(\x2.(x1x2))) (\x3.(\x4.x3))) (\x5.x5))
--         (((\x1.(\x2.(x1x2))) (\x3.(\x4.x3))) (\x5.x5))*
--         (((\x1.(\x2.(x1x2))) (\x3.(\x4.x3)))* (\x5.x5))
--         (((\x1.(\x2.(x1x2)))* (\x3.(\x4.x3))) (\x5.x5))
-- no -->  ((\x2.((\x3.(\x4.x3))x2)) (\x5.x5)
--         ((\x2.((\x3.(\x4.x3))x2)) (\x5.x5)*
--         ((\x2.((\x3.(\x4.x3))x2))* (\x5.x5)
-- no -->  ((\x3.(\x4.x3)) (\x5.x5))
--         ((\x3.(\x4.x3)) (\x5.x5))*
--         ((\x3.(\x4.x3))* (\x5.x5))
-- no -->  (\x4.(\x5.x5))

--b)
--         (((\x1.(\x2.(x1 (x2 x2)))) (\x3.x3)) (\x4.x4))
--         (((\x1.(\x2.(x1 (x2 x2)))) (\x3.x3)) (\x4.x4))*
--         (((\x1.(\x2.(x1 (x2 x2)))) (\x3.x3))* (\x4.x4))
--         (((\x1.(\x2.(x1 (x2 x2))))* (\x3.x3)) (\x4.x4))
-- ao -->  ((\x2.((\x3.x3) (x2 x2))) (\x4.x4))
--         ((\x2.((\x3.x3) (x2 x2))) (\x4.x4))*
--         ((\x2.((\x3.x3) (x2 x2)))* (\x4.x4))
--         ((\x2.((\x3.x3) (x2 x2))*) (\x4.x4))
--         ((\x2.((\x3.x3)* (x2 x2))) (\x4.x4))
-- ao -->  ((\x2.(x2 x2)) (\x4.x4))
--         ((\x2.(x2 x2)) (\x4.x4))*
--         ((\x2.(x2 x2))* (\x4.x4))
-- ao -->  ((\x4.x4) (\x4.x4))
--         ((\x4.x4) (\x4.x4))*
--         ((\x4.x4)* (\x4.x4))
-- an -->  (\x4.x4)

--c)
--        ((\x1.x1) (let x2 = (\x3.x3) in x2))
main = 5


-- Aufgabe_02

data Expression = Variable String
                | Lambda String Expression
                | Application Expression Expression
deriving(Show)

isWHNF (Lambda var body) = True
isWHNF _                 = False

Z_B = (Lambda "x" (Application (Lambda "y" (Variable "y")) (Variable "x")))


-- a)

depth :: Expression -> Integer
depth (Lambda var body) = 1 + (depth body)
depth (Application w v) = max (depth w) (depth v)
depth (Variable w) = 1      

--b)
isNormalform :: Expression -> Bool
isNormalform (Lambda var body)
 | (depth body) == 1 = True
 | otherwise = False
isNormalform _ = False