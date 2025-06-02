module Main where

import Task
import Date (parseDueDate)
import Data.Maybe (fromJust)
import qualified TestMain


main :: IO ()
main = do

    let saveFile = "data/save.txt"
    tasks <- loadTasks saveFile

    let tasks = [ Task 1 "Spotkanie" "Opis1" (fromJust $ parseDueDate "02-01-2024") Low False
                , Task 2 "Projekt" "Opis2" (fromJust $ parseDueDate "03-01-2024") Medium False
                , Task 3 "Zadanie domowe" "Opis3" (fromJust $ parseDueDate "01-01-2024") High False
                ]

    putStrLn "=== Sortowanie wg Id ==="
    putStrLn $ prettyPrintTasks $ sortById tasks

    putStrLn "=== Sortowanie wg Daty ==="
    putStrLn $ prettyPrintTasks $ sortByDate tasks

    putStrLn "=== Sortowanie wg Priorytetu ==="
    putStrLn $ prettyPrintTasks $ sortByPriority tasks

    putStrLn "=== Usuwanie zadania ==="
    putStrLn $ prettyPrintTasks $ removeTaskById 2 tasks

    putStrLn "=== Kończenie zadania ==="
    putStrLn $ prettyPrintTasks $ markTaskDone 2 tasks

    saveTasks saveFile updatedList

    -- putStrLn "=== Dodawanie zadania ==="
    -- putStrLn "Tytuł:"
    -- t <- getLine
    -- putStrLn "Opis:"
    -- d <- getLine
    -- putStrLn "Data wykonania (DD-MM-YYYY):"
    -- dateStr <- getLine
    -- putStrLn "Priorytet (Low, Medium, High):"
    -- pStr <- getLine

    -- -- Parsujemy priorytet jako wartość typu Priority
    -- let prio = case pStr of
    --               "High"   -> High
    --               "Medium" -> Medium
    --               _        -> Low

    -- -- Zakładamy, że wszystko jest poprawne – użycie "Just"
    -- let taskList = []
    --     updatedList = addTask taskList t d dateStr prio

    -- putStrLn "\nZadanie dodane:"
    -- print (last updatedList)


mainTest = TestMain.mainTest

