module Pha.Util where

import Prelude
import Pha.Html (class EUnit, toStr)

translate :: ∀u1 u2. EUnit u1 => EUnit u2 => u1 -> u2 -> String
translate x' y' = "translate(" <> toStr x' <> "," <> toStr y' <> ")"

rgbColor :: Int -> Int -> Int -> String
rgbColor r g' b = "rgb(" <> show r <> "," <> show g' <> "," <> show b <> ")"