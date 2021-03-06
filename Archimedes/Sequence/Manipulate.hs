module Archimedes.Sequence.Manipulate(
       sub
     , to
     , pos
     , after
     , before
     , between
     , pos
     , positions
     , removeLeading
     , afterList
     , beforeList
     , splitOn
     , intersperse) where

import Archimedes.Common
import Archimedes.Sequence.Clarify
import Archimedes.Sequence.Functional
--Local Functions
fibseq :: [Int] -> [Int]
fibseq x = tail $ reverse $ helper x (length x)
  where helper a n = if (n == 0) then [0] else descend a n : helper a (dec n)

descend :: [Int] -> Int -> Int
descend x b = sum $ (to x b)

rm :: (Eq a) =>  [a] -> a -> [a]
rm x b = filter (/=b) x

-- Exported Functions
sub :: [a] -> Int -> [a]
sub [] _ = []
sub (x:xs) y
    | (y == 0) = xs
    | otherwise = sub xs $ dec y

to :: [a] -> Int -> [a]
to [] _ = []
to _ 0 = []
to (x:xs) y = x : to xs (dec y)

after :: (Eq a) => [a] -> a -> [a]
after a b = sub a $ pos a b

before :: (Eq a) => [a] -> a -> [a]
before a b = to a $ pos a b

pos :: (Eq a) => [a] -> a -> Int
pos a b = length $ filterBreak (/= b) a

positions :: (Eq a) => [a] -> a -> [Int]
positions a b = let lengths = (zip a [0..(dec (length a))]) in
  rm  (map (\(c,d) -> if c == b then d else (-1)) lengths) (-1)

removeLeading :: (Eq a) => [a] -> a -> [a]
removeLeading x b = removeBreak (== b) x

afterList :: (Eq a) => [a] -> [a] -> [a]
afterList [] _ = []
afterList x b
  | (take (length b) x) == b = sub x (dec (length b))
  | otherwise = afterList (tail x) b

beforeList :: (Eq a) => [a] -> [a] -> [a]
beforeList [] _ = []
beforeList a@(x:xs) b
  | (take (length b) a) == b = []
  | otherwise = x : beforeList xs b
                
splitOn :: (Eq a) => [a] -> a -> [[a]]
splitOn x y
  | y `elem` x = (before x y) : (splitOn (after x y) y)
  | otherwise = [x]

intersperse :: [a] -> a -> [a]
intersperse [] _ = []
intersperse (x:xs) b = x : b : intersperse xs b

between :: (Eq a) => [a] -> (a,a) -> [a]
between x (a,b) = before (after x a) b
