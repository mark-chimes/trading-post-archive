module View exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


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
            (case state.woodExpanded of
                Expanded ->
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

                Collapsed ->
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


root : GameState -> Html Msg
root state =
    div [ class "content" ]
        [ gameHeader "Trading Post!"
        , subheader "Shop"
        , viewShop state
        , subheader "Customers"
        , viewCustomers state
        ]
