module ProjectSpecific(
	makeParameters
   ,makeAllParameters
   ,formulateResponse
   ,format
   ,isRes
   ,amRes
   ,areRes
   ,restructure
   ,sanitize
   ,closeEnough
   ,sanitizeInput
	) where

import Archimedes.Sequence.Manipulate
import Archimedes.Tasking.Statistics
import Archimedes.Tasking.Replace
import Archimedes.Sequence.Clarify

-- Sample configuration file
-- whatever|whatever|whatver_foobar

churn :: a -> Int -> [a]
churn a b = take b (repeat a)

look :: (Eq a) => [(a,b)] -> a -> b
look [] _ = error "Not in list"
look ((a,b):xs) c
  | a == c = b
  | otherwise = look xs c
                
makeParameters :: String -> [(String,String)]
makeParameters x = zip  (splitOn (head sides) '|')  (churn (last sides) (length $ splitOn (head sides) '|')) 
	where sides = splitOn x '_'

makeAllParameters :: [String] -> [(String,String)]
makeAllParameters [] = []
makeAllParameters (x:xs) = makeParameters x ++ (makeAllParameters xs)

formulateResponse :: [(String,String)] -> String -> String
formulateResponse [] _ = "learn"
formulateResponse a prompt
	| prompt `elem` (map fst a) = look a prompt
	| anySimilar a prompt = look a (mostSimilarWord prompt (map fst a))
	| otherwise = "learn"


format :: String -> String -> String
format a b = (replace (a ++ "_" ++ b) ('\'',' '))

-- input = "I am a dragon -> (What am I?_You are a dragon"
amRes :: String -> String
amRes input = ("What am I?" ++ "_You are " ++ (afterList input "am "))

-- Jack is smart -> (what is Jack?_Jack is smart)
isRes :: String -> String
isRes x = "What is " ++ toLower subject ++ "?_" ++ capitalize subject ++ " is " ++ (afterList x "is ")
	where 
      subject = (head (words x))

-- elephants are stupid_what are elephants?_elephants are stupid
areRes :: String -> String
areRes x = "What are " ++ toLower subject ++ "?_" ++ capitalize subject ++ " are " ++ (afterList x "are ")
	where subject = (head (words x))

cap :: Char -> Char
cap x = refPos ['a'..'z'] ['A'..'Z'] x

isCap :: Char -> Bool
isCap x = or [x `elem` ['A'..'Z'], x `elem` ['0'..'9']]

isLower :: Char -> Bool
isLower x = or [x `elem` ['a'..'z'], x `elem` ['0'..'9']]

lower :: Char -> Char
lower x = refPos ['A'..'Z'] ['a'..'z'] x

toLower :: String -> String
toLower (x:xs) = (if isLower x then x else lower x) : xs

capitalize :: String -> String
capitalize (x:xs) = (if isCap x then x else cap x) : xs

partLook :: [(String,(String -> String))] -> String -> (String -> String)
partLook [] _ = error "Not found error"
partLook ((trip,fun):xs) x
	 | (x `contains` trip) = fun
	 | otherwise = partLook xs x

restructure :: String -> String
restructure x = (partLook [("am",amRes),("is",isRes),("are",areRes)] x) x

sanitize :: [String] -> [String]
sanitize x = map ((flip removeLeading) ' ') $ filter  (\c -> (length c > 3)) x 

closeEnough :: (String,String) -> String -> Bool
closeEnough (a,_) s = isSimilarWord a s

anySimilar :: [(String,String)] -> String -> Bool
anySimilar x s = or (map ((flip closeEnough) s)  x)

sanitizeInput :: String -> String
sanitizeInput a@(x:xs) = map (\c -> if c `elem` str then ' ' else c) a 
	where str = ",;:\"'\\<.>?'~`!@#$%^&*([;{|}])-_=+" 
