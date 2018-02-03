module State exposing (init, update, subscriptions)

import Types exposing (..)


-- MODEL


init : ( GameState, Cmd Msg )
init =
    let
        state =
            { gold = 5
            , customers = [ { name = "Steve" }, { name = "Charlotte" } ]
            , speakingTo = Nothing
            , viewState = { shopExpanded = Collapsed, customersExpanded = Collapsed }
            }
    in
        ( state, Cmd.none )



-- UPDATE


update : Msg -> GameState -> ( GameState, Cmd Msg )
update msg state =
    case msg of
        SpeakTo customer ->
            ( { state | speakingTo = Just customer }, Cmd.none )

        ViewShop ->
            ( { state | speakingTo = Nothing }, Cmd.none )

        Expand contentType ->
            ( updateExpansionState state contentType, Cmd.none )


updateExpansionState : GameState -> ContentType -> GameState
updateExpansionState state contentType =
    { state | viewState = updateExpansionViewState state.viewState contentType Expanded }


updateExpansionViewState : ViewState -> ContentType -> ExpansionState -> ViewState
updateExpansionViewState viewState contentType expansionState =
    case contentType of
        Shop ->
            { viewState | shopExpanded = expansionState }

        Customers ->
            { viewState | customersExpanded = expansionState }


subscriptions : GameState -> Sub Msg
subscriptions model =
    Sub.none
