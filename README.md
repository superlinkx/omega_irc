A simple IRC Client library compatible with Flutter

## Usage

Creating a simple connection:

```dart
import 'package:omega_irc/client.dart';

void main() async {
  var host = 'localhost';
  var port = 6667;
  var user = 'derpy';

  var ircClient = Connection(host, port, user);
  ircClient.ircMessage.listen((event) {
    print(event);
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/superlinkx/omega_irc/issues
