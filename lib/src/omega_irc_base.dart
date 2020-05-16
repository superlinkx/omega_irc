import 'dart:async';
import 'dart:io';

/// IRC Client Class
class IrcClient {
  /// Creates a new socket connection
  Future<Socket> connect(host, port) async {
    return await Socket.connect('localhost', 80);
  }
}
