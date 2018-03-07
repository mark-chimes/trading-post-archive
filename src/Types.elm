module Types exposing (..)

import Material.Options as Options
import Material
import Array.Hamt as Array


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
    , actionRadioIndex : Int
    , toneRadioIndex : Int
    , itemRadioIndex : Int
    }


type alias GameState =
    { gold : Int
    , itemsInShop : Array.Array BuyableItem
    , actionRadioState : ActionState
    , toneRadioState : ToneState
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
    | ItemRadioType


type alias Mop c m =
    Options.Property c m


type alias StringAndCommand =
    { string : String, command : Maybe String }


type alias BuyableItem =
    { name : String, inSentence : String, price : Int }
