module Types exposing (..)

import Array.Hamt as Array


type alias Model =
    { viewState : ViewState
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
    , requestedItemRadioIndex : Int
    , informationOfferRadioIndex : Int
    , offerGetRadioIndex : Int
    }


type alias GameState =
    { gold : Int
    , goldOfferGetVal : Int
    , offerOrGet : OfferGet
    , itemsInShop : Array.Array BuyableItem
    , actionRadioState : ActionState
    , toneRadioState : ToneState
    , selectedItem : BuyableItem
    , requestableItems : Array.Array BuyableItem
    , requestedItem : BuyableItem
    , informationTopics : Array.Array InformationTopic
    , currentlyOfferedTopic : InformationTopic
    , currentCustomer : Customer
    , dialog : List String
    }


type Msg
    = Noop
    | SelectTab TabType Int
    | SelectRadio RadioType Int
    | Speak String
    | ChangeMoney Int


type OfferGet
    = Offer
    | Get


type OverviewTabState
    = OverviewTab
    | DescriptionTab


type NotesTabState
    = NotesTab
    | LogTab
    | TradeTab


type ActionState
    = MoneyDiscussion
    | ItemOffer
    | ItemRequest
    | Listen
    | InformationOffer
    | Inquiry
    | Inform
    | Chatter


type ToneState
    = Cheerful
    | Angry


type TabType
    = OverviewTabType
    | NotesTabType


type RadioType
    = ActionRadioType
    | ToneRadioType
    | ItemRadioType
    | RequestedItemRadioType
    | InformationOfferRadioType
    | OfferGetRadioType


type alias Customer =
    { name : String, description : String, appearance : String }


type alias BuyableItem =
    { name : String, inSentence : String, price : Int }


type alias InformationTopic =
    { name : String, inSentence : String, price : Int }
