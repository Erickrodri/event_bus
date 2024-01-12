import 'dart:async';

class EventBus {
  /// [StreamController] for the event bus stream
  final StreamController<_EventBusEvent> _streamController;

  /// Create a [EventBus]
  EventBus({
    bool sync = false,
  }) : _streamController = StreamController.broadcast(sync: sync);

  /// Register a event listener. The [callback] will be called once the [name]
  /// is add.
  StreamSubscription on(String name, void Function(dynamic) callback) {
    return _streamController.stream
        .where((_EventBusEvent event) => event.name == name)
        .listen((_EventBusEvent event) => callback(event.data));
  }

  /// Add a event, which will notify all the event listeners listening for the
  /// [name]. You can also pass an optional [data]
  void add(String name, [dynamic data]) {
    final event = _EventBusEvent(name: name, data: data);
    _streamController.add(event);
  }

  /// You don't have to destroy it explicity
  void destroy() {
    _streamController.close();
  }
}

class _EventBusEvent {
  final String name;
  final dynamic data;

  _EventBusEvent({
    required this.name,
    required this.data,
  });
}
