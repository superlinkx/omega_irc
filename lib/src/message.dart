/// Represents an IRC message
/// Heavily inspired by github.com/SpinlockLabs/irc.dart
class Message {
  final String _rawText;
  String _hostmask;
  String _command;
  String _message;
  List<String> _paramsList;
  Map<String, String> _tagMap;

  /// This RegEx can split responses out into their component parts for us\n
  /// Source: https://gist.github.com/DanielOaks/ef8b21a25a4db5899015
  final _splitter = RegExp(
      r'^(?:@([^\r\n ]*) +|())(?::([^\r\n ]+) +|())([^\r\n ]+)(?: +([^:\r\n ]+[^\r\n ]*(?: +[^:\r\n ]+[^\r\n ]*)*)|())?(?: +:([^\r\n]*)| +())?[\r\n]*$');

  /// Main constructor takes in an IRC ASCII string
  Message(this._rawText) {
    _parseMessageComponents();
  }

  /// String constructor takes an input string to start a new object
  Message.fromString(this._rawText);

  /// Parse raw IRC ASCII string into components
  void _parseMessageComponents() {
    List<String> match;
    var parsed = _splitter.firstMatch(_rawText);

    /// If there is no data at this point, we didn't get a valid string
    /// Should throw an error in the future
    if (parsed == null) {
      return;
    }

    match = List<String>.generate(parsed.groupCount, parsed.group);

    var rawTags = match[1];
    var rawParams = match[6];
    _hostmask = match[3];
    _command = match[5];
    _message = match[8];
    _paramsList = rawParams != null ? rawParams.split(' ') : <String>[];
    _tagMap = rawTags != null && rawTags.isNotEmpty
        ? _parseTags(rawTags)
        : <String, String>{};
  }

  /// Parses IRCv3 Tags into a Map
  Map<String, String> _parseTags(String rawTags) {
    var tagMap = <String, String>{};
    var tags = rawTags.split(';');
    tags.forEach((tag) {
      var tagParts;
      if (tag.contains('=')) {
        tagParts = tag.split('=');
        tagMap[tagParts[0]] = tagParts[1];
      } else {
        tagMap[tag] = 'true';
      }
    });
    return tagMap;
  }

  /// The raw text string that created this Message
  String get rawText => _rawText;

  /// The hostmask contained in the Message
  String get hostmask => _hostmask;

  /// The command contained in the Message
  String get command => _command;

  /// The message text in the Message
  String get message => _message;

  /// List of the parameters in the Message
  List<String> get paramsList => _paramsList;

  /// Map of the tags in the Message
  Map<String, String> get tagMap => _tagMap;
}
