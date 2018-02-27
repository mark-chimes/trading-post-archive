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
                }
            }
    in
        ( model, Layout.sub0 Mdl )



-- UPDATE


updateOverviewTabIndex : Int -> OverviewTabState
updateOverviewTabIndex tabIndex =
    case tabIndex of
        0 ->
            OverviewTab

        _ ->
            DescriptionTab



-- TODO Have error shown


updateNotesTabIndex : Int -> NotesTabState
updateNotesTabIndex tabIndex =
    case tabIndex of
        0 ->
            NotesTab

        1 ->
            LogTab

        _ ->
            TradeTab



-- TODO Show error


updateTabState : ViewState -> TabType -> Int -> ViewState
updateTabState viewState tabType tabIndex =
    case tabType of
        OverviewTabType ->
            { viewState | overviewTabState = updateOverviewTabIndex tabIndex, overviewTabIndex = tabIndex }

        NotesTabType ->
            { viewState | notesTabState = updateNotesTabIndex tabIndex, notesTabIndex = tabIndex }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model

        SelectTab tabType tabIndex ->
            ( { model | viewState = updateTabState model.viewState tabType tabIndex }, Cmd.none )



-- SUBSCRIPTIONS
