module View exposing (root)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


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


root : GameState -> Html Msg
root state =
    div [ class "content" ]
        [ gameHeader "Trading Post!" ]
