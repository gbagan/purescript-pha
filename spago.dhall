{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "pha"
, license = "MIT"
, dependencies =
  [ "aff"
  , "arrays"
  , "bifunctors"
  , "datetime"
  , "effect"
  , "foldable-traversable"
  , "free"
  , "integers"
  , "maybe"
  , "prelude"
  , "profunctor-lenses"
  , "refs"
  , "tailrec"
  , "transformers"
  , "tuples"
  , "unsafe-coerce"
  , "unsafe-reference"
  , "web-dom"
  , "web-events"
  , "web-html"
  , "web-pointerevents"
  , "web-uievents"
  ]
, packages = ./packages.dhall
, repository = "https://github.com/gbagan/purescript-pha"
, sources = [ "src/**/*.purs", "examples/**/*.purs", "test/**/*.purs" ]
}
