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
        [ div [ class "resume__name" ] [ text "NAME" ]
        , div [ class "resume__contact" ] [ text "CONTACT DETAILS" ]
        , div [ class "resume__experience" ] [ text "EXPERIENCE" ]
        , div [ class "resume__skill" ] [ text "SKILLS" ]
        , div [ class "resume__project" ] [ text "PROJ" ]
        , div [ class "resume__education" ] [ text "EDUC" ]
        , div [ class "resume__award" ] [ text "AWARDS" ]
        ]
