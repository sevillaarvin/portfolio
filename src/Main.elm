module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, h2, li, p, span, text, ul)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Decode exposing (Decoder, Value, fail, field, float, list, maybe, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Model =
    { resume : Resume }


type alias Resume =
    { name : String
    , phone : String
    , email : String
    , website : String
    , experiences : List Experience
    , skills : List Skill
    , projects : List Project
    , education : List Education
    , awards : List Award
    }


type alias Experience =
    { company : String
    , position : String
    , location : String
    , start : String
    , end : String
    , highlights : List String
    }


type alias Skill =
    { name : String
    , keywords : List String
    }


type alias Project =
    { name : String
    , description : String
    , keywords : List String
    , url : String
    }


type alias Education =
    { institution : String
    , location : String
    , studyType : String
    , area : String
    , gpa : Maybe Float
    , start : String
    , end : String
    }


type alias Award =
    { title : String
    , summary : String
    , awarder : String
    , date : String
    }


resumeDecoder : Decoder Resume
resumeDecoder =
    Decode.succeed Resume
        |> required "basics" (field "name" string)
        |> required "basics" (field "phone" string)
        |> required "basics" (field "email" string)
        |> required "basics" (field "website" string)
        |> required "work" (list experienceDecoder)
        |> required "skills" (list skillDecoder)
        |> required "projects" (list projectDecoder)
        |> required "education" (list educationDecoder)
        |> required "awards" (list awardDecoder)


experienceDecoder : Decoder Experience
experienceDecoder =
    Decode.succeed Experience
        |> required "company" string
        |> required "position" string
        |> required "location" string
        |> required "startDate" string
        |> required "endDate" string
        |> required "highlights" (list string)


skillDecoder : Decoder Skill
skillDecoder =
    Decode.succeed Skill
        |> required "name" string
        |> required "keywords" (list string)


projectDecoder : Decoder Project
projectDecoder =
    Decode.succeed Project
        |> required "name" string
        |> required "description" string
        |> required "keywords" (list string)
        |> optional "url" string ""


educationDecoder : Decoder Education
educationDecoder =
    Decode.succeed Education
        |> required "institution" string
        |> required "location" string
        |> required "studyType" string
        |> required "area" string
        |> required "gpa" (Decode.map String.toFloat string)
        |> required "startDate" string
        |> required "endDate" string


awardDecoder : Decoder Award
awardDecoder =
    Decode.succeed Award
        |> required "title" string
        |> required "summary" string
        |> required "awarder" string
        |> required "date" string


type Msg
    = GotResume (Result Http.Error Resume)


initResume : Resume
initResume =
    { name = ""
    , phone = ""
    , email = ""
    , website = ""
    , experiences = []
    , skills = []
    , projects = []
    , education = []
    , awards = []
    }


init : Value -> ( Model, Cmd Msg )
init flags =
    ( { resume = initResume }, Http.get { url = "/assets/resume.json", expect = Http.expectJson GotResume resumeDecoder } )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotResume result ->
            case result of
                Ok resume ->
                    ( { model | resume = resume }, Cmd.none )

                Err err ->
                    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        resume =
            model.resume
    in
    div [ class "resume__sheet" ]
        [ div [ class "resume__name" ] [ h1 [] [ text resume.name ] ]
        , div [ class "resume__contact" ]
            [ div []
                [ p [] [ text resume.phone ]
                , p [] [ text resume.email ]
                , p [] [ text resume.website ]
                ]
            ]
        , div [ class "resume__experience" ] (h2 [] [ text "Experience" ] :: List.map experienceView resume.experiences)
        , div [ class "resume__skill" ] (h2 [] [ text "Skills" ] :: List.map skillView resume.skills)
        , div [ class "resume__project" ] (h2 [] [ text "Projects" ] :: List.map projectView resume.projects)
        , div [ class "resume__education" ] (h2 [] [ text "Education" ] :: List.map educationView resume.education)
        , div [ class "resume__award" ] (h2 [] [ text "Awards" ] :: List.map awardView resume.awards)
        ]


experienceView : Experience -> Html msg
experienceView experience =
    div []
        [ p [] [ text experience.company ]
        , p [] [ text experience.position ]
        , p [] [ text experience.location ]
        , p [] [ text (experience.start ++ " - " ++ experience.end) ]
        , ul [] (List.map (\highlight -> li [] [ text highlight ]) experience.highlights)
        ]


skillView : Skill -> Html msg
skillView skill =
    div []
        [ p [] [ text skill.name ]
        , ul [] (List.map (\keyword -> li [] [ text keyword ]) skill.keywords)
        ]


projectView : Project -> Html msg
projectView project =
    div []
        [ p [] [ text project.name ]
        , p [] [ text project.description ]
        , ul [] (List.map (\keyword -> li [] [ text keyword ]) project.keywords)
        , p [] [ text project.url ]
        ]


educationView : Education -> Html msg
educationView education =
    let
        gpa =
            case education.gpa of
                Just f ->
                    f

                Nothing ->
                    0
    in
    div []
        [ p [] [ text education.institution ]
        , p [] [ text education.location ]
        , p [] [ text education.studyType ]
        , p [] [ text education.area ]
        , p [] [ text (String.fromFloat gpa) ]
        , p [] [ text (education.start ++ " - " ++ education.end) ]
        ]


awardView : Award -> Html msg
awardView award =
    div []
        [ p [] [ text award.title ]
        , p [] [ text award.summary ]
        , p [] [ text award.awarder ]
        , p [] [ text award.date ]
        ]
