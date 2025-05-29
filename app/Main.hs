module Main where

import Task

main :: IO ()
main = do
  putStrLn "=== Dodawanie zadania ==="
  putStrLn "Tytuł:"
  t <- getLine
  putStrLn "Opis:"
  d <- getLine
  putStrLn "Data wykonania (DD-MM-YYYY):"
  dateStr <- getLine
  putStrLn "Priorytet (Low, Medium, High):"
  pStr <- getLine

  -- Parsujemy priorytet jako wartość typu Priority
  let prio = case pStr of
               "High"   -> High
               "Medium" -> Medium
               _        -> Low

  -- Zakładamy, że wszystko jest poprawne – użycie "Just"
  let taskList = []
      updatedList = addTask taskList t d dateStr prio

  putStrLn "\nZadanie dodane:"
  print (last updatedList)

