module View exposing (view)

import Types exposing (..)
import Html exposing (..)
import Html.Attributes as Attributes exposing (style, type_)
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
import Array.Hamt as Array


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
          , gridBox 6 <| constructionCell model
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


radioButtons : Mdl -> ViewState -> String -> RadioType -> List String -> List (Html Msg)
radioButtons mdl viewState groupName radioType names =
    List.map2 (radioButton mdl viewState groupName radioType) (List.range 0 (List.length names)) names


radioButton : Mdl -> ViewState -> String -> RadioType -> Int -> String -> Html Msg
radioButton mdl viewState groupName radioType index name =
    Toggles.radio
        Mdl
        [ index ]
        mdl
        [ Toggles.value <| isRadioActive viewState radioType index
        , Toggles.group groupName
        , Options.onToggle (SelectRadio radioType index)
        , css "padding-left" "16px"
        , css "padding-right" "16px"
        , css "padding-bottom" "32px"
        ]
        [ text name ]


isRadioActive : ViewState -> RadioType -> Int -> Bool
isRadioActive viewState radioType index =
    case radioType of
        ActionRadioType ->
            (viewState.actionRadioIndex == index)

        ToneRadioType ->
            (viewState.toneRadioIndex == index)

        ItemRadioType ->
            (viewState.itemRadioIndex == index)

        RequestedItemRadioType ->
            (viewState.requestedItemRadioIndex == index)


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


textField : Model -> Int -> String -> (String -> Msg) -> Html Msg
textField model index label onChangeTextAction =
    Textfield.render Mdl
        [ index ]
        model.mdl
        [ Textfield.label label
        , Textfield.textarea
        , Options.onInput onChangeTextAction
        ]
        []


button : Model -> Int -> String -> Html Msg
button model index label =
    Button.render Mdl
        [ index ]
        model.mdl
        [ Button.raised
        , Button.ripple
        ]
        [ text label
        ]


overviewCell : Model -> List (Html Msg)
overviewCell model =
    [ tabs model 0 model.viewState.overviewTabIndex (SelectTab OverviewTabType) [ "Overview", "Appearance" ] ]
        ++ overviewTabState model.viewState.overviewTabState model


overviewTabState : OverviewTabState -> Model -> List (Html Msg)
overviewTabState overviewTabState =
    case overviewTabState of
        OverviewTab ->
            overviewTab

        DescriptionTab ->
            appearanceTab


overviewTab : Model -> List (Html Msg)
overviewTab model =
    [ cellSubheaderText "Joseph McFinkelstein the Brave"
    , cellBody2Text "That guy who is looking for the magic sword"
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
    ]
        ++ notesTabState model.viewState.notesTabState model


notesTabState : NotesTabState -> Model -> List (Html Msg)
notesTabState notesTabState =
    case notesTabState of
        NotesTab ->
            notesTab

        LogTab ->
            logTab

        TradeTab ->
            tradeTab


notesTab : Model -> List (Html Msg)
notesTab model =
    [ textField model 12 "Notes" (\s -> Noop) ]


logTab : Model -> List (Html Msg)
logTab model =
    [ cellBody2Text "Log" ]


tradeTab : Model -> List (Html Msg)
tradeTab model =
    [ cellBody2Text "Trade" ]


previewCell : Model -> List (Html Msg)
previewCell model =
    [ cellHeaderText "Preview and Speak"
    , cellBody1Text <|
        (case model.gameState.actionRadioState of
            ItemOffer ->
                itemOfferPreview

            ItemRequest ->
                itemRequestPreview

            _ ->
                unimplementedPreview
        )
            model
    , button model 1 "Speak"
    ]


itemOfferPreview : Model -> String
itemOfferPreview model =
    ("I know just what you need; " ++ model.gameState.selectedItem.inSentence ++ "!")


itemRequestPreview : Model -> String
itemRequestPreview model =
    ("Do you perhaps have " ++ model.gameState.requestedItem.inSentence ++ " for sale?")


unimplementedPreview : Model -> String
unimplementedPreview model =
    ("Action not implemented")


actionCell : Model -> List (Html Msg)
actionCell model =
    ([ cellHeaderText "Action"
     , cellSubheaderText "Type of Speech"
     ]
        ++ radioButtons model.mdl
            model.viewState
            "actionRadioButtons"
            ActionRadioType
            [ "Item Offer"
            , "Item Request"
            , "Listen"
            , "Information Offer"
            , "Inquiry"
            , "Inform"
            , "Chatter"
            ]
        ++ [ cellSubheaderText "Tone of Voice" ]
        ++ radioButtons model.mdl
            model.viewState
            "toneRadioButtons"
            ToneRadioType
            [ "Friendly", "Aggressive" ]
    )


constructionCell : Model -> List (Html Msg)
constructionCell model =
    [ cellHeaderText "Construct Sentence" ]
        ++ (case model.gameState.actionRadioState of
                ItemOffer ->
                    offerItemBlock

                ItemRequest ->
                    requestItemBlock

                _ ->
                    unimplementedBlock
           )
            model


offerItemBlock : Model -> List (Html Msg)
offerItemBlock model =
    [ cellSubheaderText ("Item to Offer")
    , renderList <|
        radioButtons model.mdl
            model.viewState
            "itemRadioButtons"
            ItemRadioType
        <|
            List.map .name (Array.toList model.gameState.itemsInShop)
    , button model 2 "View Selected Item Details"
    ]


requestItemBlock : Model -> List (Html Msg)
requestItemBlock model =
    [ cellSubheaderText ("Item to Request")
    , renderList <|
        radioButtons model.mdl
            model.viewState
            "requestedItemRadioButtons"
            RequestedItemRadioType
        <|
            List.map .name (Array.toList model.gameState.requestableItems)
    , button model 3 "View Selected Item Details"
    ]



--    , div [] [ input [ Attributes.placeholder "Price", Attributes.type_ "number" ] [] ]


unimplementedBlock : Model -> List (Html Msg)
unimplementedBlock model =
    [ cellSubheaderText ("Action not yet implemented") ]


renderList : List (Html msg) -> Html msg
renderList lst =
    lst
        |> List.map (\l -> li [] [ l ])
        |> ul [ Attributes.style [ ( "list-style", "none" ), ( "height", "200px" ), ( "overflow-y", "scroll" ) ] ]
