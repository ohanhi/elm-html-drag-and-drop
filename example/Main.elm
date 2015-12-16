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
    (dropzone "main" 0 0
    ++
    [ style
      [ ("background", "#ccc")
      , ("width", "300px")
      , ("height", "400px")
      ]
    ])
    [ div
        (draggable "box" 1
        ++
        [ style
          [ ("background", "#cfc")
          , ("width", "100px")
          , ("height", "100px")
          ]
        ])
        [ text "Drag me" ]
    , renderDragState dragState
    ]

main =
  Signal.map view dragState
