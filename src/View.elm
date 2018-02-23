module View exposing (view)

import Types exposing (..)
import Html exposing (..)
import Material.Layout as Layout
import Material.Scheme exposing (topWithScheme)
import Material.Color as Color
import Material.Typography as Typo
import Material.Options as Options exposing (Style, css)
import Material.Grid exposing (..)
import Material.Elevation as Elevation
import Material.Button as Button
import Material.Tabs as Tabs
import Material.Toggles as Toggles


type alias Mop c m =
    Options.Property c m


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
                ( [ text "Different Customer", text "Current Customer", text "Shop" ]
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
    , css "padding-left" "8px"
    , css "padding-right" "8px"
    , css "padding-top" "16px"
    , css "padding-bottom" "16px"
    , css "color" "white"
    ]


democell : Int -> List (Style a) -> List (Html a) -> Cell a
democell k styling =
    cell <| List.concat [ style k, styling ]


std : List (Style a) -> List (Html a) -> Cell a
std =
    democell 400


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
        [ [ gridBoxWithSizeAndContent 12
                [ Tabs.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Tabs.ripple

                    -- , Tabs.activeTab model.tab
                    ]
                    [ Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Overview"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Appearance"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Notes"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Conversation Log"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Trade Offers"
                        ]
                    ]
                    [{--
                 case model.tab of
                    0 ->
                        aboutTab

                    _ ->
                        exampleTab
                        --}
                    ]
                , Options.styled p
                    [ Typo.subhead
                    , css "padding-top" "12px"
                    ]
                    [ text "Joseph McFinkelstein the Brave" ]
                , Options.styled p
                    [ Typo.body2 ]
                    [ text "That guy who is looking for the magic sword" ]
                , Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.raised
                    ]
                    [ text "Modify Description"
                    ]
                ]
          , gridBoxWithSizeAndContent 12
                [ Options.styled p
                    [ Typo.headline ]
                    [ text "Next line of speech" ]
                , Options.styled p
                    [ Typo.body1 ]
                    [ text "I have a wonderful item for you! The Sword of Notre Dame!" ]
                , Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.raised
                    ]
                    [ text "Speak"
                    ]
                ]
          ]
            |> grid []
        , [ gridBoxWithSizeAndContent 12
                [ Options.styled p
                    [ Typo.headline ]
                    [ text "Speech Action" ]
                , Tabs.render Mdl
                    [ 1 ]
                    model.mdl
                    [ Tabs.ripple

                    -- , Tabs.activeTab model.tab
                    ]
                    [ Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Item Offer"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Item Request"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Listen"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Information Offer"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Inquiry"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Inform"
                        ]
                    , Tabs.label
                        [ Options.center ]
                        [ Options.span [ css "width" "4px" ] []
                        , text "Chatter"
                        ]
                    ]
                    [{--
                 case model.tab of
                    0 ->
                        aboutTab

                    _ ->
                        exampleTab
                        --}
                    ]
                , Options.styled p
                    [ Typo.subhead
                    , css "padding-top" "16px"
                    ]
                    [ text "Offering: Sword of Notre Dame" ]
                , Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.raised
                    , css "padding-bottom" "16px"
                    ]
                    [ text "Select Different Item"
                    ]
                , Options.styled p
                    [ Typo.subhead
                    , css "padding-top" "16px"
                    ]
                    [ text "Tone of Voice" ]
                , Toggles.radio
                    Mdl
                    [ 0 ]
                    model.mdl
                    [ Toggles.value True
                    , Toggles.group "MyRadioGroup"
                    ]
                    [ text "Friendly" ]
                , Toggles.radio Mdl
                    [ 1 ]
                    model.mdl
                    [ Toggles.value False
                    , Toggles.group "MyRadioGroup"
                    ]
                    [ text "Aggressive" ]
                ]
          ]
            |> grid []
        ]
