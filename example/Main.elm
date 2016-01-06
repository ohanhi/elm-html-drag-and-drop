import HtmlDnd exposing (draggable, dropzone, dragState)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)


renderDragState dragState =
  div
    [ style
      [ ("position", "absolute")
      , ("left", "0")
      , ("bottom", "0")
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
      [ ("display", "flex")
      , ("flex-direction", "row")
      ]
    ])
    [ div
      (dropzone "column1" 0 0
      ++ columnStyles)
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
      ]
    , div
      (dropzone "column2" 0 0
      ++ columnStyles)
      []
    , renderDragState dragState
    ]

main =
  Signal.map view dragState


columnStyles =
  [ style
    [ ("border", "solid #ccc")
    , ("width", "300px")
    , ("height", "400px")
    , ("flex", "1")
    ]
  ]
