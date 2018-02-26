module Types exposing (..)

import Material.Options as Options
import Material


type alias Mdl =
    Material.Model


type alias Model =
    { -- Boilerplate: model store for any and all Mdl components you use.
      mdl : Mdl
    }


type Msg
    = Noop
      -- Boilerplate: Mdl action handler.
    | Mdl (Material.Msg Msg)


type alias Mop c m =
    Options.Property c m
