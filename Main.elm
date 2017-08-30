module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
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
    , values : List String
    , codes : List String
    }


initModel : Model
initModel =
    { value = ""
    , code = ""
    , values = []
    , codes = []
    }


type Msg
    = ChangeValue String
    | ChangeMultiValue String


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

        ChangeMultiValue valuesStr ->
            let
                values =
                    String.split "\n" valuesStr
            in
            { model
                | values = values
                , codes =
                    List.map
                        (\value ->
                            if value == "" then
                                ""
                            else
                                value ++ "," ++ encodeValue value
                        )
                        values
            }


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , h1 [] [ text "code!" ]
        , Grid.row []
            [ Grid.col []
                [ Form.form []
                    [ Form.group []
                        [ Form.label [] [ text "value" ]
                        , Input.text
                            [ Input.attrs
                                [ value model.value
                                , onInput ChangeValue
                                ]
                            ]
                        , Form.group []
                            [ Form.label [] [ text "" ]
                            , Textarea.textarea
                                [ Textarea.attrs
                                    [ style [ ( "height", "500px" ) ]
                                    , onInput ChangeMultiValue
                                    , value (String.join "\n" model.values)
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            , Grid.col []
                [ Form.form []
                    [ Form.group []
                        [ Form.label [] [ text "code" ]
                        , Input.text
                            [ Input.attrs
                                [ value model.code ]
                            ]
                        , Form.group []
                            [ Form.label [] [ text "" ]
                            , Textarea.textarea
                                [ Textarea.attrs
                                    [ style
                                        [ ( "height", "500px" ) ]
                                    , value (String.join "\n" model.codes)
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
