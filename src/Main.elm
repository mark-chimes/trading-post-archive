module Main exposing (..)

import Types exposing (..)
import State exposing (..)
import View exposing (..)
import Html exposing (..)


main : Program Never GameState Msg
main =
    Html.program { init = init, view = root, update = update, subscriptions = subscriptions }
