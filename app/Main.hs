module Main where

import Task
import Date (parseDueDate)
import Data.Maybe (fromJust)
import Data.Char (toLower)
import Text.Read (readMaybe)
import qualified TestMain


main :: IO ()
main = do
    putStrLn "Witaj w aplikacji dla to do list"
    {-}
    --TODO zapisywanie do pliku
    --loadingFile
    let saveFile = "data/save.txt"
    tasks <- loadTasks saveFile
-}
    let tasks = [ Task 1 "Spotkanie" "Opis1" (fromJust $ parseDueDate "02-01-2024") Low False
                , Task 2 "Projekt" "Opis2" (fromJust $ parseDueDate "03-01-2024") Medium False
                , Task 3 "Zadanie domowe" "Opis3" (fromJust $ parseDueDate "01-01-2024") High False
                ]

    helpMenu
    choiceMenu tasks

    -- TODO zapisywanie do pliku

{- --pobiera z pliku
loadingFile :: IO ()
loadingFile = do 

savingFile ::    
    -}

--wyswietla komendy
helpMenu :: IO ()
helpMenu = do
    putStrLn "=== Możliwe komendy ==="
    putStrLn " 1 / add / dodaj         - dodaj nowe zadanie"
    putStrLn " 2 / done / ukoncz       - oznacz zadanie jako ukonczone"
    putStrLn " 3 / modify / modyfikuj  - edytuj zadanie"
    putStrLn " 4 / delete / usun       - usuń zadanie"               
    putStrLn " 5 / print / wyswietl    - wyświetla zapisane zadania"
    putStrLn " 6 / filtr / sortuj      - sortuje zadania po ID / dacie / priorytecie"
    putStrLn " 7 / help / pomoc        - wyświetl liste poleceń ponownie"
    putStrLn " 8 / exit / koniec       - wyjdź i zapisz postęp"
--    putStrLn " 9 / load / zalacz       - załącz inny plik "

--TODO wszedzie pokazywac tym ładnym
choiceMenu :: [Task] -> IO ()
choiceMenu tasks = do
    putStrLn "Wybierz operacje"
    opt <- getLine
    --TODO zebrać bardziej razem te opcje
    case map toLower opt of
        "1" -> addMenu tasks
        "add" -> addMenu tasks
        "dodaj" -> addMenu tasks
        "2" -> doneMenu tasks
        "done" -> doneMenu tasks
        "ukoncz" -> doneMenu tasks
        "3" -> modifyMenu tasks --TODO
        "4" -> deleteMenu tasks
        "delete" -> deleteMenu tasks
        "usun" -> deleteMenu tasks
        "5" -> printMenu tasks
        "print" -> printMenu tasks 
        "wyswietl" -> printMenu tasks 
        "6" -> choiceMenu tasks --sortMenu --TODO
        "7" -> do
            helpMenu
            choiceMenu tasks
        "help" -> do
            helpMenu
            choiceMenu tasks 
        "pomoc" -> do
            helpMenu
            choiceMenu tasks
        "8" -> do --TODO
            --zapisywanie
            putStrLn "===Koniec==="
            return ()
--        "9" -> putStrLn "Tak" --TODO*
        _ -> do 
            putStrLn "Niepoprawna komenda"
            choiceMenu tasks

addMenu :: [Task] -> IO ()
addMenu tasks = do
    putStrLn "=== Dodawanie zadania ==="
    putStrLn "Tytuł:"
    t <- getLine
    putStrLn "Opis:"
    d <- getLine
    putStrLn "Data wykonania (DD-MM-YYYY):"
    dateStr <- getLine
    putStrLn "Priorytet (Low, Medium, High):"
    pStr <- getLine

    --Parsujemy priorytet jako wartość typu Priority
    let prio = case map toLower pStr of
                   "high"   -> High
                   "medium" -> Medium
                   _        -> Low
 
    case addTaskSafe tasks t d dateStr prio of
        Left err -> do
            putStrLn $ "Niedodano zadania - " ++ err
            choiceMenu tasks --bez zmian
        Right newTasks -> do 
            putStrLn "\nZadanie dodane:"
            print (head newTasks) --podgląd 
            putStrLn "=== ==="
            choiceMenu newTasks

doneMenu :: [Task] -> IO ()
doneMenu tasks = do
    putStrLn "=== Kończenie zadania ==="
    putStrLn "Id:"
    input <- getLine
    case readMaybe input :: Maybe Integer of
        Just id -> do
            let updatedTasks = markTaskDone id tasks
            let thisIdTasks = filter (\t -> tid t == id) updatedTasks
            if null thisIdTasks
                then putStrLn "Zadanie o podanym ID nie istnieje."
                else do
                   putStrLn "\nUkończone zadanie:"
                   print (thisIdTasks)
            putStrLn "=== ==="
            choiceMenu updatedTasks
        Nothing     -> do
            putStrLn "Id musi być liczbą całkowitą"
            putStrLn "=== ==="
            choiceMenu tasks

--TODO
modifyMenu :: [Task] -> IO ()
modifyMenu tasks = do
     putStrLn "=== Edytowanie zadania ==="
     putStrLn "TODO Id:"
     choiceMenu tasks

deleteMenu :: [Task] -> IO ()
deleteMenu tasks = do
    putStrLn "=== Usuwanie zadania ==="
    putStrLn "Id:"
    input <- getLine
    case readMaybe input :: Maybe Integer of
        Just id -> do        
            let foundTasks = filter (\t -> tid t == id) tasks
            if null foundTasks
                then do            
                    putStrLn "Zadanie o podanym ID nie istnieje."
                    putStrLn "=== ==="
                    choiceMenu tasks
                else do
                   putStrLn "Usuwanie zadania:"
                   print (foundTasks)
                   let updatedTasks = removeTaskById id tasks --nie przeszkadza jesli nie ma takiego
                   putStrLn "=== ==="
                   choiceMenu updatedTasks
        Nothing     -> do
            putStrLn "Id musi być liczbą całkowitą"
            putStrLn "=== ==="
            choiceMenu tasks


printMenu :: [Task] -> IO ()
printMenu tasks = do
    putStrLn $ prettyPrintTasks tasks
    choiceMenu tasks

sortMenu :: [Task] -> IO ()
sortMenu tasks = do  
    putStrLn "=== Sortowanie zadań ==="
    choiceMenu tasks


{-
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
-}


mainTest = TestMain.mainTest

