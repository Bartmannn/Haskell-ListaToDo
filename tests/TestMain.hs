module Main where

import Test.HUnit ( runTestTT, Test(TestList) )   

import qualified TestSort
import qualified TestAddTask
import qualified TestDateParse

main :: IO ()
main = do
    putStrLn "=== Uruchamianie testów ==="
    _ <- runTestTT $ TestList
        [   TestAddTask.tests
        ,   TestSort.tests
        ,   TestDateParse.tests
        ]
    return ()
