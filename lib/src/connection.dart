import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'message.dart';

/// Establishes a new IRC connection and manages it
class Connection {
  Future<Socket> _socket;
  final String _host;
  final int _port;
  final String _user;
  final String _nick;

  /// Creates a stream the user can consume to get parsed messages
  final StreamController _ircMessageController = StreamController.broadcast();

  /// Create a new IRC connection
  ///
  /// * _host is a valid host string or IP address
  /// * _port is a valid integer representing the connection port (Default: 6667)
  /// * _user is the preferred username for the connection
  /// * _nick is the nickname you'd like to use on the server
  Connection(this._host, this._port, this._user, this._nick) {
    _socket = Socket.connect(_host, _port);
    _socket.then((socket) {
      socket.writeln('USER $_user $_user $_user $_user');
      socket.writeln('NICK $_nick');
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
        _socket.then((socket) {
          var pong = 'PONG :${msg.message}';
          socket.writeln(pong);
        });
      }

      if (msg.command == '001') {
        _socket.then((socket) {
          socket.writeln('JOIN #derpy');
        });
      }
      _ircMessageController.add(msg.rawText);
    });
  }

  /// Exposes a stream of incoming messages from the server
  Stream get ircMessage => _ircMessageController.stream;

  /// Exposes the future socket representing the IRC connection
  Future<Socket> get socket => _socket;

  /// Exposes the provided host
  String get host => _host;

  /// Exposes the provided port
  int get port => _port;
}
