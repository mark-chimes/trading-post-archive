module Types exposing (..)

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
