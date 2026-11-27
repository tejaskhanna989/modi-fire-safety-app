const List<String> _months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Manual date formatting keeps the project free of `intl`.
String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = _months[date.month - 1];
  return '$day $month ${date.year}';
}
