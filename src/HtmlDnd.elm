module HtmlDnd where

import Signal

import Native.HtmlDnd


type alias Dragged =
  { kind : String
  , id : String
  }

type alias Dropzone =
  { kind : String
  , id : String
  , slot : Int
  }

type alias Model =
  { dragged : Maybe Dragged
  , from : Maybe Dropzone
  , to : Maybe Dropzone
  }

empty : Model
empty =
  { dragged = Nothing
  , from = Nothing
  , to = Nothing
  }


type alias Raw =
  { event : String
  , targetKind : String
  , targetId: String
  }

type Event
  = Start Raw
  | Over Raw
  | Drop Raw


rawEvents : Signal Event
rawEvents =
  Signal.mergeMany
    [ Signal.map Start Native.HtmlDnd.dragstart
    , Signal.map Over Native.HtmlDnd.dragover
    , Signal.map Drop Native.HtmlDnd.drop
    ]

update : Event -> Model -> Model
update event model =
  case event of
    Start raw ->
      let
        dragged =
          { id = raw.targetId
          , kind = raw.targetKind
          }
      in
        { empty | dragged = dragged }

    Over raw ->
      let
        over =
          { id = raw.targetId
          , kind = raw.targetKind
          , slot = 0 -- TODO
          }
      in
        { model | over = over }

    Drop raw ->
      empty

drops : Signal ()
drops =
  let
    justDrops event =
      case event of
        Drop _ -> Just ()
        _ -> Nothing
  in
    Signal.filterMap justDrops () rawEvents

dragState : Signal Model
dragState =
  Signal.foldp update empty rawEvents
    |> Signal.dropRepeats
