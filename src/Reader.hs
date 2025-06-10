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
           <*> Just (giveBackSpaces t)
           <*> Just (giveBackSpaces d)
           <*> parseDueDate date
           <*> readMaybe p
           <*> readMaybe doneStr
    _ -> Nothing

giveBackSpaces :: String -> String
giveBackSpaces = map (\c -> if c == '_' then ' ' else c)

-- Wczytanie listy zadań z pliku
loadTasks :: FilePath -> IO [Task]
loadTasks path = do
  exists <- doesFileExist path
  if not exists
    then return []
    else do
      content <- readFile path
      length content `seq` return (mapMaybe deserializeTask (lines content))
