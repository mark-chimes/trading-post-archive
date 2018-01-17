module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Time exposing (Time, second)


-- MODEL


type alias Wood =
    Int


type alias Gold =
    Int


type alias GameState =
    { wood : Wood
    , gold : Gold
    }


init : ( GameState, Cmd Msg )
init =
    let
        state =
            { wood = 5
            , gold = 20
            }
    in
        ( state, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | ChopWood
    | SellWood


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



-- VIEW


selectableText : String -> Html msg
selectableText string =
    span [ tabindex 0 ] [ text string ]


viewHeader : String -> Html Msg
viewHeader title =
    header []
        [ h1 [ tabindex 0 ] [ text title ] ]


viewGame : GameState -> Html Msg
viewGame state =
    div [ id "game" ]
        [ div []
            [ selectableText ("Gold: " ++ (toString state.gold)) ]
        , div []
            [ selectableText ("Wood: " ++ (toString state.wood)) ]
        , div []
            [ button [ onClick ChopWood ] [ text ("Chop Wood (" ++ (toString state.wood) ++ ")") ]
            ]
        , div []
            [ button [ onClick SellWood, disabled (state.wood <= 0) ] [ text ("Sell 1 wood for 5 gold (" ++ (toString state.gold) ++ " gp)") ]
            ]
        ]


view : GameState -> Html Msg
view state =
    div [ class "content" ]
        [ viewHeader "Trading Post!"
        , viewGame state
        ]


subscriptions : GameState -> Sub Msg
subscriptions state =
    Time.every second Tick


main : Program Never GameState Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }
