module Archimedes.Sequence.Remove(
    rm
  , remove
  , removeBetween) where

import Archimedes.Sequence.Functional
import Archimedes.Common
import Archimedes.Sequence.Manipulate
import Archimedes.Sequence.Clarify

rm :: (Eq a) => [a] -> a -> [a]
rm x y = filter (/= y) x

remove :: (Eq a) => [a] -> [a] -> [a]
remove [] _ = []
remove x a
    | not (x `contains` a) = x
    | (take la x) == a = remove (sub x $ dec la) a
    | otherwise = (head x) : remove (tail x) a
  where la = (length a)

removeBetween :: (Eq a) =>  [a] -> (a,a) -> [a]
removeBetween x (a,b) = dea $ deb $ (remove x (between x (a,b)))
  where dea = (flip rm) a
        deb = (flip rm) b
