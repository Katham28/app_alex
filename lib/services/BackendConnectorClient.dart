import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class BackendConnectorClient {
  late WebSocketChannel channel;

  BackendConnectorClient(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  Stream get stream => channel.stream;

  void sendJson(Map<String, dynamic> data) {
    channel.sink.add(jsonEncode(data));
  }

  void close() {
    try {
      channel.sink.close();
    } catch (_) {}
  }
}
