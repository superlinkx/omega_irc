import 'package:omega_irc/omega_irc.dart';

void main() async {
  var host = 'localhost';
  var port = 6667;
  var user = 'derpy';

  var ircClient = Client(host, port, user);
  ircClient.ircMessage.listen((event) {
    print(event);
  });
}
