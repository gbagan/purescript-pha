{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "pha"
, dependencies =
  [ "effect", "web-html", "web-uievents" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "examples/**/*.purs", "test/**/*.purs" ]
}
