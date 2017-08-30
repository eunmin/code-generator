module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Grid as Grid
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import MD5 exposing (..)


type alias Model =
    { value : String
    , code : String
    }


initModel : Model
initModel =
    { value = ""
    , code = ""
    }


type Msg
    = ChangeValue String


encodeValue : String -> String
encodeValue value =
    if value == "" then
        ""
    else
        MD5.hex value


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeValue value ->
            { model
                | value = value
                , code = encodeValue value
            }


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , h1 [] [ text "md5" ]
        , Grid.row []
            [ Grid.col []
                [ h5 [] [ text "value" ] ]
            , Grid.col []
                [ h5 [] [ text "code" ] ]
            ]
        , Grid.row []
            [ Grid.col []
                [ Input.text
                    [ Input.attrs
                        [ value model.value
                        , onInput ChangeValue
                        ]
                    ]
                ]
            , Grid.col []
                [ Input.text [ Input.attrs [ value model.code ] ] ]
            ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
