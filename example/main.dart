/// Example Use For This Library
import 'package:omega_irc/client.dart';

void main() async {
  var host = 'localhost';
  var port = 6667;
  var user = 'derpy';
  var nick = 'derpy';

  var ircClient = Connection(host, port, user, nick);
  ircClient.ircMessage.listen((event) {
    print(event);
  });
}
