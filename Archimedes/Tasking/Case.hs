module Archimedes.Tasking.Case(
    isCap
  , isLower
  , capitalize
  , lowerrize
  , toCap
  , toLower) where

import Archimedes.Sequence.Functional

isCap :: Char -> Bool
isCap c = c `elem` ['A'..'Z']

isLower :: Char -> Bool
isLower c = not $ isCap c

capitalize :: String -> String
capitalize (x:xs) = cap x : xs

lowerrize :: String -> String
lowerrize (x:xs) = low x : xs

toCap :: String -> String
toCap x = (map cap x)

toLower :: String -> String
toLower x = (map low x)

--Local Functions
refPos :: (Eq a) => [a] -> [b] -> a -> b
refPos l1 l2 c = l2 !! (pos l1 c)

pos :: (Eq a) => [a] -> a -> Int
pos x b = length $ filterBreak (/=b) x

cap :: Char -> Char
cap c = if (isCap c) then c else refPos (['a'..'z'] ++ others ) (['A'..'Z']++others) c
  where others = "`~1!2@3#4$5%6^7&8*9(0)-_=+[{]}\\|:\"'<,>.?/"

low :: Char -> Char
low c = if (isLower c) then c else refPos (['A'..'Z'] ++ others ) (['a'..'z']++others) c
  where others = "`~1!2@3#4$5%6^7&8*9(0)-_=+[{]}\\|:\"'<,>.?/" 
