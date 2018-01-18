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


type alias Customer =
    { name : String
    }


type alias GameState =
    { wood : Wood
    , woodExpanded : Bool
    , gold : Gold
    , customers : List Customer
    }


init : ( GameState, Cmd Msg )
init =
    let
        state =
            { wood = 5
            , woodExpanded = False
            , gold = 20
            , customers = [ { name = "Steve" } ]
            }
    in
        ( state, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | ChopWood
    | SwitchWood
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

        SwitchWood ->
            ( { state | woodExpanded = not state.woodExpanded }, Cmd.none )



-- VIEW


gameHeader : String -> Html Msg
gameHeader title =
    header []
        [ h1 [ tabindex 0 ] [ text title ] ]


subheader : String -> Html Msg
subheader title =
    header []
        [ h2 [ tabindex 0 ] [ text title ] ]


item : String -> Html Msg
item itemName =
    header []
        [ h3 [ tabindex 0 ] [ text itemName ] ]


selectableText : String -> Html msg
selectableText string =
    span [ tabindex 0 ] [ text string ]


viewShop :
    GameState
    -> Html Msg
viewShop state =
    div [ id "game" ]
        [ div []
            [ selectableText ("Gold: " ++ (toString state.gold)) ]
        , div [ class "collapse" ]
            (if state.woodExpanded then
                [ button
                    [ onClick SwitchWood
                    ]
                    [ text ("Wood (expanded)") ]
                , div []
                    [ selectableText ("Quantity: " ++ (toString state.wood))
                    , div []
                        [ selectableText ("Commands (wood): ")
                        , button [ onClick ChopWood ] [ text ("Chop Wood") ]
                        , button
                            [ onClick SellWood
                            , disabled (state.wood <= 0)
                            ]
                            [ text ("Sell 1 wood for 5 gold") ]
                        ]
                    ]
                ]
             else
                [ button [ onClick SwitchWood ] [ text ("Wood: " ++ (toString state.wood)) ]
                ]
            )
        ]


viewCustomers : GameState -> Html Msg
viewCustomers state =
    div []
        [ selectableText
            (Maybe.withDefault "No customers" <| List.head <| List.map (\customer -> customer.name) state.customers)
        ]


view : GameState -> Html Msg
view state =
    div [ class "content" ]
        [ gameHeader "Trading Post!"
        , subheader "Shop"
        , viewShop state
        , subheader "Customers"
        , viewCustomers state
        ]


subscriptions : GameState -> Sub Msg
subscriptions state =
    Time.every second Tick


main : Program Never GameState Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }
