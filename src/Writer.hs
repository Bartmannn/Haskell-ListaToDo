module Writer where

import Task
import System.IO (withFile, IOMode(AppendMode, WriteMode), hPutStrLn)

-- Konwersja Task -> String
serializeTask :: Task -> String
serializeTask (Task i t d due p done) =
  unwords [show i, replaceSpaces t, replaceSpaces d, show due, show p, show done]

-- Zamienia spacje na podkreślenia
replaceSpaces :: String -> String
replaceSpaces = map (\c -> if c == ' ' then '_' else c)




-- Zapis listy zadań do pliku
saveTasks :: FilePath -> [Task] -> IO ()
saveTasks path tasks =
  withFile path WriteMode $ \handle ->
    mapM_ (hPutStrLn handle . serializeTask) tasks

-- Dopisuje do pliku 
saveTasksAppend :: FilePath -> [Task] -> IO ()
saveTasksAppend path tasks =
  withFile path AppendMode $ \handle ->
    mapM_ (hPutStrLn handle . serializeTask) tasks
