port module State exposing (init, update)

import Types exposing (..)
import Material
import Material.Layout as Layout


-- MODEL


init : ( Model, Cmd Msg )
init =
    let
        model =
            { -- Boilerplate: Always use this initial Mdl model store.
              mdl = Layout.setTabsWidth 100 Material.model
            }
    in
        ( model, Layout.sub0 Mdl )



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
