module Date
  ( DueDate(..)
  , parseDueDate
  , daysLeft
  , parseDueDateSafe
  ) where

import Data.Time
-- import GHC.Generics (Generic)
import Data.Time.Format (defaultTimeLocale, parseTimeM)

-- tworzymy nasz własny typ daty na podstawie Day
newtype DueDate = DueDate { getDay :: Day }
  deriving (Eq, Ord)

-- sposób wyświetlania dat
instance Show DueDate where
  show (DueDate d) = formatTime defaultTimeLocale "%d-%m-%Y" d

-- Parsowanie "DD-MM-YYYY"
parseDueDate :: String -> Maybe DueDate
parseDueDate str = DueDate <$> parseTimeM True defaultTimeLocale "%d-%m-%Y" str

parseDueDateSafe :: String -> Either String DueDate
parseDueDateSafe str =
  case parseDueDate str of
    Just d  -> Right d
    Nothing -> Left $ "Niepoprawna data: \"" ++ str ++ "\". Oczekiwano formatu DD-MM-YYYY"


-- Obliczamy tutaj liczbę dni do końca terminu
daysLeft :: Maybe DueDate -> IO (Maybe Integer)
daysLeft Nothing = return Nothing
daysLeft (Just (DueDate day)) = do
  today <- utctDay <$> getCurrentTime
  return $ Just (diffDays day today)
