module Main where

import Date (parseDueDate, daysLeft)

main :: IO ()
main = case parseDueDate "01-06-2025" of
  Just date -> do
    days <- daysLeft date
    print $ "Pozostalo dni: " ++ show days
  Nothing -> putStrLn "Nieprawidlowy format daty"

