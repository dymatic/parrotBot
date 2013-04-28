module ProjectSpecific(
	makeParameters
   ,makeAllParameters
   ,formulateResponse
   ,format
   ,isRes
   ,amRes
   ,areRes
   ,restructure
   ,hackEval
   ,sanitize
	) where

import LibHaskell.LibLists
-- Sample configuration file
-- whatever|whatever|whatver_foobar

makeParameters :: String -> [(String,String)]
makeParameters x = sew  (splitOn (grab sides) '|')  (churn (lst sides) (length $ splitOn (grab sides) '|')) 
	where sides = splitOn x '_'

makeAllParameters :: [String] -> [(String,String)]
makeAllParameters [] = []
makeAllParameters (x:xs) = makeParameters x ++ (makeAllParameters xs)

formulateResponse :: [(String,String)] -> String -> String
formulateResponse [] _ = "learn"
formulateResponse a prompt
	| not $ prompt `inFst` a = formulateResponse [] [] --Kind of a hack.
	| otherwise = look prompt a

format :: String -> String -> String
format a b = a ++ "_" ++ b

-- input = "I am a dragon -> (What am I?_You are a dragon"
amRes :: String -> String
amRes input = ("What am I?" ++ "_You are " ++ (afterList input "am "))

-- Jack is smart -> (what is Jack?_Jack is smart)
isRes :: String -> String
isRes x = "What is " ++ toLower subject ++ "?_" ++ capitalize subject ++ " is " ++ (afterList x "is ")
	where 
      subject = (grab (words x))

-- elephants are stupid_what are elephants?_elephants are stupid
areRes :: String -> String
areRes x = "What are " ++ toLower subject ++ "?_" ++ capitalize subject ++ " are " ++ (afterList x "are ")
	where subject = (grab (words x))

cap :: Char -> Char
cap x = refPos ['a'..'z'] ['A'..'Z'] x

isCap :: Char -> Bool
isCap x = or [x `elem` ['A'..'Z'], x `elem` ['0'..'9']]

isLower :: Char -> Bool
isLower x = or [x `elem` ['a'..'z'], x `elem` ['0'..'9']]

lower :: Char -> Char
lower x = refPos ['A'..'Z'] ['a'..'z'] x

toLower :: String -> String
toLower (x:xs) = (notCond isLower lower x) : xs

capitalize :: String -> String
capitalize (x:xs) = (notCond isCap cap x) : xs

partLook :: [(String,(String -> String))] -> String -> (String -> String)
partLook [] _ = error "Not found error"
partLook ((trip,fun):xs) x
	 | (x `contains` trip) = fun
	 | otherwise = partLook xs x

restructure :: String -> String
restructure x = (partLook [("am",amRes),("is",isRes),("are",areRes)] x) x

hackEval :: [String] -> Bool -- This is the definition of a hack and might be changed later.
hackEval [] = False 
hackEval (x:xs)
	| x == "foobar" = True
	| otherwise = hackEval xs

sanitize :: [String] -> [String]
sanitize x = map ((flip removeLeading) ' ') $ filter  (\c -> (length c > 3)) x 