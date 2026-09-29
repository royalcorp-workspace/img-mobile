class EventTimeHelper {
  /// Resolves Indonesian timezones (WIB, WITA, WIT) or UTC offset string to offset hours.
  static int getTimezoneOffsetHours(String? timezone, String? timezoneName) {
    final tz = (timezone ?? '').toLowerCase();
    final tzName = (timezoneName ?? '').toLowerCase();

    if (tz.contains('jakarta') || tzName == 'wib' || tz.contains('+07') || tz.contains('gmt+7') || tz.contains('utc+7')) {
      return 7;
    }
    if (tz.contains('makassar') || tzName == 'wita' || tz.contains('+08') || tz.contains('gmt+8') || tz.contains('utc+8')) {
      return 8;
    }
    if (tz.contains('jayapura') || tzName == 'wit' || tz.contains('+09') || tz.contains('gmt+9') || tz.contains('utc+9')) {
      return 9;
    }

    // Try parsing explicit regex offset like "+07:00", "+07", or "-05:00"
    final match = RegExp(r'([+-])(\d{1,2})(?::?(\d{2}))?').firstMatch(timezone ?? '');
    if (match != null) {
      final sign = match.group(1) == '-' ? -1 : 1;
      final hours = int.parse(match.group(2)!);
      return sign * hours;
    }

    // Default to WIB (Asia/Jakarta = UTC+7) for Indonesia
    return 7;
  }

  /// Parses date string (e.g. "2026-09-28 08:24:59") and its timezone into a UTC DateTime object.
  static DateTime? parseToUtc(String? dateStr, {String? timezone, String? timezoneName}) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    try {
      final cleanStr = dateStr.replaceAll('T', ' ').trim();
      final parts = cleanStr.split(' ');
      if (parts.length < 2) return null;

      final dateParts = parts[0].split('-').map(int.parse).toList();
      final timeParts = parts[1].split(':').map((e) => double.parse(e).toInt()).toList();

      final localDateTime = DateTime.utc(
        dateParts[0],
        dateParts[1],
        dateParts[2],
        timeParts.isNotEmpty ? timeParts[0] : 0,
        timeParts.length > 1 ? timeParts[1] : 0,
        timeParts.length > 2 ? timeParts[2] : 0,
      );

      final offsetHours = getTimezoneOffsetHours(timezone, timezoneName);
      return localDateTime.subtract(Duration(hours: offsetHours));
    } catch (_) {
      return null;
    }
  }

  /// Formats a remaining duration into standard countdown text ('HH : mm : ss' or 'DDd HH : mm : ss').
  static String formatCountdown(Duration duration) {
    if (duration.isNegative || duration == Duration.zero) {
      return "00 : 00 : 00";
    }

    final days = duration.inDays;
    final hours = (duration.inHours % 24).toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    if (days > 0) {
      final totalHours = (duration.inHours).toString().padLeft(2, '0');
      return '$totalHours : $minutes : $seconds';
    }

    return '$hours : $minutes : $seconds';
  }
}
