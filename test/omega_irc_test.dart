import 'dart:io';
import 'package:omega_irc/omega_irc.dart';
import 'package:test/test.dart';

void main() {
  group('Client Tests:', () {
    OmegaIrcClient ircClient;
    Socket connection;

    setUp(() async {
      ircClient = OmegaIrcClient('localhost', 6667, 'user');
      connection = await ircClient.connection;
    });

    test('Test IP Address', () async {
      await expectLater(connection.remoteAddress.address, equals('::1'));
      print('Address: ${await connection.remoteAddress.address}');
    });

    test('Test Port', () async {
      await expectLater(connection.remotePort, equals(6667));
      print('Port: ${await connection.remotePort}');
    });
  });
}
