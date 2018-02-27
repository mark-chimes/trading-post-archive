port module State exposing (init, update)

import Types exposing (..)
import Material
import Material.Layout as Layout


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
                , actionRadioState = ItemOffer
                , actionRadioIndex = 0
                , toneRadioState = Cheerful
                , toneRadioIndex = 0
                }
            }
    in
        ( model, Layout.sub0 Mdl )



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
updateActionRadioState tabIndex =
    case tabIndex of
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
updateToneRadioState tabIndex =
    case tabIndex of
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


updateRadioSelectionState : ViewState -> RadioType -> Int -> ViewState
updateRadioSelectionState viewState radioType tabIndex =
    case radioType of
        ActionRadioType ->
            { viewState | actionRadioState = updateActionRadioState tabIndex, actionRadioIndex = tabIndex }

        ToneRadioType ->
            { viewState | toneRadioState = updateToneRadioState tabIndex, toneRadioIndex = tabIndex }


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
            ( { model | viewState = updateRadioSelectionState model.viewState radioType tabIndex }, Cmd.none )



-- SUBSCRIPTIONS
