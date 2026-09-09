void printLongString(String text) {
  final RegExp pattern =
      RegExp('.{1,2000}'); // RegExp pattern to match up to 800 characters
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
