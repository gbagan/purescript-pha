module Pha.Html.Util where

import Prelude

-- |  63.7 → "63.7px"
px ∷ Number → String
px x = show x <> "px"

-- | 63 → 63.px
px' ∷ Int → String
px' a = show a <> "px"

-- |  0.7 → "70%"
pc ∷ Number → String
pc x = show (x * 100.0) <> "%"

-- | translate (px 40.0) (px 30.0) → "translate(40px,30px)"
translate ∷ String → String → String
translate x y = "translate(" <> x <> "," <> y <> ")"

-- | rgbColor 128 64 30 → "rgb(128,64,30)"
rgbColor ∷ Int → Int → Int → String
rgbColor r g' b = "rgb(" <> show r <> "," <> show g' <> "," <> show b <> ")"