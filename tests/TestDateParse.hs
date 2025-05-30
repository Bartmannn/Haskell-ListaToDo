module TestDateParse (tests) where

import Test.HUnit
import Date (parseDueDate)
import Data.Maybe (isJust, isNothing)

tests :: Test
tests = TestList
  [ TestCase $
      assertBool "Poprawna data powinna zwrócić Just" $
        isJust (parseDueDate "21-05-2024")

  , TestCase $
      assertBool "Niepoprawna data powinna zwrócić Nothing" $
        isNothing (parseDueDate "2024-05-21")

  , TestCase $
      assertBool "Błędny format DD/MM/YYYY powinien zwrócić Nothing" $
        isNothing (parseDueDate "21/05/2024")
  ]
