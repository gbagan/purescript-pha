{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "pha"
, license = "MIT"
, dependencies =
  [ "aff"
  , "bifunctors"
  , "effect"
  , "foldable-traversable"
  , "free"
  , "functions"
  , "maybe"
  , "ordered-collections"
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
, sources = [ "src/**/*.purs" ]
}
