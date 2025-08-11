import 'package:intl/intl.dart';

/// 시간 포맷 유틸리티
String formatTimestamp(DateTime dt) {
  return DateFormat('MM/dd hh:mm a').format(dt);
}
