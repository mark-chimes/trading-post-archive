module Main exposing (..)

import Types exposing (..)
import State exposing (..)
import View exposing (..)
import Html exposing (..)


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }
