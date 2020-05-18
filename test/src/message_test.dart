import 'package:omega_irc/src/message.dart';
import 'package:test/test.dart';

void main() {
  group('Message Tests:', () {
    test('Parses IRC response message', () {
      var sampleMsg =
          '@aaa=bbb;ccc;example.com/ddd=eee :nick!ident@host.com PRIVMSG me :Hello';
      var msg = Message(sampleMsg);
      expect(msg.rawText, equals(sampleMsg));
    });
    test('Creates a message from String of input', () {
      var msg = Message.fromString('Test message');
      expect(msg.rawText, equals('Test message'));
    });
    test('Hostmask is parsed', () {
      var sampleMsg =
          '@aaa=bbb;ccc;example.com/ddd=eee :nick!ident@host.com PRIVMSG me :Hello';
      var msg = Message(sampleMsg);
      expect(msg.hostmask, equals('nick!ident@host.com'));
    });
    test('Command is parsed', () {
      var sampleMsg =
          '@aaa=bbb;ccc;example.com/ddd=eee :nick!ident@host.com PRIVMSG me :Hello';
      var msg = Message(sampleMsg);
      expect(msg.command, equals('PRIVMSG'));
    });
    test('Message text is parsed', () {
      var sampleMsg =
          '@aaa=bbb;ccc;example.com/ddd=eee :nick!ident@host.com PRIVMSG me :Hello';
      var msg = Message(sampleMsg);
      expect(msg.message, equals('Hello'));
    });
    test('Parameters are parsed', () {
      var sampleMsg =
          '@aaa=bbb;ccc;example.com/ddd=eee :nick!ident@host.com PRIVMSG me :Hello';
      var msg = Message(sampleMsg);
      expect(msg.paramsList, equals(['me']));
    });
    test('Tags are parsed', () {
      var sampleMsg =
          '@aaa=bbb;ccc;example.com/ddd=eee :nick!ident@host.com PRIVMSG me :Hello';
      var msg = Message(sampleMsg);
      expect(msg.tagMap,
          equals({'aaa': 'bbb', 'ccc': 'true', 'example.com/ddd': 'eee'}));
    });
  });
}
