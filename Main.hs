-- ParrotBot

import System.IO

import LibHaskell.LibLists
import ProjectSpecific

promptLine :: String -> IO String
promptLine prompt = do
    putStr prompt
    getLine

main = do
	learnFile <- openFile "learn" ReadWriteMode
	learnText <- hGetContents learnFile

	let params = makeAllParameters (lines learnText)
	input <- promptLine "$ "
	let response = formulateResponse params input
	putStrLn response
	if ((lastx response 2)==".$") then do  -- This is a hack and WILL BE CHANGED
										answer <- promptLine "Answer: "
										appendFile "learn" ((format input answer)++"\n")
										main 
								  else do 
								  	hClose learnFile
								  	main
