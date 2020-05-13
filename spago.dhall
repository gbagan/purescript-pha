{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "pha"
, dependencies =
  [ "console", "effect", "foreign", "profunctor-lenses", "psci-support", "run", "web-html" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "examples/**/*.purs", "test/**/*.purs" ]
}
