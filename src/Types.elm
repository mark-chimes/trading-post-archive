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
    }


type Msg
    = SpeakTo Customer
    | ViewShop
