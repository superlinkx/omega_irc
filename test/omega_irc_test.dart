import 'dart:io';
import 'package:omega_irc/client.dart';
import 'package:test/test.dart';

void main() {
  group('Client Tests:', () {
    Connection ircClient;
    Socket connection;

    setUp(() async {
      ircClient = Connection('localhost', 6667, 'user');
      connection = await ircClient.connection;
    });

    test('Test IP Address', () async {
      await expectLater(connection.remoteAddress.address, equals('::1'));
    });

    test('Test Port', () async {
      await expectLater(connection.remotePort, equals(6667));
    });
  });
}
