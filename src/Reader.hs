module Reader where

import Task
import Date (parseDueDate)
import Text.Read (readMaybe)
import Data.Maybe (mapMaybe)
import System.Directory (doesFileExist)

-- Konwersja String -> Maybe Task
deserializeTask :: String -> Maybe Task
deserializeTask str =
  case words str of
    (i:t:d:date:p:doneStr:_) ->
      Task <$> readMaybe i
           <*> readMaybe t
           <*> readMaybe d
           <*> (parseDueDate =<< readMaybe date)
           <*> readMaybe p
           <*> readMaybe doneStr
    _ -> Nothing

-- Wczytanie listy zadań z pliku
loadTasks :: FilePath -> IO [Task]
loadTasks path = do
  exists <- doesFileExist path
  if not exists
    then return []
    else do
      content <- readFile path
      length content `seq` return (mapMaybe deserializeTask (lines content))