module Task where

import Date (DueDate)

data Priority = Low | Medium | High deriving (Show, Eq)

data Task = Task
    { tid           :: Integer
    , title         :: String
    , description   :: String
    , dueDate       :: DueDate
    , priority      :: Priority
    , done          :: Bool
    } deriving (Show, Eq)

addTask :: [Task] -> String -> String -> DueDate -> Priority -> [Task]
addTask tasks title ""
addTask tasks title description date priority =
    Task (nextId tasks) title description date priority False : tasks

nextId :: [Task] -> Integer
nextId [] = 1
nextId ts = maximum (map tid ts) + 1

parseDate :: String -> Maybe Day
parseDate = parseTimeM True defaultTimeLocale "%Y-%m-%d"

