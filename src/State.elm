port module State exposing (init, update)

import Types exposing (..)
import Material
import Material.Layout as Layout
import Array.Hamt as Array


-- MODEL


init : ( Model, Cmd Msg )
init =
    let
        model =
            { mdl = Layout.setTabsWidth 100 Material.model
            , viewState =
                { overviewTabState = OverviewTab
                , overviewTabIndex = 0
                , notesTabState = NotesTab
                , notesTabIndex = 0
                , actionRadioIndex = 0
                , toneRadioIndex = 0
                , itemRadioIndex = 0
                }
            , gameState =
                { itemsInShop = Array.fromList [ dagger, trailMix ]
                , gold = 50
                , actionRadioState = ItemOffer
                , toneRadioState = Cheerful
                , selectedItem = dagger
                }
            }
    in
        ( model, Layout.sub0 Mdl )


nullItem : BuyableItem
nullItem =
    { name = "No item selected", inSentence = "absolutely nothing at all", price = 0 }


dagger : BuyableItem
dagger =
    { name = "Dagger", inSentence = "a dagger", price = 10 }


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
            ItemOffer

        1 ->
            ItemRequest

        2 ->
            Listen

        3 ->
            InformationOffer

        4 ->
            Inquiry

        5 ->
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


updateRadioSelectionGameState : GameState -> RadioType -> Int -> GameState
updateRadioSelectionGameState gameState radioType index =
    case radioType of
        ActionRadioType ->
            { gameState | actionRadioState = updateActionRadioState index }

        ToneRadioType ->
            { gameState | toneRadioState = updateToneRadioState index }

        ItemRadioType ->
            { gameState | selectedItem = Maybe.withDefault nullItem (Array.get index gameState.itemsInShop) }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model

        SelectTab tabType tabIndex ->
            ( { model | viewState = updateTabSelectionState model.viewState tabType tabIndex }, Cmd.none )

        SelectRadio radioType tabIndex ->
            ( { model
                | gameState = updateRadioSelectionGameState model.gameState radioType tabIndex
                , viewState = updateRadioSelectionViewState model.viewState radioType tabIndex
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS
