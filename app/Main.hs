module Main where

import Task
import Reader 
import Writer 
import Date
import Data.Char (toLower)
import Text.Read (readMaybe)

main :: IO ()
main = do
    putStrLn "Witaj użytkowniku w aplikacji to do list"

       --loadingFile TODO bo nei działa
    fileName <- getFile
    putStrLn $ "Wczytywanie zadań z pliku: " ++ fileName
    tasks <- loadTasks ("data/" ++ fileName)
    putStrLn $ "Wczytano wszystkie zadania ( " ++ show (length tasks) ++ " )"

    helpMenu
    endTasks <- choiceMenu tasks
    if null endTasks
        then putStrLn "Zakończono bez zapisywania."
        else exitSave endTasks ("data/" ++ fileName)

--TODO wybor pliku
getFile :: IO String
getFile = do
    putStrLn "Czy chcesz wczytać dane z własnego pliku? W przeciwnym razie zostanie użyty domyślny (save.txt). (tak/nie)"
    answer <- getLine
    if map toLower answer `elem` ["tak", "t", "yes", "y"]
      then do
        putStrLn "Podaj nazwę pliku (np. save.txt):"
        name <- getLine
        return name
      else do
        let defaultFile = "save.txt"
        putStrLn $ "Użyto domyślnego pliku: " ++ defaultFile
        return defaultFile


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
    putStrLn " 6 / sort / sortuj       - sortuje zadania po ID / dacie / priorytecie"
    putStrLn " 7 / help / pomoc        - wyświetl liste poleceń ponownie"
    putStrLn " 8 / exit / koniec       - wyjdź i zapisz postęp"
    putStrLn " 9 / exit with no save   - wyjdź bez zapisywania"
--    putStrLn " 9 / load / zalacz       - załącz inny plik "

choiceMenu :: [Task] -> IO [Task]
choiceMenu tasks = do
    putStrLn "Wybierz operacje 1-9 (help - 7)"
    opt <- getLine
    --TODO *
    case map toLower opt of
        "1" -> addMenu tasks >>= choiceMenu
        "add" -> addMenu tasks >>= choiceMenu
        "dodaj" -> addMenu tasks >>= choiceMenu
        "2" -> doneMenu tasks >>= choiceMenu
        "done" -> doneMenu tasks >>= choiceMenu
        "ukoncz" -> doneMenu tasks >>= choiceMenu
        "3" -> modifyMenu tasks >>= choiceMenu
        "modify" -> modifyMenu tasks >>= choiceMenu
        "edit" -> modifyMenu tasks >>= choiceMenu
        "4" -> deleteMenu tasks >>= choiceMenu
        "delete" -> deleteMenu tasks >>= choiceMenu
        "usun" -> deleteMenu tasks >>= choiceMenu
        "5" -> printMenu tasks >>= choiceMenu
        "print" -> printMenu tasks >>= choiceMenu
        "show" -> printMenu tasks >>= choiceMenu
        "wyswietl" -> printMenu tasks >>= choiceMenu
        "6" -> sortMenu tasks >>= choiceMenu
        "sort" -> sortMenu tasks >>= choiceMenu
        "filtr" -> sortMenu tasks >>= choiceMenu
        "6 id" -> sortId tasks >>= choiceMenu
        "sortid" -> sortId tasks >>= choiceMenu
        "6 idr" -> sortIdR tasks >>= choiceMenu
        "sortidr" -> sortIdR tasks >>= choiceMenu
        "sortdt" -> sortDate tasks >>= choiceMenu
        "sortdtr" ->  sortDateR tasks >>= choiceMenu
        "sortpr"-> sortPrior tasks >>= choiceMenu
        "sortprr"-> sortPriorR tasks >>= choiceMenu
        "sortdone" -> sortOnlyDone tasks >>= choiceMenu
        "sortndone" -> sortOnlyNotDone tasks >>= choiceMenu
        "7" -> helpMenu >> choiceMenu tasks
        "help" -> helpMenu >> choiceMenu tasks 
        "h" -> helpMenu >> choiceMenu tasks 
        "pomoc" -> helpMenu >> choiceMenu tasks
        "8" -> return tasks
        "exit" -> return tasks
        "q" -> return tasks
        "quit" -> return tasks
        "koniec" -> return tasks
        "9" -> do
            putStrLn "Wyjście bez zapisywania."
            return []  -- lub return tasks, ale potem w `main` trzeba to zignorować
        "exitnosave" -> do
            putStrLn "Wyjście bez zapisywania."
            return []
        "wyjdz" -> do
            putStrLn "Wyjście bez zapisywania."
            return []
--        "9" -> putStrLn "Tak" --TODO*
        _ -> do 
            putStrLn "Niepoprawna komenda" >> choiceMenu tasks

addMenu :: [Task] -> IO [Task]
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
                   "h"      -> High 
                   "m"      -> Medium
                   "medium" -> Medium
                   _        -> Low
 
    case addTaskSafe tasks t d dateStr prio of
        Left err -> do
            putStrLn $ "Niedodano zadania - " ++ err
            return tasks --bez zmian
        Right newTasks -> do 
            putStrLn "\nZadanie dodane:"
            putStrLn $ prettyPrintTask (head newTasks) --TODO bezpieczniej niz head?
            putStrLn "=== ==="
            return newTasks

doneMenu :: [Task] -> IO [Task]
doneMenu tasks = do
    putStrLn "=== Kończenie zadania ==="
    putStrLn "Podaj id zadania:"
    input <- getLine
    case readMaybe input :: Maybe Integer of
        Just taskId -> do
            let updatedTasks = markTaskDone taskId tasks
            let thisIdTasks = filter (\t -> tid t == taskId) updatedTasks
            if null thisIdTasks
                then putStrLn "Zadanie o podanym ID nie istnieje."
                else do
                   putStrLn "\nUkończone zadanie:"
                   putStrLn $ prettyPrintTasks thisIdTasks 
            putStrLn "=== ==="
            choiceMenu updatedTasks
        Nothing     -> do
            putStrLn "Id musi być liczbą całkowitą"
            putStrLn "=== ==="
            choiceMenu tasks

modifyMenu :: [Task] -> IO [Task]
modifyMenu tasks = do
    putStrLn "=== Edytowanie zadania ==="
    putStrLn "Podaj id zadania:"
    input <- getLine

    --zadanie dla podanego id
    case readMaybe input :: Maybe Integer of
        Just id -> do
            let idTasks = filter (\t -> tid t == id) tasks
            
            if idTasks == [] 
                then do
                    putStrLn "Zadanie o podanym ID nie istnieje."
                    putStrLn "=== ==="
                    return tasks
                else do
                    putStrLn "Wybrane zadanie:"
                    putStrLn $ prettyPrintTasks idTasks 
                    
                    --wybor zmiany
                    putStrLn "Co chcesz zmienic w zadaniu: tytuł, opis, date, priorytet"
                    inputType <- getLine
                    let lowerInput = map toLower inputType
                    
                    if lowerInput `elem` ["tytul","tytuł","title","1", "t"] 
                        then do 
                            putStrLn "Podaj nowy tytuł:"
                            newTitle <- getLine

                            let updatedTasks = modifyTaskById id (\t -> t { title = newTitle }) tasks 
                            --putStrLn $ prettyPrintTasks updatedTasks
                            putStrLn "Zmieniono tytuł"
                            putStrLn $ prettyPrintTasks (filter (\t -> tid t == id) updatedTasks)
                            putStrLn "=== ==="
                            return updatedTasks
                    else if lowerInput `elem` ["opis","description","2", "o"] 
                        then do
                            putStrLn "Podaj nowy opis:"
                            newDes <- getLine

                            let updatedTasks = modifyTaskById id (\t -> t { description = newDes }) tasks 
                            putStrLn "Zmieniono opis"
                            putStrLn $ prettyPrintTasks (filter (\t -> tid t == id) updatedTasks)
                            putStrLn "=== ==="
                            return updatedTasks
                    else if lowerInput `elem` ["data","date","finish","3", "d"] 
                        then do   
                            putStrLn "Podaj nową date wykonania (DD-MM-YYYY):"
                            datestr <- getLine     
                            case parseDueDateSafe datestr of
                                Left err -> do 
                                    putStrLn "Podana data jest niepoprawna - niewykonano zmiany"
                                    putStrLn "=== ==="
                                    return tasks
                                Right newDate -> do
                                    let updatedTasks = modifyTaskById id (\t -> t { dueDate = newDate }) tasks
                                    putStrLn "Zmieniono date"
                                    putStrLn $ prettyPrintTasks (filter (\t -> tid t == id) updatedTasks)
                                    putStrLn "=== ==="
                                    return updatedTasks 
                                    
                    else if lowerInput `elem` ["priorytet","priority","4", "p"] 
                        then do
                            putStrLn "Podaj nowy priorytet (Low, Medium, High):"
                            prior <- getLine

                            let newPrio = case map toLower prior of
                                  "high"   -> High 
                                  "h"      -> High
                                  "medium" -> Medium
                                  "m"      -> Medium
                                  _        -> Low
    
                            let updatedTasks = modifyTaskById id (\t -> t { priority = newPrio }) tasks
                            
                            putStrLn "Zmieniono priorytet"
                            putStrLn $ prettyPrintTasks (filter (\t -> tid t == id) updatedTasks)
                            putStrLn "=== ==="
                            return updatedTasks 
                        
                        
                    else do     
                        putStrLn "Nie ma takiej opcji"
                        putStrLn "=== ==="
                        return tasks

        Nothing -> do
            putStrLn "Id musi być liczbą całkowitą"
            putStrLn "=== ==="
            return tasks

deleteMenu :: [Task] -> IO [Task]
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
                    return tasks
                else do
                   putStrLn "Usuwanie zadania:"
                   putStrLn $ prettyPrintTasks foundTasks ----------- 
                   let updatedTasks = removeTaskById taskId tasks --nie przeszkadza jesli nie ma takiego
                   putStrLn "=== ==="
                   return updatedTasks
        Nothing     -> do
            putStrLn "Id musi być liczbą całkowitą"
            putStrLn "=== ==="
            return tasks


printMenu :: [Task] -> IO [Task]
printMenu tasks = do
    putStrLn $ prettyPrintTasks tasks
    return tasks

sortMenu :: [Task] -> IO [Task] 
sortMenu tasks = do  
    putStrLn "=== Sortowanie zadań ==="
    putStrLn "Możliwe sortowanie:"
    putStrLn " Id      - sortuje po Id rosnąco"
    putStrLn " IdR     - sortuje po Id malejąco"
    putStrLn " Dt      - sortuje po dacie rosnąco"
    putStrLn " DtR     - sortuje po dacie malejąco"
    putStrLn " Pr      - sortuje od najsilnijeszego priorytetu"
    putStrLn " PrR     - sortuje od najsłabszego priorytetu"
    putStrLn " Done    - pokazuje tylko ukończone"
    putStrLn " NDone   - pokazuje tylko nie ukończone"
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
        "done" -> sortOnlyDone tasks
        "ndone" -> sortOnlyNotDone tasks
        "not done" -> sortOnlyNotDone tasks
        _ -> return tasks 

sortId :: [Task] -> IO [Task]
sortId tasks = do
    putStrLn "=== Sortowanie wg Id rosnąco ==="
    let sta = sortById tasks 
    putStrLn $ prettyPrintTasks sta
    return sta

sortIdR :: [Task] -> IO [Task]
sortIdR tasks = do    
    putStrLn "=== Sortowanie wg Id - malejąco ==="
    let stasks = sortByIdDesc tasks
    putStrLn $ prettyPrintTasks stasks
    return stasks

sortDate :: [Task] -> IO [Task]
sortDate tasks = do
    putStrLn "=== Sortowanie wg Daty - rosnąco  ==="
    let sta = sortByDate tasks
    putStrLn $ prettyPrintTasks sta 
    return sta

sortDateR :: [Task] -> IO [Task]
sortDateR tasks = do
    putStrLn "=== Sortowanie wg Daty - malejąco ==="
    let sta = sortByDateDesc tasks
    putStrLn $ prettyPrintTasks sta 
    return sta

sortPrior :: [Task] -> IO [Task]
sortPrior tasks = do
    putStrLn "=== Sortowanie wg Priorytetu od najmocniejszego ==="
    let sta = sortByPriority tasks
    putStrLn $ prettyPrintTasks sta 
    return sta

sortPriorR :: [Task] -> IO [Task]
sortPriorR tasks = do
    putStrLn "=== Sortowanie wg Priorytetu od najsłabszego ==="
    let sta = sortByPriorityInc tasks
    putStrLn $ prettyPrintTasks sta 
    return sta

sortOnlyDone :: [Task] -> IO [Task] 
sortOnlyDone tasks = do
    putStrLn "=== Wyświetlono tylko ukończone ==="
    let dtasks = (filter (\t -> done t == True) tasks)
    putStrLn $ prettyPrintTasks dtasks
    return tasks  

sortOnlyNotDone :: [Task] -> IO [Task] 
sortOnlyNotDone tasks = do
    putStrLn "=== Wyświetlono tylko nie ukończone ==="
    let dtasks = (filter (\t -> done t == False) tasks)
    putStrLn $ prettyPrintTasks dtasks
    return tasks

