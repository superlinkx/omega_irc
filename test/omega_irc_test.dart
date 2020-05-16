import 'dart:io';
import 'package:omega_irc/omega_irc.dart';
import 'package:test/test.dart';

void main() {
  group('Client Tests', () {
    var ircClient = IrcClient();
    Socket connection;

    setUp(() async {
      connection = await ircClient.connect('localhost', 80);
    });

    test('Test IP Address Connection', () async {
      await expectLater(connection.remoteAddress.address, equals('::1'));
    });

    test('Test IP Address Connection', () async {
      await expectLater(connection.remoteAddress.address, equals('::1'));
    });
  });
}
