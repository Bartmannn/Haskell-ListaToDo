module Task where

import Data.List (sortBy)
import Date (DueDate, parseDueDate)

data Priority = Low | Medium | High deriving (Show, Eq, Ord)

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


-- TODO: można to uogólnić funktorami I guess
sortById :: [Task] -> [Task]
sortById = sortBy (\t1 t2 -> compare (tid t1) (tid t2))

sortByDate :: [Task] -> [Task]
sortByDate = sortBy (\t1 t2 -> compare (dueDate t1) (dueDate t2))

-- tutaj sortujemy malejąco, bo wyższy priorytet jest istotniejszy
sortByPriority :: [Task] -> [Task]
sortByPriority = sortBy (\t1 t2 -> compare (priority t2) (priority t1))