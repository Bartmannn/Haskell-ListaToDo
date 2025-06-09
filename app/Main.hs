module Main where

import Task
import Reader
import Writer
import Data.Char (toLower)
import Text.Read (readMaybe)


main :: IO ()
main = do
    putStrLn "Witaj w aplikacji dla to do list"

       --loadingFile TODO bo nei działa
    fileName <- getFile
    tasks <- loadTasks fileName

    helpMenu
    endTasks <- choiceMenu tasks
    exitSave endTasks fileName

--TODO wybor pliku
getFile :: IO String
getFile = do
    let sourceName = "data/save.txt"
   -- putStrLn ("Dane z pliku " ++ sourceName)
    return sourceName

exitSave :: [Task] -> FilePath -> IO ()
exitSave tasks fileName = do
    let tosave = sortById tasks
    saveTasks fileName tosave
    putStrLn ("Zapisano w pliku " ++ fileName)
    
exitSaveAppend:: [Task] -> FilePath -> IO ()
exitSaveAppend tasks fileName = do
    let tosave = sortById tasks
    saveTasksAppend fileName tosave
    putStrLn ("Zapisano w pliku " ++ fileName)

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
choiceMenu :: [Task] -> IO [Task]
choiceMenu tasks = do
    putStrLn "Wybierz operacje 1-8"
    opt <- getLine
    --TODO *
    case map toLower opt of
        "1" -> addMenu tasks
        "add" -> addMenu tasks
        "dodaj" -> addMenu tasks
        "2" -> doneMenu tasks
        "done" -> doneMenu tasks
        "ukoncz" -> doneMenu tasks
        "3" -> modifyMenu tasks --TODO
        "modify" -> modifyMenu tasks 
        "edit" -> modifyMenu tasks 
        "4" -> deleteMenu tasks
        "delete" -> deleteMenu tasks
        "usun" -> deleteMenu tasks
        "5" -> printMenu tasks
        "print" -> printMenu tasks 
        "show" -> printMenu tasks 
        "wyswietl" -> printMenu tasks 
        "6" -> sortMenu tasks 
        "sort" -> sortMenu tasks
        "filtr" -> sortMenu tasks
        "6 id" -> sortId tasks
        "sortid" -> sortId tasks
        "6 idr" -> sortIdR tasks
        "sortidr" -> sortIdR tasks
        "sortdt" -> sortDate tasks
        "sortdtr" ->  sortDateR tasks
        "sortpr"-> sortPrior tasks
        "sortprr"-> sortPriorR tasks
        "7" -> do
            helpMenu
            choiceMenu tasks
        "help" -> do
            helpMenu
            choiceMenu tasks 
        "pomoc" -> do
            helpMenu
            choiceMenu tasks
        "8" -> return tasks
        "exit" -> return tasks
        "q" -> return tasks
        "quit" -> return tasks
        "koniec" -> return tasks
--        "9" -> putStrLn "Tak" --TODO*
        _ -> do 
            putStrLn "Niepoprawna komenda" >> choiceMenu tasks
        return tasks --usun

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
        Just taskId -> do
            let updatedTasks = markTaskDone taskId tasks
            let thisIdTasks = filter (\t -> tid t == taskId) updatedTasks
            if null thisIdTasks
                then putStrLn "Zadanie o podanym ID nie istnieje."
                else do
                   putStrLn "\nUkończone zadanie:"
                   print thisIdTasks
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
        Just taskId -> do        
            let foundTasks = filter (\t -> tid t == taskId) tasks
            if null foundTasks
                then do            
                    putStrLn "Zadanie o podanym ID nie istnieje."
                    putStrLn "=== ==="
                    choiceMenu tasks
                else do
                   putStrLn "Usuwanie zadania:"
                   print foundTasks
                   let updatedTasks = removeTaskById taskId tasks --nie przeszkadza jesli nie ma takiego
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
    putStrLn "Możliwe sortowanie:"
    putStrLn " Id      - sortuje po Id rosnąco"
    putStrLn " IdR     - sortuje po Id malejąco"
    putStrLn " Dt    - sortuje po dacie rosnąco"
    putStrLn " DtR   - sortuje po dacie malejąco"
    putStrLn " Pr    - sortuje od najsilnijeszego priorytetu"
    putStrLn " PrR   - sortuje od najsłabszego priorytetu"
    opt <- getLine
    case map toLower opt of
        "id" -> sortId tasks
        "id asc" -> sortId tasks
        "idr" -> sortIdR tasks
        "id dec" -> sortIdR tasks
        "dt" -> sortDate tasks
        "dt asc" -> sortDate tasks
        "dtr" -> sortDateR tasks
        "dt dec" -> sortDateR tasks
        "pr" -> sortPrior tasks
        "pr dec" -> sortPrior tasks
        "prr" -> sortPriorR tasks
        "pr inc" -> sortPriorR tasks
        _ -> choiceMenu tasks
sortId :: [Task] -> IO ()
sortId tasks = do
    putStrLn "=== Sortowanie wg Id rosnąco ==="
    let sta = sortById tasks 
    putStrLn $ prettyPrintTasks sta
    choiceMenu sta

sortIdR :: [Task] -> IO ()
sortIdR tasks = do    
    putStrLn "=== Sortowanie wg Id - malejąco ==="
    let stasks = sortByIdDesc tasks
    putStrLn $ prettyPrintTasks stasks
    choiceMenu stasks

sortDate :: [Task] -> IO ()
sortDate tasks = do
    putStrLn "=== Sortowanie wg Daty - rosnąco  ==="
    let sta = sortByDate tasks
    putStrLn $ prettyPrintTasks sta 
    choiceMenu sta

sortDateR :: [Task] -> IO ()
sortDateR tasks = do
    putStrLn "=== Sortowanie wg Daty - malejąco ==="
    let sta = sortByDateDesc tasks
    putStrLn $ prettyPrintTasks sta 
    choiceMenu sta

sortPrior :: [Task] -> IO ()
sortPrior tasks = do
    putStrLn "=== Sortowanie wg Priorytetu od najmocniejszego ==="
    let sta = sortByPriority tasks
    putStrLn $ prettyPrintTasks sta 
    choiceMenu sta

sortPriorR :: [Task] -> IO ()
sortPriorR tasks = do
    putStrLn "=== Sortowanie wg Priorytetu od najsłabszego ==="
    let sta = sortByPriorityInc tasks
    putStrLn $ prettyPrintTasks sta 
    choiceMenu sta


