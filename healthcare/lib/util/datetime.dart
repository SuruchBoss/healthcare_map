import 'package:intl/intl.dart';

String formatDateTime(String datetime) {
  final DateFormat originalFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
  final DateFormat targetFormat = DateFormat("dd MMM yyyy HH.mm");
  DateTime dt = originalFormat.parse(datetime);
  return targetFormat.format(dt);
}
