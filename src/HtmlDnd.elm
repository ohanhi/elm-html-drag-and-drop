module HtmlDnd (Model, dragState, draggable, dropzone, drops) where

{-| Elm bindings for the HTML5 Drag and Drop API.

# Definition
@docs Model

# Helpers
@docs draggable, dropzone

# Signals
@docs dragState, drops
-}

import Native.HtmlDnd

import Debug
import Signal
import Html exposing (Attribute)
import Html.Attributes exposing (attribute)



-- HELPERS

draggable_ : Attribute
draggable_ =
  attribute "draggable" "true"


dropzone_ : Attribute
dropzone_ =
  attribute "data-dropzone" "true"


{-| Helper for creating the attributes necessary for making
an element draggable.
-}
draggable : String -> Int -> List Attribute
draggable kind id =
  [ draggable_
  , attribute "data-kind" kind
  , attribute "data-id" (toString id)
  ]

{-| Helper for creating the attributes necessary for making
an element a dropzone.
-}
dropzone : String -> Int -> Int -> List Attribute
dropzone kind id slot =
  [ draggable_
  , attribute "data-kind" kind
  , attribute "data-id" (toString id)
  , attribute "data-slot" (toString slot)
  ]


-- MODEL

type alias Dragged =
  { kind : String
  , id : Int
  }

type alias Dropzone =
  { kind : String
  , id : Int
  , slot : Int
  }

{-| Model of the drag state.
-}
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
  , targetId : Int
  , targetSlot : Maybe Int
  }

type Event
  = Start Raw
  | Over Raw
  | Drop Raw


-- UPDATE

update : Event -> Model -> Model
update event model =
  Debug.log "event" event |>
  \event ->
  case event of
    Start raw ->
      let
        dragged =
          { id = raw.targetId
          , kind = raw.targetKind
          }
      in
        { empty | dragged = Just dragged }

    Over raw ->
      let
        over =
          { id = raw.targetId
          , kind = raw.targetKind
          , slot = Maybe.withDefault -1 raw.targetSlot
          }
      in
        { model | to = Just over }

    Drop raw ->
      empty


-- SIGNALS

rawEvents : Signal Event
rawEvents =
  Signal.mergeMany
    [ Signal.map Start Native.HtmlDnd.dragstart
    , Signal.map Over Native.HtmlDnd.dragover
    , Signal.map Drop Native.HtmlDnd.drop
    ]


{-| Whenever a drop event happens, `drops` updates.
-}
drops : Signal ()
drops =
  let
    justDrops event =
      case event of
        Drop _ -> Just ()
        _ -> Nothing
  in
    Signal.filterMap justDrops () rawEvents


{-| The drag state as a signal of `Model`.
-}
dragState : Signal Model
dragState =
  Signal.foldp update empty rawEvents
    |> Signal.dropRepeats
