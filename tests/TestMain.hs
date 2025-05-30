module TestMain where

import Test.HUnit

import qualified TestSort
import qualified TestAddTask
import qualified TestDateParse

mainTest :: IO Counts
mainTest = runTestTT $ TestList
    [   TestAddTask.tests
    ,   TestSort.tests
    ,   TestDateParse.tests
    ]
