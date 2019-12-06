module Main exposing (..)

import Browser
import Html exposing (Html, a, div, h1, h2, h3, li, p, text, ul)
import Html.Attributes exposing (class, href)
import Http
import Json.Decode as Decode exposing (Decoder, Value, field, list, string, succeed)
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
    succeed Resume
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
    succeed Experience
        |> required "company" string
        |> required "position" string
        |> required "location" string
        |> required "startDate" string
        |> required "endDate" string
        |> required "highlights" (list string)


skillDecoder : Decoder Skill
skillDecoder =
    succeed Skill
        |> required "name" string
        |> required "keywords" (list string)


projectDecoder : Decoder Project
projectDecoder =
    succeed Project
        |> required "name" string
        |> required "description" string
        |> required "keywords" (list string)
        |> optional "url" string ""


educationDecoder : Decoder Education
educationDecoder =
    succeed Education
        |> required "institution" string
        |> required "location" string
        |> required "studyType" string
        |> required "area" string
        |> required "gpa" (Decode.map String.toFloat string)
        |> required "startDate" string
        |> required "endDate" string


awardDecoder : Decoder Award
awardDecoder =
    succeed Award
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
        GotResume (Ok resume) ->
            ( { model | resume = resume }, Cmd.none )

        GotResume (Err err) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        resume =
            model.resume
    in
    div [ class "resume__sheet" ]
        [ div [ class "resume__name" ]
            [ h1 [ class "text-4xl", class "text-center" ] [ text resume.name ]
            ]
        , div [ class "resume__contact" ]
            [ div [ class "text-center" ]
                [ p [] [ text resume.phone ]
                , p []
                    [ a [ href ("mailto:" ++ resume.email) ] [ text resume.email ]
                    ]
                , p []
                    [ a [ href resume.website ]
                        [ text resume.website
                        ]
                    ]
                ]
            ]
        , div [ class "resume__experience" ] (h2 [ class "text-2xl" ] [ text "Experience" ] :: List.map experienceView resume.experiences)
        , div [ class "resume__skill" ] (h2 [ class "text-2xl" ] [ text "Skills" ] :: List.map skillView resume.skills)
        , div [ class "resume__project" ] (h2 [ class "text-2xl" ] [ text "Projects" ] :: List.map projectView resume.projects)
        , div [ class "resume__education" ] (h2 [ class "text-2xl" ] [ text "Education" ] :: List.map educationView resume.education)
        , div [ class "resume__award" ] (h2 [ class "text-2xl" ] [ text "Awards" ] :: List.map awardView resume.awards)
        ]


experienceView : Experience -> Html msg
experienceView experience =
    div [ class "resume__experience-history" ]
        [ h3 [ class "resume__experience-company", class "font-semibold" ] [ text experience.company ]
        , p [ class "resume__experience-position" ] [ text experience.position ]
        , p [ class "resume__experience-location" ] [ text experience.location ]
        , p [ class "resume__experience-date" ] [ text (experience.start ++ " - " ++ experience.end) ]
        , ul [ class "resume__experience-highlights" ] (List.map highlightView experience.highlights)
        ]


highlightView : String -> Html msg
highlightView highlight =
    li [] [ text highlight ]


skillView : Skill -> Html msg
skillView skill =
    div [ class "resume__skill-item" ]
        [ h3 [ class "resume__skill-name", class "font-semibold" ] [ text skill.name ]
        , ul [ class "resume__skill-list" ] (List.map (\keyword -> li [] [ text keyword ]) skill.keywords)
        ]


projectView : Project -> Html msg
projectView project =
    div [ class "resume__project-item" ]
        [ h3 [ class "resume__project-name", class "font-semibold" ] [ text project.name ]
        , p [ class "resume__project-description" ] [ text project.description ]
        , ul [ class "resume__project-keywords" ] (List.map (\keyword -> li [] [ text keyword ]) project.keywords)
        , p [ class "resume__project-url" ] [ text project.url ]
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

        course =
            if education.studyType == "" then
                education.area

            else
                education.studyType ++ " " ++ education.area
    in
    div [ class "resume__education-history" ]
        [ h3 [ class "resume__education-institution", class "font-semibold" ] [ text education.institution ]
        , p [] [ text education.location ]
        , p [] [ text course ]
        , p []
            [ text
                (if gpa == 0 then
                    "-"

                 else
                    String.fromFloat gpa
                )
            ]
        , p [] [ text (education.start ++ " - " ++ education.end) ]
        ]


awardView : Award -> Html msg
awardView award =
    div [ class "resume__award-history" ]
        [ h3 [ class "font-semibold" ] [ text award.title ]
        , p [] [ text award.summary ]
        , p [] [ text award.awarder ]
        , p [] [ text award.date ]
        ]
