import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

/// IRC Client Wrapper
class OmegaIrcClient {
  Future<Socket> _connection;
  final String _host;
  final int _port;
  final String _user;

  /// This RegEx can split responses out into their component parts for us\n
  /// Source: https://gist.github.com/DanielOaks/ef8b21a25a4db5899015
  final _splitter = RegExp(
      r'^(?:@([^\r\n ]*) +|())(?::([^\r\n ]+) +|())([^\r\n ]+)(?: +([^:\r\n ]+[^\r\n ]*(?: +[^:\r\n ]+[^\r\n ]*)*)|())?(?: +:([^\r\n]*)| +())?[\r\n]*$');

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
    var lines = String.fromCharCodes(data).split('\n');
    lines.forEach((line) {
      line = line.trimLeft();
      List<String> match;
      var parsed = _splitter.firstMatch(line);
      if (parsed == null) {
        return;
      }
      match = List<String>.generate(parsed.groupCount + 1, parsed.group);

      var rawTags = match[1];
      var hostmask = match[3];
      var command = match[5];
      var param = match[6];
      var msg = match[8];
      var parameters = param != null ? param.split(' ') : <String>[];

      var message = 'Raw Tags: $rawTags\n' +
          'Host: $hostmask\n' +
          'Command: $command\n' +
          'Parameters: $parameters\n' +
          'Message: $msg\n';

      if (command == 'PING') {
        _connection.then((socket) {
          var pong = 'PONG :$msg';
          socket.writeln(pong);
        });
      }

      if (command == '001') {
        _connection.then((socket) {
          socket.writeln('JOIN #derpy');
        });
      }
      _ircMessageController.add(line);
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
