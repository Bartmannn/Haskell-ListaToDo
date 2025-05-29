module Date
  ( DueDate(..)
  , parseDueDate
  , daysLeft
  ) where

import Data.Time
import Data.Time.Format (defaultTimeLocale, parseTimeM)
import GHC.Generics (Generic)

-- tworzymy nasz własny typ daty na podstawie Day
newtype DueDate = DueDate { getDay :: Day }
  deriving (Eq, Ord, Generic)

-- sposób wyświetlania dat
instance Show DueDate where
  show (DueDate d) = formatTime defaultTimeLocale "%d-%m-%Y" d

-- Parsowanie "DD-MM-YYYY"
parseDueDate :: String -> Maybe DueDate
parseDueDate str = DueDate <$> parseTimeM True defaultTimeLocale "%d-%m-%Y" str

-- Obliczamy tutaj liczbę dni do końca terminu
daysLeft :: Maybe DueDate -> IO (Maybe Integer)
daysLeft Nothing = return Nothing
daysLeft (Just (DueDate day)) = do
  today <- utctDay <$> getCurrentTime
  return $ Just (diffDays day today)

