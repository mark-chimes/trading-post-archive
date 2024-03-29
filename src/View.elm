module View exposing (view)

import Types exposing (..)
import Html exposing (Html, button, div, text, h1, h2, ul, li, label, input, textarea, span)
import Html.Events exposing (onClick, onInput)
import Html.Attributes as Attributes exposing (attribute, type_, placeholder, checked, tabindex)
import Array.Hamt as Array


view : Model -> Html Msg
view model =
    viewBody model


viewHeader : Model -> Html Msg
viewHeader model =
    text "Trading Post"


viewBody : Model -> Html Msg
viewBody model =
    div
        []
        [ gridBox <| overviewCell model
        , gridBox <| notesCell model
        , gridBox <| actionCell model
        , gridBox <| constructionCell model
        , gridBox <| previewCell model
        ]


gridBox : List (Html Msg) -> Html Msg
gridBox content =
    div [ attribute "class" "gridBox" ] content


cellHeaderText : String -> Html msg
cellHeaderText content =
    div [] [ h1 [ tabindex 0 ] [ text content ] ]


cellSubheaderText : String -> Html msg
cellSubheaderText content =
    div [] [ h2 [ tabindex 0 ] [ text content ] ]


cellBody1Text : String -> Html msg
cellBody1Text content =
    div [ attribute "class" "cellBody1Text" ] [ span [ tabindex 0 ] [ text content ] ]


cellBody2Text : String -> Html msg
cellBody2Text content =
    div [ attribute "class" "cellBody2Text" ] [ span [ tabindex 0 ] [ text content ] ]


radioGroup : ViewState -> String -> RadioType -> List String -> Html Msg
radioGroup viewState groupName radioType names =
    div [ attribute "class" "radioGroup" ] <| radioButtons viewState groupName radioType names


radioButtons : ViewState -> String -> RadioType -> List String -> List (Html Msg)
radioButtons viewState groupName radioType names =
    List.map2 (radioButton viewState groupName radioType) (List.range 0 (List.length names)) names


radioButton : ViewState -> String -> RadioType -> Int -> String -> Html Msg
radioButton viewState groupName radioType index value =
    label [ attribute "class" "radioLabel" ]
        [ input
            [ type_ "radio"
            , Attributes.name groupName
            , onClick (SelectRadio radioType index)
            , checked <|
                isRadioActive viewState radioType index
            ]
            []
        , text value
        ]


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

        InformationOfferRadioType ->
            (viewState.informationOfferRadioIndex == index)

        OfferGetRadioType ->
            (viewState.offerGetRadioIndex == index)


tab : Msg -> String -> Html Msg
tab msg content =
    button [ onClick msg ] [ text content ]


tabs : Model -> Int -> Int -> (Int -> Msg) -> List String -> Html Msg
tabs model index activeTabIndex selectAction strings =
    div [] <| List.map2 tab (List.map selectAction <| List.range 0 <| List.length strings) strings


textField : Model -> Int -> String -> (String -> Msg) -> Html Msg
textField model index label onChangeTextAction =
    textarea [ placeholder label, onInput onChangeTextAction ] []


myButton : Model -> Int -> String -> Msg -> Html Msg
myButton model index label msg =
    button [ onClick msg ] [ text label ]


overviewCell : Model -> List (Html Msg)
overviewCell model =
    [ cellHeaderText "Customer"
    , tabs model 0 model.viewState.overviewTabIndex (SelectTab OverviewTabType) [ "Overview", "Appearance" ]
    ]
        ++ overviewTabState model.viewState.overviewTabState model


overviewTabState : OverviewTabState -> Model -> List (Html Msg)
overviewTabState overviewTabState model =
    case overviewTabState of
        OverviewTab ->
            overviewTab model.gameState

        DescriptionTab ->
            appearanceTab model.gameState


overviewTab : GameState -> List (Html Msg)
overviewTab gameState =
    [ cellSubheaderText gameState.currentCustomer.name
    , cellBody2Text gameState.currentCustomer.description
    ]


appearanceTab : GameState -> List (Html Msg)
appearanceTab gameState =
    [ cellBody2Text gameState.currentCustomer.appearance ]


notesCell : Model -> List (Html Msg)
notesCell model =
    [ cellHeaderText "Review"
    , tabs model
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
    [ cellSubheaderText "Notes"
    , textField model 12 "Notes" (\s -> Noop)
    ]


logTab : Model -> List (Html Msg)
logTab model =
    [ cellSubheaderText "Log"
    , renderList <|
        List.map cellBody2Text model.gameState.dialog
    ]


tradeTab : Model -> List (Html Msg)
tradeTab model =
    [ cellSubheaderText "Trade"
    , cellBody1Text <| displayGoldMessage model.gameState.currentTrade.goldOffered
    ]


displayGoldMessage : Int -> String
displayGoldMessage gold =
    if gold == 0 then
        ""
    else if gold > 0 then
        "Offering: " ++ (toString gold) ++ " gold."
    else
        "Asking: " ++ (toString -gold) ++ " gold."


previewCell : Model -> List (Html Msg)
previewCell model =
    [ cellHeaderText "Preview and Speak"
    , cellBody1Text <| previewString model.gameState
    , myButton model 1 "Speak" <| Speak <| previewString model.gameState
    ]


previewString : GameState -> String
previewString gameState =
    (case gameState.actionRadioState of
        ItemOffer ->
            itemOfferPreview

        ItemRequest ->
            itemRequestPreview

        Listen ->
            listenPreview

        InformationOffer ->
            informationOfferPreview

        MoneyDiscussion ->
            moneyPreview

        _ ->
            unimplementedPreview
    )
        gameState


itemOfferPreview : GameState -> String
itemOfferPreview gameState =
    case gameState.toneRadioState of
        Cheerful ->
            ("I know just what you need; " ++ gameState.selectedItem.inSentence ++ "!")

        Angry ->
            ("Let me tell you something, you incontinent excuse for a derrier-based lard receptacle; you are going to purchase "
                ++ gameState.selectedItem.inSentence
                ++ " and you'll like it!"
            )


itemRequestPreview : GameState -> String
itemRequestPreview gameState =
    case gameState.toneRadioState of
        Cheerful ->
            ("Do you perhaps have " ++ gameState.requestedItem.inSentence ++ " for sale?")

        Angry ->
            ("Listen here, you squalid bag of insalubrious detritus, if you have "
                ++ gameState.requestedItem.inSentence
                ++ " you'd better sell it to me!"
            )


listenPreview : GameState -> String
listenPreview gameState =
    case gameState.toneRadioState of
        Cheerful ->
            ("Please, continue...")

        Angry ->
            ("You feckless, miasmic, gastro-intestinal emission! If you have something to say, then say it to my face!")


informationOfferPreview : GameState -> String
informationOfferPreview gameState =
    case gameState.toneRadioState of
        Cheerful ->
            ("There's something very interesting about " ++ gameState.currentlyOfferedTopic.inSentence ++ " that I think you should know...")

        Angry ->
            ("You glassy-eyed, addlepated ignoramus! If only you knew what I know about " ++ gameState.currentlyOfferedTopic.inSentence ++ "!")


moneyPreview : GameState -> String
moneyPreview gameState =
    case gameState.toneRadioState of
        Cheerful ->
            case gameState.offerOrGet of
                Offer ->
                    ("What do you say I give you " ++ toString gameState.goldOfferGetVal ++ " gold?")

                Get ->
                    ("I'm going to need " ++ toString gameState.goldOfferGetVal ++ " gold, please!")

        Angry ->
            case gameState.offerOrGet of
                Offer ->
                    ("Alright, you rancid morsel of cockroach meat, I'll give you your "
                        ++ toString gameState.goldOfferGetVal
                        ++ " gold! And keep the change!"
                    )

                Get ->
                    ("You flaccid, grotesquely malformed, soft-shelled gastropod! You'll have to give me "
                        ++ toString gameState.goldOfferGetVal
                        ++ " gold!"
                    )


unimplementedPreview : GameState -> String
unimplementedPreview model =
    ("Action not implemented")


actionCell : Model -> List (Html Msg)
actionCell model =
    ([ cellHeaderText "Action"
     , cellSubheaderText "Type of Speech"
     , radioGroup
        model.viewState
        "actionRadioButtons"
        ActionRadioType
        [ "Money Discussion"
        , "Item Offer"
        , "Item Request"
        , "Listen"
        , "Information Offer"
        , "Inquiry"
        , "Inform"
        , "Chatter"
        , "Confirm Trade"
        ]
     , cellSubheaderText "Tone of Voice"
     , radioGroup
        model.viewState
        "toneRadioButtons"
        ToneRadioType
        [ "Friendly", "Aggressive" ]
     ]
    )


constructionCell : Model -> List (Html Msg)
constructionCell model =
    [ cellHeaderText "Construct Sentence" ]
        ++ (case model.gameState.actionRadioState of
                ItemOffer ->
                    offerItemBlock

                ItemRequest ->
                    requestItemBlock

                Listen ->
                    listenBlock

                InformationOffer ->
                    informationOfferBlock

                MoneyDiscussion ->
                    moneyBlock

                _ ->
                    unimplementedBlock
           )
            model


offerItemBlock : Model -> List (Html Msg)
offerItemBlock model =
    [ cellSubheaderText "Item to Offer"
    , renderList <|
        radioButtons
            model.viewState
            "itemRadioButtons"
            ItemRadioType
        <|
            List.map .name (Array.toList model.gameState.itemsInShop)
    , myButton model 2 "View Selected Item Details" Noop
    ]


requestItemBlock : Model -> List (Html Msg)
requestItemBlock model =
    [ cellSubheaderText ("Item to Request")
    , renderList <|
        radioButtons
            model.viewState
            "requestedItemRadioButtons"
            RequestedItemRadioType
        <|
            List.map .name (Array.toList model.gameState.requestableItems)
    , myButton model 3 "View Selected Item Details" Noop
    ]


informationOfferBlock : Model -> List (Html Msg)
informationOfferBlock model =
    [ cellSubheaderText ("Information to offer")
    , renderList <|
        radioButtons
            model.viewState
            "informationOfferRadioButtons"
            InformationOfferRadioType
        <|
            List.map .name (Array.toList model.gameState.informationTopics)
    , myButton model 3 "View Selected Item Details" Noop
    ]


listenBlock : Model -> List (Html Msg)
listenBlock model =
    [ cellSubheaderText ("Listening (no options)") ]


moneyBlock : Model -> List (Html Msg)
moneyBlock model =
    [ cellSubheaderText "Money"
    , cellBody2Text <| "In shop: " ++ toString model.gameState.gold ++ " gold"
    , radioGroup
        model.viewState
        "offerGetRadioButtons"
        OfferGetRadioType
        [ "Offer"
        , "Get"
        ]
    , div []
        [ input
            [ Attributes.placeholder "Gold"
            , Attributes.type_ "number"
            , Attributes.min "1"
            , Attributes.max "10000000"
            , Attributes.value <| toString model.gameState.goldOfferGetVal
            , onInput <| \n -> ChangeMoney <| Result.withDefault 1 <| String.toInt n
            , Attributes.style [ ( "border", "3px solid black" ), ( "margin", "20px 30px 20px 30px" ) ]
            ]
            []
        ]
    ]


unimplementedBlock : Model -> List (Html Msg)
unimplementedBlock model =
    [ cellSubheaderText ("Action not yet implemented") ]


renderList : List (Html Msg) -> Html Msg
renderList lst =
    lst
        |> List.map (\l -> li [] [ l ])
        |> ul
            []
