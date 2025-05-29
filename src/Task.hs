module Task where

import Date (DueDate, parseDueDate)

data Priority = Low | Medium | High deriving (Show, Eq)

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
    in newTask : tasks -- TODO: sortowanie

nextId :: [Task] -> Integer
nextId [] = 1
nextId ts = maximum (map tid ts) + 1

