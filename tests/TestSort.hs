module TestSort (tests) where

import Test.HUnit
import Task
import Date (parseDueDate)
import Data.Maybe (fromJust)
import Control.Exception (assert)
import Data.Type.Coercion (TestCoercion)

-- przykładowe zadania (nieposortowane)
sampleTasks :: [Task]
sampleTasks =
  [ Task 3 "C" "" (fromJust $ parseDueDate "15-06-2024") Medium False
  , Task 2 "B" "" (fromJust $ parseDueDate "30-06-2024") Low False
  , Task 1 "A" "" (fromJust $ parseDueDate "01-06-2024") High False
  ]

-- funkcje sprawdzające sortowanie

isSortedByDate :: [Task] -> Bool
isSortedByDate tasks =
  all (\(a, b) -> dueDate a <= dueDate b) (zip sorted (tail sorted))
  where sorted = sortByDate tasks

isSortedById :: [Task] -> Bool
isSortedById tasks =
  all (\(a, b) -> tid a <= tid b) (zip sorted (tail sorted))
  where sorted = sortById tasks

isSortedByPriority :: [Task] -> Bool
isSortedByPriority tasks =
  all (\(a, b) -> priority a >= priority b) (zip sorted (tail sorted))
  where sorted = sortByPriority tasks

-- testy

testSortById :: Test
testSortById = TestCase $
    assertBool "Sortowanie według ID nie działa poprawnie!"
                (isSortedById sampleTasks)

testSortByDate :: Test
testSortByDate = TestCase $
    assertBool  "Sortowanie według daty nie działa poprawnie!"
                (isSortedByDate sampleTasks)

testSortByPriority :: Test
testSortByPriority = TestCase $
    assertBool  "Sortowanie według priorytetu nie działa poprawnie!"
                (isSortedByPriority sampleTasks)

tests :: Test
tests = TestList
    [ testSortById
    , testSortByDate
    , testSortByPriority
    ]
                
