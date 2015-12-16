Elm.Native = Elm.Native || {};
Elm.Native.HtmlDnd = {};
Elm.Native.HtmlDnd.make = function(localRuntime){

  localRuntime.Native = localRuntime.Native || {};
  localRuntime.Native.HtmlDnd = localRuntime.Native.HtmlDnd || {};

  if (localRuntime.Native.HtmlDnd.values) {
    return localRuntime.Native.HtmlDnd.values;
  }

  var NS = Elm.Native.Signal.make(localRuntime);
  var Maybe = Elm.Maybe.make(localRuntime);

  var node = localRuntime.isFullscreen()
    ? document
    : localRuntime.node;


  function handler(eventName, event) {
    if (event.target.dataset &&
      event.target.dataset.kind &&
      event.target.dataset.id) {

      var obj = {
        'event': eventName,
        'targetKind': event.target.dataset.kind,
        'targetId': Number(event.target.dataset.id),
        'targetSlot': (event.target.dataset.slot ?
                        Maybe.Just(event.target.dataset.slot) :
                        Maybe.Nothing)
      };

      return Maybe.Just(obj);
    } else {
      return Maybe.Nothing;
    }
  }

  function eventStream(node, eventName) {

    var stream = NS.input('HtmlDnd.'+eventName, Maybe.Nothing);

    localRuntime.addListener([stream.id], node, eventName, function streamListener(event){
      localRuntime.notify(stream.id, handler(eventName, event));
    });

    return stream;
  }


  localRuntime.Native.HtmlDnd.values = {
    dragstart: eventStream(node, 'dragstart'),
    dragover: eventStream(node, 'dragover'),
    drop: eventStream(node, 'drop')
  };

  return localRuntime.Native.HtmlDnd.values;

};