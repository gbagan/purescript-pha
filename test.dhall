let conf = ./spago.dhall
in conf // {
  sources = conf.sources # [ "examples/**/*.purs" ],
  backend = "purs-backend-es build",
  dependencies = conf.dependencies
}