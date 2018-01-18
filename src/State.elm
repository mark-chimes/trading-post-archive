module State exposing (init, update, subscriptions)

import Types exposing (..)
import Time exposing (Time, second)


-- MODEL


init : ( GameState, Cmd Msg )
init =
    let
        state =
            { wood = 5
            , woodExpanded = Collapsed
            , gold = 20
            , customers = [ { name = "Steve" } ]
            }
    in
        ( state, Cmd.none )



-- UPDATE


update : Msg -> GameState -> ( GameState, Cmd Msg )
update msg state =
    case msg of
        Tick _ ->
            if state.gold > 0 then
                let
                    gold =
                        state.gold - 1
                in
                    ( { state | gold = gold }, Cmd.none )
            else
                ( state, Cmd.none )

        ChopWood ->
            ( { state | wood = state.wood + 1 }, Cmd.none )

        SellWood ->
            if state.wood > 0 then
                ( { state | gold = state.gold + 5, wood = state.wood - 1 }, Cmd.none )
            else
                ( state, Cmd.none )

        SwitchWood ->
            ( { state
                | woodExpanded =
                    case state.woodExpanded of
                        Expanded ->
                            Collapsed

                        Collapsed ->
                            Expanded
              }
            , Cmd.none
            )


subscriptions : GameState -> Sub Msg
subscriptions state =
    Time.every second Tick
