{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "pha"
, license = "MIT"
, dependencies =
    [ "argonaut"
    , "argonaut-core"
    , "debug"
    , "effect"
    , "either"
    , "foldable-traversable"
    , "foreign"
    , "free"
    , "profunctor-lenses"
    , "run"
    ]
, packages = ./packages.dhall
, repository = "git://github.com/gbagan/purescript-pha.git"
, sources = [ "src/**/*.purs", "test/**/*.purs", "examples/**/*.purs" ]
}
