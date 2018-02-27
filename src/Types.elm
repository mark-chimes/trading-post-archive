module Types exposing (..)

import Material.Options as Options
import Material


type alias Mdl =
    Material.Model


type alias Model =
    { mdl : Mdl
    , viewState : ViewState
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
