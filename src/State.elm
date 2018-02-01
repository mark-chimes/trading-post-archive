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


subscriptions : GameState -> Sub Msg
subscriptions model =
    Sub.none
