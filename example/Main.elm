import HtmlDnd exposing (draggable, dropzone, dragState)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)


renderDragState dragState =
  div
    [ style
      [ ("position", "absolute")
      , ("right", "0")
      , ("top", "0")
      , ("padding", "1em")
      , ("background", "#eee")
      ]
    ]
    [ text <| toString dragState ]

view dragState =
  div
    (dropzone "main" 0 0)
    [ div
        (draggable "box" 1)
        [ text "Box" ]
    , renderDragState dragState
    ]

main =
  Signal.map view dragState
