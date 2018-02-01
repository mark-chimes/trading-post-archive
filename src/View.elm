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
        [ div [] [ selectableText ("Gold: " ++ (toString state.gold)) ]
        , div [] [ button [ onClick ViewShop ] [ text ("View Shop") ] ]
        , div [] [ button [ onClick (SpeakTo { name = "Steve" }) ] [ text ("Speak to Steve") ] ]
        ]


viewCustomers : GameState -> Html Msg
viewCustomers state =
    div []
        [ div [] [ listOfCustomers state.customers ]
        , div []
            [ (selectableText ("Speaking to " ++ maybeCustomerToString state.speakingTo ++ "."))
            ]
        ]


maybeCustomerToString : Maybe Customer -> String
maybeCustomerToString maybeCustomer =
    case maybeCustomer of
        Nothing ->
            "no-one"

        Just customer ->
            customer.name


listOfCustomers : List Customer -> Html Msg
listOfCustomers lst =
    case lst of
        [] ->
            (div [] [ selectableText "No-one" ])

        _ ->
            (ol []
                (List.map (\customer -> li [] [ selectableText customer.name ]) lst)
            )


root : GameState -> Html Msg
root state =
    div [ class "content" ]
        [ gameHeader "Trading Post!"
        , subheader "Shop"
        , viewShop state
        , subheader "Customers"
        , viewCustomers state
        ]
