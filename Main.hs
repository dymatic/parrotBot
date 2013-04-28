-- ParrotBot

import System.IO

import LibHaskell.LibLists
import ProjectSpecific
import System.Process
import System.Exit

promptLine :: String -> IO String
promptLine prompt = do
    putStr prompt
    hFlush stdout
    getLine

main = do
	learnText <- readFile "learn"
	
	let params = makeAllParameters (sanitize (lines learnText))
	input <- promptLine "You: "
	let response = formulateResponse params input
	if (input == "exit") then  exitSuccess else return ()
	if (input `contains` "learn:") then do
										system ("./appender learn " ++ (restructure (afterList input "learn: ")))
										main
									else return ()
	if (response == "learn") then do 
									answer <- promptLine "How can I respond to that: "
									system ("./appender learn " ++ ((format input answer)++"\n"))
									main 
								  else do 
								  	putStrLn ("Bot: " ++ response)
								  	main

-- TODO make a function to replace ' with \' for /bin/sh