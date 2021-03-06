module Main where
import Html exposing (Html, Attribute, toElement)
--import Html.Attributes
import Html.Events exposing (on, targetValue)
import Signal exposing (Address)
import StartApp.Simple as StartApp

elmx : Html
elmx = Html.text ""

main =
  StartApp.start { model = empty, view = view, update = update }

main1 = Html.span [Html.Attributes.attribute "class" "error"] [Html.text "Oops!"]

showMessage : String -> Html
showMessage s = Html.span [] [Html.text s]

showError : String -> Html
showError errorClass = Html.span [Html.Attributes.attribute "class" errorClass] [Html.text "Oops!"]


-- MODEL

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }


empty : Model
empty =
  Model "" "" ""


-- UPDATE

type Action
    = Name String
    | Password String
    | PasswordAgain String


update : Action -> Model -> Model
update action model =
  case action of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }


-- VIEW

view : Address Action -> Model -> Html
view address model =
  let
    validationMessage =
      if model.password == model.passwordAgain then
        Html.span [Html.Attributes.attribute "style" "color: green"] [Html.text "Passwords Match!"]
      else
        Html.span [Html.Attributes.attribute "style" "color: red"] [Html.text "Passwords do not match :("]
  in
    Html.div [] [
      field "text" address Name "User Name" model.name
      , field "password" address Password "Password" model.password
      , field "password" address PasswordAgain "Re-enter Password" model.passwordAgain
      , Html.div [Html.Attributes.attribute "style" (fieldNameStyle "300px")] [validationMessage]
    ]

field : String -> Address Action -> (String -> Action) -> String -> String -> Html
field fieldType address toAction name content =
  let
    onInput = on "input" targetValue (\string -> Signal.message address (toAction string))
  in
    Html.div [] [
      Html.div [Html.Attributes.attribute "style" (fieldNameStyle "160px")] [Html.text name]
      , Html.input [Html.Attributes.attribute "type" fieldType, Html.Attributes.attribute "placeholder" name, Html.Attributes.attribute "value" content, onInput] []
    ]


fieldNameStyle : String -> String
fieldNameStyle px =
  "width: " ++ px
  ++ "; padding: 10px"
  ++ "; text-align: right"
  ++ "; display: inline-block"
