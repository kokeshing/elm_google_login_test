port module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, p, input)
import Html.Attributes exposing (src, type_, id, value)
import Html.Events exposing (onClick)


---- MODEL ----

type LoginStatus u e
    = NotLogined
    | Checking
    | Logined u
    | Error e

type alias Model =
    { loginStatus : LoginStatus String String }

initialModel : Model
initialModel =
    { loginStatus = Checking }

init : ( Model, Cmd Msg )
init =
    ( initialModel, firebaseAuthStateRequest () )


---- PORTS ----

-- Out ports
port firebaseLoginRequest : () ->Cmd msg
port firebaseAuthStateRequest : () -> Cmd msg
port firebaseLogoutRequest : () -> Cmd msg

-- In ports
port firebaseLogined : (String -> msg) -> Sub msg
port firebaseNotLogined : (String -> msg) -> Sub msg
port firebaseLoginError : (String -> msg) -> Sub msg
port firebaseLogoutSuccess : (String -> msg) -> Sub msg
port firebaseLogoutFault : (String -> msg) -> Sub msg


---- UPDATE ----


type Msg
    = FirebaseLoginRequest
    | FirebaseAuthStateRequest
    | FirebaseLogoutRequest
    | FirebaseLogined String
    | FirebaseNotLogined String
    | FirebaseLoginError String
    | FirebaseLogoutSuccess String
    | FirebaseLogoutFault String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FirebaseLoginRequest ->
            ( { model | loginStatus = Checking }, firebaseLoginRequest () )
        FirebaseAuthStateRequest ->
            ( { model | loginStatus = Checking }, firebaseAuthStateRequest () )
        FirebaseLogoutRequest ->
            ( { model | loginStatus = Checking }, firebaseLogoutRequest () )
        FirebaseLogined user ->
            ( { model | loginStatus = Logined user }, Cmd.none )
        FirebaseNotLogined _ ->
            ( { model | loginStatus = NotLogined }, Cmd.none )
        FirebaseLoginError error ->
            ( { model | loginStatus = Error error }, Cmd.none )
        FirebaseLogoutSuccess _ ->
            ( { model | loginStatus = NotLogined }, Cmd.none )
        FirebaseLogoutFault error ->
            ( { model | loginStatus = Error error }, Cmd.none )


---- VIEW ----


view : Model -> Html Msg
view { loginStatus } =
    case loginStatus of
        NotLogined ->
            input [ type_ "button", onClick FirebaseLoginRequest, value "Login" ] []
        Checking ->
            p [] [ text "please wait..." ]
        Logined user ->
            div []
                [ p [] [ text "Logined" ]
                , p [] [ text user ]
                , input
                    [ type_ "button", onClick FirebaseLogoutRequest, value "Logout" ]
                    []
                ]
        Error error ->
            div []
                [ input
                    [ type_ "button", onClick FirebaseLoginRequest, value "Login" ]
                    []
                , p
                    []
                    [ text error ]
                ]


---- subscriptions ----
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ firebaseLogined FirebaseLogined
        , firebaseNotLogined FirebaseNotLogined
        , firebaseLoginError FirebaseLoginError
        , firebaseLogoutSuccess FirebaseLogoutSuccess
        , firebaseLogoutFault FirebaseLogoutFault
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
