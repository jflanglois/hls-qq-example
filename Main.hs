{-# LANGUAGE QuasiQuotes #-}

import Data.String.Interpolate (i)

main :: IO ()
main = putStrLn [i|Hello #{42 :: Int}|]
