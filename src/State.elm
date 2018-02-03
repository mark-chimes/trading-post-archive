module State exposing (init, update, subscriptions)

import Types exposing (..)
import Dom
import Task


-- MODEL


init : ( GameState, Cmd Msg )
init =
    let
        gameState =
            { gold = 5
            , customers = [ { name = "Steve" }, { name = "Charlotte" } ]
            , speakingTo = Nothing
            , viewState = { shopExpanded = Collapse, customersExpanded = Collapse }
            , error = Nothing
            }
    in
        ( gameState, Cmd.none )



-- UPDATE


update : Msg -> GameState -> ( GameState, Cmd Msg )
update msg gameState =
    case msg of
        Noop ->
            ( gameState, Cmd.none )

        SpeakTo maybeCustomer ->
            ( { gameState | speakingTo = maybeCustomer }, Cmd.none )

        ViewShop ->
            ( { gameState | speakingTo = Nothing }, Cmd.none )

        Resize expansionState contentType id ->
            ( updateExpansionState gameState expansionState contentType
            , Dom.focus id |> Task.attempt FocusResult
            )

        FocusOn id ->
            ( gameState, Dom.focus id |> Task.attempt FocusResult )

        FocusResult result ->
            -- handle success or failure here
            case result of
                Err (Dom.NotFound id) ->
                    { gameState | error = Just ("Could not find dom id: " ++ id) } ! []

                Ok () ->
                    { gameState | error = Nothing } ! []


updateExpansionState : GameState -> ExpansionState -> ContentType -> GameState
updateExpansionState gameState expansionState contentType =
    { gameState | viewState = updateExpansionViewState gameState.viewState expansionState contentType }


updateExpansionViewState : ViewState -> ExpansionState -> ContentType -> ViewState
updateExpansionViewState viewState expansionState contentType =
    case contentType of
        Shop ->
            { viewState | shopExpanded = expansionState }

        Customers ->
            { viewState | customersExpanded = expansionState }


subscriptions : GameState -> Sub Msg
subscriptions model =
    Sub.none
