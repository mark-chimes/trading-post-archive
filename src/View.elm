module View exposing (view)

import Types exposing (..)
import Html exposing (..)
import Material.Layout as Layout
import Material.Scheme exposing (topWithScheme)
import Material.Color as Color
import Material.Options exposing (Style, css)
import Material.Grid exposing (..)
import Material.Elevation as Elevation


type alias Mop c m =
    Material.Options.Property c m


headerColors : List (Mop c m)
headerColors =
    [ Color.background <| Color.color Color.Brown Color.S900
    , Color.text <| Color.white
    ]


tabColors : List (Mop c m)
tabColors =
    [ Color.background (Color.color Color.Brown Color.S400)
    , Color.text <| Color.white
    ]


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Color.Brown Color.DeepOrange <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            ]
            { header = [ viewHeader model ]
            , drawer = []
            , tabs =
                ( [ text "Customers", text "Shop" ]
                , tabColors
                )
            , main = [ viewBody model ]
            }


viewHeader : Model -> Html Msg
viewHeader model =
    Layout.row
        headerColors
        [ Layout.title [] [ text "Trading Post" ]
        , Layout.spacer
        , Layout.navigation []
            []
        ]


style : Int -> List (Style a)
style h =
    [ css "text-sizing" "border-box"
    , css "background-color" "#BDBDBD"
    , css "height" (toString h ++ "px")
    , css "padding-left" "8px"
    , css "padding-top" "4px"
    , css "color" "white"
    ]


democell : Int -> List (Style a) -> List (Html a) -> Cell a
democell k styling =
    cell <| List.concat [ style k, styling ]


std : List (Style a) -> List (Html a) -> Cell a
std =
    democell 200


color1 : () -> Mop c m
color1 () =
    Color.background (Color.color Color.Brown Color.S50)


gridBoxElevation : Mop a m
gridBoxElevation =
    Elevation.e6


gridBoxWithSizeAndContent : Int -> List (Html m) -> Cell m
gridBoxWithSizeAndContent boxSize content =
    std [ gridBoxElevation, size All boxSize, color1 (), Color.text Color.black ] content


viewBody : Model -> Html Msg
viewBody model =
    div
        []
        [ [ gridBoxWithSizeAndContent 2 [ text "Test Text" ]
          , gridBoxWithSizeAndContent 4 [ text "Test Text" ]
          , gridBoxWithSizeAndContent 6 [ text "Test Text" ]
          ]
            |> grid []
        , [ gridBoxWithSizeAndContent 6 [ text "Test Text" ]
          , gridBoxWithSizeAndContent 4 [ text "Test Text" ]
          , gridBoxWithSizeAndContent 2 [ text "Test Text" ]
          ]
            |> grid []
        ]
