module View exposing (view)

import Types exposing (..)
import Html exposing (..)
import Material.Layout as Layout
import Material.Scheme exposing (topWithScheme)
import Material.Color as Color
import Material.Typography as Typo
import Material.Options as Options exposing (Style, css)
import Material.Grid as Grid
import Material.Elevation as Elevation
import Material.Button as Button
import Material.Tabs as Tabs
import Material.Toggles as Toggles
import Material.Textfield as Textfield


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


viewBody : Model -> Html Msg
viewBody model =
    div
        []
        [ [ gridBox 4 <| overviewCell model
          , gridBox 4 <| notesCell model
          , gridBox 4 <| previewCell model
          , gridBox 6 <| actionCell model
          , gridBox 6 <| constructCell model
          ]
            |> Grid.grid []
        ]


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


cellBackColor : Mop c m
cellBackColor =
    Color.background (Color.color Color.Brown Color.S50)


cellStyle : List (Style a)
cellStyle =
    [ css "padding-top" "16px"
    , css "padding-bottom" "32px"
    , css "padding-left" "16px"
    , css "padding-right" "16px"
    ]


basicCell : List (Style a) -> List (Html a) -> Grid.Cell a
basicCell styling =
    Grid.cell <| List.concat [ cellStyle, styling ]


gridBoxElevation : Mop a m
gridBoxElevation =
    Elevation.e6


gridBox : Int -> List (Html m) -> Grid.Cell m
gridBox boxSize content =
    basicCell [ gridBoxElevation, Grid.size Grid.All boxSize, cellBackColor, Color.text Color.black ] content


cellHeaderText : String -> Html msg
cellHeaderText content =
    Options.styled p
        [ Typo.headline ]
        [ text content ]


cellSubheaderText : String -> Html msg
cellSubheaderText content =
    Options.styled p
        [ Typo.subhead
        , css "padding-top" "16px"
        ]
        [ text content ]


cellBody1Text : String -> Html msg
cellBody1Text content =
    Options.styled p
        [ Typo.body1 ]
        [ text content ]


cellBody2Text : String -> Html msg
cellBody2Text content =
    Options.styled p
        [ Typo.body2 ]
        [ text content ]


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
        , css "padding-bottom" "32px"
        ]
        [ text name ]


radioButtons : Model -> String -> List String -> List (Html Msg)
radioButtons model groupName names =
    [ radioButton model groupName True 0 <| Maybe.withDefault "RADIO-BUTTON-ERROR" <| List.head names ]
        ++ List.map2 (radioButton model groupName False) (List.range 1 <| List.length names - 1) (Maybe.withDefault [] <| List.tail names)


tab : String -> Tabs.Label msg
tab content =
    Tabs.label
        [ Options.center ]
        [ Options.span [ css "width" "4px" ] []
        , text content
        ]


tabs : Model -> Int -> Int -> (Int -> Msg) -> List String -> Html Msg
tabs model index activeTabIndex selectAction strings =
    Tabs.render Mdl
        [ index ]
        model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab selectAction
        , Tabs.activeTab activeTabIndex
        , css "padding-bottom" "16px"
        ]
        (List.map tab strings)
        []


textField : Model -> Int -> String -> Html Msg
textField model index label =
    Textfield.render Mdl
        [ index ]
        model.mdl
        [ Textfield.label label
        , Textfield.textarea
        ]
        []


button : Model -> Int -> String -> Html Msg
button model index label =
    Button.render Mdl
        [ index ]
        model.mdl
        [ Button.raised
        ]
        [ text label
        ]


overviewCell : Model -> List (Html Msg)
overviewCell model =
    [ tabs model 0 model.viewState.overviewTabIndex (SelectTab OverviewTabType) [ "Overview", "Appearance" ] ]
        ++ (case model.viewState.overviewTabState of
                OverviewTab ->
                    overviewTab model

                DescriptionTab ->
                    appearanceTab model
           )


overviewTab : Model -> List (Html Msg)
overviewTab model =
    [ cellSubheaderText "Joseph McFinkelstein the Brave"
    , cellBody2Text "That guy who is looking for the magic sword"
    , button model 0 "Modify Description"
    ]


appearanceTab : Model -> List (Html Msg)
appearanceTab model =
    [ cellBody2Text "A short, stout fellow with a long, golden beard matched by a magnificient moustache. He does not seem to care much for formality. " ]


notesCell : Model -> List (Html Msg)
notesCell model =
    [ tabs model
        1
        model.viewState.notesTabIndex
        (SelectTab NotesTabType)
        [ "Notes"
        , "Log"
        , "Trade"
        ]
    , textField model 12 "Notes"
    ]


previewCell : Model -> List (Html Msg)
previewCell model =
    [ cellHeaderText "Preview and Speak"
    , cellBody1Text "I have a wonderful item for you! The Sword of Notre Dame!"
    , button model 0 "Speak"
    ]


actionCell : Model -> List (Html Msg)
actionCell model =
    ([ cellHeaderText "Action"
     , cellSubheaderText "Type of Speech"
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
        ++ [ cellSubheaderText "Tone of Voice" ]
        ++ radioButtons model "group2Name" [ "Friendly", "Aggressive" ]
    )


constructCell : Model -> List (Html Msg)
constructCell model =
    [ cellHeaderText "Construct Sentence"
    , cellSubheaderText "Offering: Sword of Notre Dame"
    , button model 0 "Select Different Item"
    ]
