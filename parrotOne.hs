import System.IO
import System.Environment

import Archimedes.Sequence.Manipulate
import Archimedes.Tasking.Case
import Archimedes.Sequence.Clarify
import Archimedes.Sequence.Remove

main = do
  (a:xs) <- getArgs -- File | Prompt
  let prompt = (flatten $ intersperse xs " ")

  file <- openFile a ReadMode
  fileContents <- hGetContents file
  let cmds = (flatten (map makeCmd (rm ((map sanitize (lines fileContents))) "")))

  putStrLn $ formResponse (sanitize prompt) cmds
  
--Local Functions
flatten :: [[a]] -> [a]
flatten [] = []
flatten (x:xs) = x ++ flatten xs

look :: (Eq a) => [(a,b)] -> a -> b
look [] _ = error "Not within list"
look ((a,b):z) c
  | a == c = b
  | otherwise = look z c

--Project Specific
format :: (String,String) -> String
format (a,b) = (a ++ "_" ++ b)

formResponse :: String -> [(String,String)] -> String
formResponse x z@((a,b):ys)
  | x `notElem` (map fst z) = "learn"
  | otherwise = look z x

sanitize :: String -> String
sanitize x = rm (toLower x) ' '

makeCmd :: String -> [(String,String)]
makeCmd x = zip (splitOn first '|') (repeat second)
  where (first:second:_) = splitOn x '_'
        
--The following code is for destructuring English sentences implicitly.
--Ressing currently works with "am", "is", and "are"
chooseRes :: String -> String
chooseRes l = (head [b | (a,b) <- [((fcont "am"),amRes),((fcont "is"),isRes),((fcont "are"),areRes)], (a l)]) l
  where fcont = (flip contains)

amRes :: String -> String -- I am here -> What am I?_I am here.
amRes x = format(("What am I?"),("You are " ++ complement))
  where complement = (afterList x "am ")

isRes :: String -> String -- x is y -> What is x?_x is y
isRes x = format(("What is " ++ subject ++ "?"),x)
  where subject = (beforeList x " is ")

areRes :: String -> String -- xes are y -> What are xes?
areRes x = format(("What are " ++ subjects ++ "?"),x)
  where subjects = (beforeList x " are")
