module Pha.Util where

import Prelude

-- |  63.7 -> "63.7px"
px :: Number -> String
px x = show x <> "px"
-- |  0.7 -> "70%"
pc :: Number -> String
pc x = show (x * 100.0) <> "%"

translate :: String -> String -> String
translate x y = "translate(" <> x <> "," <> y <> ")"

rgbColor :: Int -> Int -> Int -> String
rgbColor r g' b = "rgb(" <> show r <> "," <> show g' <> "," <> show b <> ")"