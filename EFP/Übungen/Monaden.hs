import System.IO
import Data.IORef
import Data.Char
import Control.Applicative (Applicative(..))
import Control.Monad       (liftM, ap)

-- Haskell-Programme zu Monaden

-- Verwendung der Maybe-Monade

db = [(101,100),(102,200),(103,-500)]

passdb =[(101,"KSPW!3"),(102,"Ow23="),(103,"12ko12")]
getKontostand knr pass = lookup knr db >>= 
                           \x -> lookup knr passdb >>=
                            \y -> eqMaybe pass y >>
                              return x

-- Mit do-Notation:
getKontostand' knr pass =
 do
  x <- lookup knr db
  y <- lookup knr passdb
  eqMaybe pass y
  return x

-- ohne Monaden

getKontostand'' knr pass =
 case lookup knr db of
   Nothing -> Nothing
   Just x -> case lookup knr passdb of
              Nothing -> Nothing
              Just y -> case eqMaybe pass y of
                         Nothing -> Nothing
                         Just _  -> Just x

eqMaybe a b 
 | a == b = Just True
 | otherwise = Nothing



-- Der StateTransformer Datentyp

data StateTransformer state a = ST (state -> (a,state))

-- Die Monadeninstanz f"ur StateTransformer
instance Functor (StateTransformer s) where
  fmap = liftM
 
instance Applicative (StateTransformer s) where
  pure a  = ST (\s -> (a,s))
  (<*>) = ap
    
instance Monad (StateTransformer s) where 
 return          = pure
 (ST x) >>= f    = ST (\s -> case x s of
                               (a,s' ) ->  case (f a) of
                                             (ST y) -> (y s'))

-- Der Taschenrechner-Zustand
type CalcState = (Float -> Float, Float)

-- Der StateTransformer f"ur Taschenrechner
type CalcTransformer a = StateTransformer CalcState a

-- Die Funktionen des Taschenrechners

startState = (id, 0.0)

oper :: (Float -> Float -> Float) -> CalcTransformer ()
oper op = ST $ \(fn,zahl) -> ((), (op (fn zahl), 0.0))

clear :: CalcTransformer ()
clear = ST $ \(fn,zahl) -> ((),if zahl == 0.0 then startState else (fn,0.0))

total :: CalcTransformer ()
total = ST $ \(fn,zahl) -> ((), (id, fn zahl))

digit :: Int -> CalcTransformer ()
digit i = ST $ \(fn,zahl) -> ((), (fn, (fromIntegral i) + zahl*10.0))

readResult:: CalcTransformer Float
readResult = ST $ \(fn,zahl) -> (fn zahl, (fn,zahl))

calcStep :: Char -> CalcTransformer ()
calcStep x
 | isDigit x = digit (fromIntegral $ digitToInt x)

calcStep '+' = oper (+)
calcStep '-' = oper (-)
calcStep '*' = oper (*)
calcStep '/' = oper (/)
calcStep '=' = total
calcStep 'c' = clear
calcStep _   = ST $ \(fn,z) -> ((),(fn,z))

calc []     = readResult 
calc (x:xs) = do
               calcStep x
               calc xs

runCalc :: CalcTransformer Float -> (Float,CalcState)
runCalc (ST akt) = akt startState

mainCalc xs = fst $ runCalc (calc xs)


-- Mit IO

-- Monad-Transformer f"ur StateTransformer

newtype StateTranformerT monad state a = STT (state -> monad (a,state))

-- Instanz der Klasse Monad
instance Monad m => Functor (StateTranformerT m s) where
  fmap = liftM
 
instance Monad m => Applicative (StateTranformerT m s) where
  pure x = STT $ \s -> return (x,s)
  (<*>)  = ap
 
instance Monad m => Monad (StateTranformerT m s) where 
 return        = pure
 (STT x) >>= f = STT $ (\s -> do
                               (a,s') <- x s
                               case (f a) of
                                 (STT y) ->  (y s'))

-- Monad-Transformer f"ur Taschenrechner
type CalcTransformerT a = StateTranformerT IO CalcState a

-- Funktion zum Liften:
lift :: CalcTransformer a -> CalcTransformerT a
lift (ST fn) = STT $ \x -> return (fn x)

-- geliftete Funktionen

oper' op = lift (oper op)
clear' = STT $ \(fn,zahl) -> if zahl == 0.0 then do
                                putStr ("\r"  ++ (replicate 100 ' ') ++ "\r")
                                return ((),startState)
                             else do
                                let l = length (show zahl)+1      --  auf +1 geaendert 2013
                                putStr $ (replicate l '\b') ++ (replicate l ' ' ) ++ (replicate l '\b') ++ ("\n") 
                                return ((),(fn,0.0))
total' = STT $ \(fn,zahl) -> do
                              let res = ((), (id, fn zahl))
                              putStr $ show (fn zahl)
                              return res
digit' i = lift (digit i)
readResult' = lift readResult


calcStep' :: Char -> CalcTransformerT ()
calcStep' x
 | isDigit x = digit' (fromIntegral $ digitToInt x)

calcStep' '+' = oper' (+)
calcStep' '-' = oper' (-)
calcStep' '*' = oper' (*)
calcStep' '/' = oper' (/)
calcStep' '=' = total'
calcStep' 'c' = clear'
calcStep' _   = STT $ \(fn,z) -> return ((),(fn,z))


runST' (STT s) = s startState

calc' = do 
          c <- liftIO $ getChar
          if c /= '\n' then do
            calcStep' c
            calc'
           else return ()

main = do 
          hSetBuffering stdin NoBuffering  -- setzt das Buffering so, dass der Taschenrechner sofort reagiert
          hSetBuffering stdout NoBuffering -- setzt das Buffering so, dass der Taschenrechner sofort reagiert
          runST' $ calc'

liftIO :: IO a -> CalcTransformerT a
liftIO akt = STT (\s -> do 
                         r <- akt
                         return (r,s))



--
-- Kontrollstrukturen

repeatUntil :: (Monad m) => m a -> m Bool -> m ()
repeatUntil koerper bedingung = 
  do
    koerper
    b <- bedingung
    if b then return () else repeatUntil koerper bedingung

while :: (Monad m) => m Bool -> m a -> m ()
while  bedingung koerper = 
 do
  b <- bedingung
  if b then  do
    koerper
    while  bedingung koerper 
   else return ()

dieErstenHundertZahlen =
 do 
  x <- newIORef 0
  repeatUntil 
     (do
       wertVonX <- readIORef x
       print wertVonX
       writeIORef x (wertVonX + 1)
      )
     (readIORef x >>= \x -> return (x > 100)) 

dieErstenHundertZahlen' =
  do 
   x <- newIORef 0
   while (readIORef x >>= \x -> return (x <= 100)) 
      (do
        wertVonX <- readIORef x
        print wertVonX
        writeIORef x (wertVonX + 1)
       )

sequence' :: (Monad m) => [m a] -> m [a]
sequence' []          = return []
sequence' (action:as) = do 
                        r <- action
                        rs <- sequence' as
                        return (r:rs) 

sequence_' :: (Monad m) => [m a] -> m ()

sequence_' []          = return ()
sequence_' (action:as) = do
                        action
                        sequence_' as
