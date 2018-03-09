port module State exposing (init, update, subscriptions)

import Types exposing (..)
import Array.Hamt as Array


-- MODEL


init : ( Model, Cmd Msg )
init =
    let
        model =
            { viewState =
                { overviewTabState = OverviewTab
                , overviewTabIndex = 0
                , notesTabState = NotesTab
                , notesTabIndex = 0
                , actionRadioIndex = 0
                , toneRadioIndex = 0
                , itemRadioIndex = 0
                , requestedItemRadioIndex = 0
                , informationOfferRadioIndex = 0
                , offerGetRadioIndex = 0
                }
            , gameState =
                { itemsInShop = Array.fromList [ dagger, trailMix ]
                , gold = 50
                , goldOfferGetVal = 1
                , offerOrGet = Offer
                , actionRadioState = MoneyDiscussion
                , toneRadioState = Cheerful
                , selectedItem = dagger
                , requestableItems = Array.fromList [ trailMix, elysiumSword ]
                , requestedItem = trailMix
                , informationTopics = Array.fromList [ georgeTopic, amuletTopic, goblinsTopic ]
                , currentlyOfferedTopic = georgeTopic
                , currentCustomer = joseph
                , dialog = []
                }
            }
    in
        ( model, Cmd.none )


joseph : Customer
joseph =
    { name = "Joseph McFinkelstein the Brave"
    , description = "That guy who is looking for the magic sword"
    , appearance = "A short, stout fellow with a long, golden beard matched by a magnificient moustache. He does not seem to care much for formality. "
    }


nullTopic : InformationTopic
nullTopic =
    { name = "No topic selected", inSentence = "absolutely nothing at all", price = 0 }


georgeTopic : InformationTopic
georgeTopic =
    { name = "George the dragon slayer", inSentence = "George, the fabled dragon slayer", price = 10 }


amuletTopic : InformationTopic
amuletTopic =
    { name = "Amulet of Yendor", inSentence = "the mystical Amulet of Yendor", price = 10 }


goblinsTopic : InformationTopic
goblinsTopic =
    { name = "Goblin Raids", inSentence = "those goblins which have been raiding the nearby villages", price = 10 }


nullItem : BuyableItem
nullItem =
    { name = "No item selected", inSentence = "absolutely nothing at all", price = 0 }


dagger : BuyableItem
dagger =
    { name = "Dagger", inSentence = "a dagger", price = 10 }


elysiumSword : BuyableItem
elysiumSword =
    { name = "Sword of Elysium", inSentence = "the Sword of Elysium", price = 100 }


trailMix : BuyableItem
trailMix =
    { name = "Trail Mix", inSentence = "a packet of trail mix", price = 1 }



-- UPDATE


updateOverviewTabState : Int -> OverviewTabState
updateOverviewTabState tabIndex =
    case tabIndex of
        0 ->
            OverviewTab

        _ ->
            DescriptionTab


updateNotesTabState : Int -> NotesTabState
updateNotesTabState tabIndex =
    case tabIndex of
        0 ->
            NotesTab

        1 ->
            LogTab

        _ ->
            TradeTab


updateActionRadioState : Int -> ActionState
updateActionRadioState index =
    case index of
        0 ->
            MoneyDiscussion

        1 ->
            ItemOffer

        2 ->
            ItemRequest

        3 ->
            Listen

        4 ->
            InformationOffer

        5 ->
            Inquiry

        6 ->
            Inform

        _ ->
            Chatter


updateToneRadioState : Int -> ToneState
updateToneRadioState index =
    case index of
        0 ->
            Cheerful

        _ ->
            Angry


updateTabSelectionState : ViewState -> TabType -> Int -> ViewState
updateTabSelectionState viewState tabType tabIndex =
    case tabType of
        OverviewTabType ->
            { viewState | overviewTabState = updateOverviewTabState tabIndex, overviewTabIndex = tabIndex }

        NotesTabType ->
            { viewState | notesTabState = updateNotesTabState tabIndex, notesTabIndex = tabIndex }


updateRadioSelectionViewState : ViewState -> RadioType -> Int -> ViewState
updateRadioSelectionViewState viewState radioType index =
    case radioType of
        ActionRadioType ->
            { viewState | actionRadioIndex = index }

        ToneRadioType ->
            { viewState | toneRadioIndex = index }

        ItemRadioType ->
            { viewState | itemRadioIndex = index }

        RequestedItemRadioType ->
            { viewState | requestedItemRadioIndex = index }

        InformationOfferRadioType ->
            { viewState | informationOfferRadioIndex = index }

        OfferGetRadioType ->
            { viewState | offerGetRadioIndex = index }


updateRadioSelectionGameState : GameState -> RadioType -> Int -> GameState
updateRadioSelectionGameState gameState radioType index =
    case radioType of
        ActionRadioType ->
            { gameState | actionRadioState = updateActionRadioState index }

        ToneRadioType ->
            { gameState | toneRadioState = updateToneRadioState index }

        ItemRadioType ->
            { gameState | selectedItem = Maybe.withDefault nullItem (Array.get index gameState.itemsInShop) }

        RequestedItemRadioType ->
            { gameState | requestedItem = Maybe.withDefault nullItem (Array.get index gameState.requestableItems) }

        InformationOfferRadioType ->
            { gameState | currentlyOfferedTopic = Maybe.withDefault nullTopic (Array.get index gameState.informationTopics) }

        OfferGetRadioType ->
            { gameState | offerOrGet = updateOfferOrGet index }


appendDialog : GameState -> String -> GameState
appendDialog gameState string =
    { gameState | dialog = string :: gameState.dialog }


changeMoney : GameState -> Int -> GameState
changeMoney gameState int =
    { gameState
        | goldOfferGetVal =
            if int < 10000000 then
                int
            else
                10000000
    }


updateOfferOrGet : Int -> OfferGet
updateOfferOrGet index =
    case index of
        0 ->
            Offer

        _ ->
            Get


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        SelectTab tabType tabIndex ->
            ( { model | viewState = updateTabSelectionState model.viewState tabType tabIndex }, Cmd.none )

        SelectRadio radioType index ->
            ( { model
                | gameState = updateRadioSelectionGameState model.gameState radioType index
                , viewState = updateRadioSelectionViewState model.viewState radioType index
              }
            , Cmd.none
            )

        Speak string ->
            ( { model | gameState = appendDialog model.gameState string }, Cmd.none )

        ChangeMoney int ->
            ( { model | gameState = changeMoney model.gameState int }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []
