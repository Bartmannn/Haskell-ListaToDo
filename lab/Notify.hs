{-# LANGUAGE CPP #-}

module Notify (notify) where

import System.Info (os)
import System.Process (callCommand)

notify :: String -> String -> IO ()
notify title message =
#if defined(mingw32_HOST_OS)
  callCommand $ "powershell -Command \"New-BurntToastNotification -Text '" ++ title ++ "', '" ++ message ++ "'\""

#elif defined(darwin_HOST_OS)
  callCommand $ "osascript -e 'display notification \"" ++ message ++ "\" with title \"" ++ title ++ "\"'"

#elif defined(linux_HOST_OS)
  callCommand $ "notify-send \"" ++ title ++ "\" \"" ++ message ++ "\""

#else
  putStrLn $ "Powiadomienie: " ++ title ++ ": " ++ message
#endif



simpleNotify :: String -> String -> IO ()
simpleNotify title message =
  case os of
    "linux"   -> callCommand $ "notify-send -i dialog-information -t 5000 \"✅ " ++ escape title ++ "\" \"" ++ escape message ++ "\""
    "mingw32" -> callCommand $
      "powershell -Command \"New-BurntToastNotification -Text '" ++ escape title ++ "', '" ++ escape message ++ "'\""
    "darwin"  -> callCommand $
      "osascript -e 'display notification \"" ++ escape message ++ "\" with title \"" ++ escape title ++ "\"'"
    _         -> putStrLn $ "Nieobsługiwany system. [" ++ os ++ "] Powiadomienie: " ++ title ++ ": " ++ message

-- Funkcja pomocnicza do ucieczki znaków (np. cudzysłowów)
escape :: String -> String
escape = concatMap (\c -> if c == '"' then "\\\"" else [c])


-- Linux: --
-- callCommand "notify-send -i dialog-information -t 5000 \"✅ Zadanie ukończone\" \"Zadanie #3 zostało wykonane!\""
