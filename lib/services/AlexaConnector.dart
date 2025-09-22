import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class AlexaConnector {
  final channel = WebSocketChannel.connect(
    Uri.parse("ws://0.0.0.0:8080/ws"), // cámbialo a wss:// con SSL
  );

 Future<void> listen(void Function(String) onCommand) async {
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      final intent = data["intent"];
      onCommand(intent);
    });
  }
}
