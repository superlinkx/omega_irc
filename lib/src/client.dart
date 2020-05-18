import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'message.dart';

/// IRC Client Wrapper
class OmegaIrcClient {
  Future<Socket> _connection;
  final String _host;
  final int _port;
  final String _user;

  /// Creates a stream the user can consume to get parsed messages
  final StreamController _ircMessageController = StreamController.broadcast();

  /// Takes a host and a port and creates a new session
  OmegaIrcClient(this._host, this._port, this._user) {
    _connection = Socket.connect(_host, _port);
    _connection.then((socket) {
      socket.writeln('USER $_user $_user $_user $_user');
      socket.writeln('NICK $_user');
      socket.listen(_onData);
    });
  }

  /// Handles new data events from the socket
  void _onData(Uint8List data) {
    var lines = String.fromCharCodes(data).split('\r\n');
    lines.forEach((line) {
      /// Make sure the line is cleaned up before creating the Message object
      line = line.trimLeft();
      var msg = Message(line);

      if (msg.command == 'PING') {
        _connection.then((socket) {
          var pong = 'PONG :${msg.message}';
          socket.writeln(pong);
        });
      }

      if (msg.command == '001') {
        _connection.then((socket) {
          socket.writeln('JOIN #derpy');
        });
      }
      _ircMessageController.add(msg.rawText);
    });
  }

  /// Exposes a stream of incoming messages from the server
  Stream get ircMessage => _ircMessageController.stream;

  /// Exposes the future socket representing the IRC connection
  Future<Socket> get connection {
    return _connection;
  }

  /// Exposes the provided host
  String get host {
    return _host;
  }

  /// Exposes the provided port
  int get port {
    return _port;
  }
}
