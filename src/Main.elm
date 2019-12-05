module Main exposing (..)

import Browser
import Html exposing (Html, div, span, text)
import Html.Attributes exposing (class)
import Json.Decode exposing (Value)


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Model =
    { data : String }


type Msg
    = Close


init : Value -> ( Model, Cmd Msg )
init flags =
    ( { data = "data" }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "resume__sheet" ]
        [ div [] [ text "NAME" ]
        , div [] [ text "CONTACT DETAILS" ]
        , div [] [ text "EXPERIENCE" ]
        , div [] [ text "SKILLS" ]
        , div [] [ text "PROJ" ]
        , div [] [ text "EDUC" ]
        , div [] [ text "AWARDS" ]
        ]
