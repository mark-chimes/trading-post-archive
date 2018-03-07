module Types exposing (..)

import Material.Options as Options
import Material


type alias Mdl =
    Material.Model


type alias Model =
    { mdl : Mdl
    , viewState : ViewState
    , gameState : GameState
    }


type alias ViewState =
    { overviewTabState : OverviewTabState
    , overviewTabIndex : Int
    , notesTabState : NotesTabState
    , notesTabIndex : Int
    , actionRadioState : ActionState
    , actionRadioIndex : Int
    , toneRadioState : ToneState
    , toneRadioIndex : Int
    }


type alias GameState =
    { gold : Int
    , itemsInShop : List BuyableItem
    , selectedItem : BuyableItem
    }


type OverviewTabState
    = OverviewTab
    | DescriptionTab


type NotesTabState
    = NotesTab
    | LogTab
    | TradeTab


type ActionState
    = ItemOffer
    | ItemRequest
    | Listen
    | InformationOffer
    | Inquiry
    | Inform
    | Chatter


type ToneState
    = Cheerful
    | Angry


type Msg
    = Noop
    | Mdl (Material.Msg Msg)
    | SelectTab TabType Int
    | SelectRadio RadioType Int


type TabType
    = OverviewTabType
    | NotesTabType


type RadioType
    = ActionRadioType
    | ToneRadioType


type alias Mop c m =
    Options.Property c m


type alias StringAndCommand =
    { string : String, command : Maybe String }


type alias BuyableItem =
    { name : String, inSentence : String, price : Int }
