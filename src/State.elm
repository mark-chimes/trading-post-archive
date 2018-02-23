port module State exposing (init, update, subscriptions)

import Types exposing (..)
import Material


-- MODEL


init : ( Model, Cmd Msg )
init =
    let
        model =
            { -- Boilerplate: Always use this initial Mdl model store.
              mdl = Material.model
            }
    in
        ( model, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        -- Boilerplate: Mdl action handler.
        Mdl msg_ ->
            Material.update Mdl msg_ model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
