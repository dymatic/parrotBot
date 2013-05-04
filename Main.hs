-- ParrotBot

import System.IO

import LibHaskell.LibLists
import ProjectSpecific
import System.Process
import System.Exit
import System.Environment

promptLine :: String -> IO String
promptLine prompt = do
    putStr prompt
    hFlush stdout
    getLine

main = do
	homeDir <- getEnv "HOME"
	learnConfig <- openFile (homeDir ++ "/.parrotBot/config") ReadMode
	learnConfigContents <- hGetContents learnConfig
	learnTextFile <- openFile (grab (lines learnConfigContents)) ReadMode
	learnText <- hGetContents learnTextFile
	
	let cmdAppend = ("./appender " ++ (grab (lines learnConfigContents)) ++ " ")
	let params = makeAllParameters (sanitize (lines learnText))
	inputs <- promptLine "You: "
	let input = sanitizeInput inputs
	let response = formulateResponse params input
	if (input == "exit") then  exitSuccess else return ()
	if (input `contains` "learn:") then do
										system (cmdAppend ++ (restructure (afterList input "learn: ")))
										main
									else return ()
	if (response == "learn") then do 
									answer <- promptLine "How can I respond to that: "
									system (cmdAppend ++ ((format input answer)++"\n"))
									main 
								  else do 
								  	putStrLn ("Bot: " ++ response)
								  	main

-- TODO make a function to replace ' with \' for /bin/sh