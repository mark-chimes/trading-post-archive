port module State exposing (init, update, subscriptions)

import Types exposing (..)


-- MODEL


init : ( GameState, Cmd Msg )
init =
    let
        gameState =
            {}
    in
        ( gameState, Cmd.none )



-- UPDATE


update : Msg -> GameState -> ( GameState, Cmd Msg )
update msg gameState =
    case msg of
        Noop ->
            ( gameState, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : GameState -> Sub Msg
subscriptions model =
    Sub.none
