module Types exposing (..)

import Time exposing (Time, second)


type alias Wood =
    Int


type alias Gold =
    Int


type alias Customer =
    { name : String
    }


type ExpandedState
    = Expanded
    | Collapsed


type alias GameState =
    { wood : Wood
    , woodExpanded : ExpandedState
    , gold : Gold
    , customers : List Customer
    }


type Msg
    = Tick Time
    | ChopWood
    | SwitchWood
    | SellWood
