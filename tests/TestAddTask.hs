module TestAddTask (tests) where

import Date (parseDueDate)
import Test.HUnit
import Task

taskList = []

tests :: Test
tests = TestList
  [ TestCase $
      let result = addTask taskList "Zadanie" "Opis" "01-06-2024" Medium
      in tid (head result) @?= 1

  , TestCase $
      let result = addTask taskList "Coś" "Opis" "01-06-2024" Low
      in priority (head result) @?= Low
  ]
