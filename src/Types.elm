module Types exposing (..)

import Dom


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
    , error : Maybe String
    }


type alias ViewState =
    { shopExpanded : ExpansionState
    , customersExpanded : ExpansionState
    }


type ContentType
    = Shop
    | Customers


type ExpansionState
    = Expand
    | Collapse


type alias ContentId =
    String


type Msg
    = Noop
    | SpeakTo (Maybe Customer)
    | ViewShop
    | Resize ExpansionState ContentType ContentId
    | FocusOn String
    | FocusResult (Result Dom.Error ())
