{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "pha"
, license = "MIT"
, dependencies =
  [ "aff", "arrays", "effect", "free", "web-dom", "web-html", "web-uievents" ]
, packages = ./packages.dhall
, repository = "https://github.com/gbagan/purescript-pha"
, sources = [ "src/**/*.purs", "examples/**/*.purs", "test/**/*.purs" ]
}
