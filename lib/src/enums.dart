enum KalendarMode {
  day,
  month,
  year,
}

enum KalendarWeekDays {
  monday(value: DateTime.monday),
  tuesday(value: DateTime.tuesday),
  wednesday(value: DateTime.wednesday),
  thursday(value: DateTime.thursday),
  friday(value: DateTime.friday),
  saturday(value: DateTime.saturday),
  sunday(value: DateTime.sunday);

  const KalendarWeekDays({required this.value});

  final int value;
}
