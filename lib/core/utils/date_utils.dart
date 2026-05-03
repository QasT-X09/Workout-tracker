class AppDateUtils {
  static const _months = [
    '',
    'янв',
    'фев',
    'мар',
    'апр',
    'май',
    'июн',
    'июл',
    'авг',
    'сен',
    'окт',
    'ноя',
    'дек',
  ];

  static String formatDate(DateTime date) {
    return '${date.day} ${_months[date.month]} ${date.year}';
  }

  static String formatShort(DateTime date) {
    return '${date.day} ${_months[date.month]}';
  }

  static String weekLabel(DateTime date) {
    final monday = _mondayOf(date);
    final sunday = monday.add(const Duration(days: 6));
    return '${formatShort(monday)} – ${formatShort(sunday)}';
  }

  static String weekKey(DateTime date) {
    final monday = _mondayOf(date);
    final m = monday.month.toString().padLeft(2, '0');
    final d = monday.day.toString().padLeft(2, '0');
    return '${monday.year}-$m-$d';
  }

  static DateTime _mondayOf(DateTime date) {
    final diff = date.weekday - DateTime.monday;
    return DateTime(date.year, date.month, date.day - diff);
  }

  static Map<String, List<T>> groupByWeek<T>(
    List<T> items,
    DateTime Function(T) getDate,
  ) {
    final map = <String, List<T>>{};
    for (final item in items) {
      final key = weekKey(getDate(item));
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }
}
