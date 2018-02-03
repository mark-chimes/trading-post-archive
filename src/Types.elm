module Types exposing (..)


type alias Gold =
    Int


type alias Customer =
    { name : String
    }


type alias GameState =
    { gold : Gold
    , customers : List Customer
    , speakingTo : Maybe Customer
    , viewState : ViewState
    }


type alias ViewState =
    { shopExpanded : ExpansionState
    , customersExpanded : ExpansionState
    }


type ContentType
    = Shop
    | Customers


type ExpansionState
    = Expanded
    | Collapsed


type Msg
    = SpeakTo Customer
    | ViewShop
    | Expand ContentType
