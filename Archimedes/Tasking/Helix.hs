-- Helix - A simple regex replacement.
--Internal data structures:
--atoms   -> (a, [a])
--strands -> abcdef.. 

-- input : doesmatch abc @@@

module Archimedes.Tasking.Helix(
    toStrand
  , getControl
  , strands) where

import Archimedes.Sequence.Remove

type Strand  = (Char,String)

flatten :: [[a]] -> [a]
flatten [] = []
flatten (x:xs) = x ++ flatten xs

toStrand :: Char -> [Strand] -> Strand
toStrand a [] = (a,"unknown")
toStrand a ((b,c):d)
  | a `elem` c = (b,c)
  | otherwise = toStrand a d

getControl :: String -> [Strand]  -> String
getControl x gl = (map fst (map ((flip toStrand) gl) x))

strands :: String -> String -> [Strand] -> [String]
strands [] _ _ = []
strands string control gsl
 | (getControl relv gsl) == (sanitizeControl control gsl) = relv : recur
 | otherwise = recur
  where relv = (take (length (sanitizeControl control gsl)) (sanitizeString string gsl))
        recur = strands (tail string) control gsl

-- Local Functions
sanitizeControl :: String -> [Strand] -> String
sanitizeControl x gl = (filter (\c -> c `elem` (map fst gl)) x)

sanitizeString :: String ->  [Strand] -> String
sanitizeString x gl = (filter (\c -> c `elem` (flatten (map snd gl))) x)
