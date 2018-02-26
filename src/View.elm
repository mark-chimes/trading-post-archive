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
import Material.Textfield as Textfield


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


style : List (Style a)
style =
    [ css "text-sizing" "border-box"
    , css "background-color" "#BDBDBD"
    , css "padding-top" "16px"
    , css "padding-bottom" "16px"
    , css "color" "white"
    ]


basicCell : List (Style a) -> List (Html a) -> Cell a
basicCell styling =
    cell <| List.concat [ style, styling ]


color1 : Mop c m
color1 =
    Color.background (Color.color Color.Brown Color.S50)


gridBoxElevation : Mop a m
gridBoxElevation =
    Elevation.e6


gridBoxWithSizeAndContent : Int -> List (Html m) -> Cell m
gridBoxWithSizeAndContent boxSize content =
    basicCell [ gridBoxElevation, size All boxSize, color1, Color.text Color.black ] content


radioButton : Model -> String -> Bool -> Int -> String -> Html Msg
radioButton model groupName isToggled index name =
    Toggles.radio
        Mdl
        [ index ]
        model.mdl
        [ Toggles.value isToggled
        , Toggles.group groupName
        , css "padding-left" "16px"
        , css "padding-right" "16px"
        ]
        [ text name ]


radioButtons : Model -> String -> List String -> List (Html Msg)
radioButtons model groupName names =
    [ radioButton model groupName True 0 <| Maybe.withDefault "RADIO-BUTTON-ERROR" <| List.head names ]
        ++ List.map2 (radioButton model groupName False) (List.range 1 <| List.length names - 1) (Maybe.withDefault [] <| List.tail names)


viewBody : Model -> Html Msg
viewBody model =
    div
        []
        [ [ viewGridBox1 model
          , viewGridBox2 model
          , gridBoxWithSizeAndContent 4
                [ Options.styled p
                    [ Typo.headline ]
                    [ text "Preview and Speak" ]
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
          , gridBoxWithSizeAndContent 6
                ([ Options.styled p
                    [ Typo.headline ]
                    [ text "Action" ]
                 , Options.styled p
                    [ Typo.subhead
                    , css "padding-top" "16px"
                    ]
                    [ text "Type of Speech" ]
                 ]
                    ++ radioButtons model
                        "groupName"
                        [ "Item Offer"
                        , "Item Request"
                        , "Listen"
                        , "Information Offer"
                        , "Inquiry"
                        , "Inform"
                        , "Chatter"
                        ]
                    ++ [ Options.styled p
                            [ Typo.subhead
                            , css "padding-top" "32px"
                            ]
                            [ text "Tone of Voice" ]
                       ]
                    ++ radioButtons model "group2Name" [ "Friendly", "Aggressive" ]
                )
          , gridBoxWithSizeAndContent 6
                [ Options.styled p
                    [ Typo.headline ]
                    [ text "Construct Sentence" ]
                , Options.styled
                    p
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
                ]
          ]
            |> grid []
        ]


viewGridBox1 : Model -> Cell Msg
viewGridBox1 model =
    gridBoxWithSizeAndContent 4
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


viewGridBox2 : Model -> Cell Msg
viewGridBox2 model =
    gridBoxWithSizeAndContent 4
        [ Tabs.render Mdl
            [ 1 ]
            model.mdl
            [ Tabs.ripple

            -- , Tabs.activeTab model.tab
            ]
            [ Tabs.label
                [ Options.center ]
                [ Options.span [ css "width" "4px" ] []
                , text "Notes"
                ]
            , Tabs.label
                [ Options.center ]
                [ Options.span [ css "width" "4px" ] []
                , text "Log"
                ]
            , Tabs.label
                [ Options.center ]
                [ Options.span [ css "width" "4px" ] []
                , text "Trade"
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
        , Textfield.render Mdl
            [ 12 ]
            model.mdl
            [ Textfield.label "Notes"
            , Textfield.textarea
            ]
            []
        ]
