module ProjectSpecific(
	makeParameters
   ,makeAllParameters
   ,formulateResponse
   ,format
	) where

import LibHaskell.LibLists
-- Sample configuration file
-- whatever|whatever|whatver_foobar#foobar#foobar

makeParameters :: String -> [(String,String)]
makeParameters x = sew  (splitOn (grab sides) '|')  (churn (lst sides) (length $ splitOn (grab sides) '|')) 
	where sides = splitOn x '_'

makeAllParameters :: [String] -> [(String,String)]
makeAllParameters [] = []
makeAllParameters (x:xs) = makeParameters x ++ (makeAllParameters xs)

formulateResponse :: [(String,String)] -> String -> String
formulateResponse [] _ = "I do not know how to respond to that. Input an appropriate response.$"
formulateResponse a prompt
	| not $ prompt `inFst` a = formulateResponse [] [] --Kind of a hack.
	| otherwise = look prompt a

format :: String -> String -> String
format a b = a ++ "_" ++ b
--IsInResponses will be implemented in the next update.