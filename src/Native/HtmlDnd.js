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
    if (event.target.dataset && event.target.dataset.kind && event.target.dataset.id) {
      return Maybe.Just({
        event: eventName,
        targetKind: event.target.dataset.kind,
        targetId: event.target.dataset.id
      });
    } else {
      return Maybe.Nothing;
    }
  }

  function eventStream(eventName) {

    var stream = NS.input('HtmlDnd.'+eventName, Maybe.Nothing);

    localRuntime.addListener([stream.id], node, eventName, function stream(event){
      localRuntime.notify(stream.id, handler(eventName, event));
    });

    return stream;
  }


  localRuntime.Native.HtmlDnd.values = {
    dragstart: eventStream('dragstart'),
    dragover: eventStream('dragover'),
    drop: eventStream('drop')
  };

  return localRuntime.Native.HtmlDnd.values;

};