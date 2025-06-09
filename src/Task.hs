module Task where

import Data.List (sortBy)
import Date (DueDate, parseDueDate, parseDueDateSafe)


data Priority = Low | Medium | High deriving (Show, Read, Eq, Ord)

data Task = Task
    { tid           :: Integer
    , title         :: String
    , description   :: String
    , dueDate       :: DueDate
    , priority      :: Priority
    , done          :: Bool
    } deriving (Show, Eq)

addTask :: [Task] -> String -> String -> String -> Priority -> [Task]
addTask tasks title description dateStr priority =
    let nextId = if null tasks then 1 else maximum (map tid tasks) + 1
        Just date = parseDueDate dateStr
        newTask = Task nextId title description date priority False
    in newTask : tasks

addTaskSafe :: [Task] -> String -> String -> String -> Priority -> Either String [Task]
addTaskSafe tasks title description dateStr priority =
  case parseDueDateSafe dateStr of
    Left err -> Left err
    Right date ->
        let nextId = if null tasks then 1 else maximum (map tid tasks) + 1
            realTitle = if null title then "task" ++ show nextId else title
            newTask = Task nextId realTitle description date priority False
        in Right (newTask : tasks)

removeTaskById :: Integer -> [Task] -> [Task]
removeTaskById targetId =
    filter (\task -> tid task /= targetId)

modifyTaskById :: Integer -> (Task -> Task) -> [Task] -> [Task]
modifyTaskById targetId f =
    map (\t -> if tid t == targetId then f t else t)

markTaskDone :: Integer -> [Task] -> [Task]
markTaskDone targetId =
    modifyTaskById targetId (\t -> t { done = True })




-- TODO: można to uogólnić funktorami I guess
sortById :: [Task] -> [Task]
sortById = sortBy (\t1 t2 -> compare (tid t1) (tid t2))

sortByDate :: [Task] -> [Task]
sortByDate = sortBy (\t1 t2 -> compare (dueDate t1) (dueDate t2))

-- tutaj sortujemy malejąco, bo wyższy priorytet jest istotniejszy
sortByPriority :: [Task] -> [Task]
sortByPriority = sortBy (\t1 t2 -> compare (priority t2) (priority t1))


-- Wyświetlanie zadań --

color :: String -> String -> String
color code text =
    "\x1b[" ++ code ++ "m" ++ text ++ "\x1b[0m"

colorRed :: String -> String
colorRed = color "31"

colorGreen :: String -> String
colorGreen = color "32"

prettyPrintTask :: Task -> String
prettyPrintTask task =
    let statusIcon = if done task then "✔" else "✖"
        idStr      = "[" ++ show (tid task) ++ "]"
        titleStr   = "Tytuł: " ++ title task
        dateStr    = "Data: " ++ show (dueDate task)
        prioStr    = "Priorytet: " ++ show (priority task)
        descStr    = "Opis: " ++ description task
    in (if done task then colorGreen else colorRed) $ unlines
        [ idStr ++ " " ++ statusIcon ++ "  " ++ titleStr
        , "     " ++ dateStr ++ " | " ++ prioStr
        , "     " ++ descStr
        ]

prettyPrintTasks :: [Task] -> String
prettyPrintTasks tasks =
    unlines $ map prettyPrintTask tasks


