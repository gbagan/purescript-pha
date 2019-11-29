{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "pha"
, license = "MIT"
, dependencies =
    [ "aff"
    , "argonaut"
    , "argonaut-core"
    , "console"
    , "debug"
    , "effect"
    , "either"
    , "foreign"
    , "profunctor-lenses"
    , "psci-support"
    , "run"
    ]
, packages = ./packages.dhall
, repository = "git://github.com/gbagan/purescript-pha.git"
, sources = [ "src/**/*.purs", "test/**/*.purs", "examples/**/*.purs" ]
}
