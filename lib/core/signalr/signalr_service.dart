import 'dart:async';

class SignalRService {
  final _eventController = StreamController<String>.broadcast();

  Stream<String> get eventStream => _eventController.stream;

  Future<void> connect(String token, String role) async {
    // SignalR integration pending — add signalr_netcore to pubspec.yaml to enable
  }

  Future<void> disconnect() async {
    if (!_eventController.isClosed) {
      await _eventController.close();
    }
  }
}
