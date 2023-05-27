module Pha.Html.Util
  where

import Prelude

import Pha.Svg.Attributes (class IsLength, toString)

-- |  63.7 → "63.7px"
px ∷ Number → String
px a = show a <> "px"

-- | 63 → 63.px
px' ∷ Int → String
px' a = show a <> "px"

-- |  0.7 → "70%"
pc ∷ Number → String
pc a = show (100.0 * a) <> "%"

-- | translate (px 40.0) (px 30.0) → "translate(40px,30px)"
translate ∷ forall x y. IsLength x => IsLength y => x → y → String
translate x y = "translate(" <> toString x <> "," <> toString y <> ")"

-- | rgbColor 128 64 30 → "rgb(128,64,30)"
rgbColor ∷ Int → Int → Int → String
rgbColor r g' b = "rgb(" <> show r <> "," <> show g' <> "," <> show b <> ")"