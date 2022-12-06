import 'package:flutter/material.dart';

import 'enums.dart';

class KalendarWeek extends StatelessWidget {
  const KalendarWeek({
    super.key,
    this.firstDayOfWeek = KalendarWeekDay.sunday,
    this.style = const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  });

  //todo一个星期的开始
  final KalendarWeekDay firstDayOfWeek;

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    var values = KalendarWeekDay.values.toList();
    final index = values.indexOf(firstDayOfWeek);
    final weekDays = [
      ...values.sublist(index).map((e) =>
          '${e.name.substring(0, 1).toUpperCase()}${e.name.substring(1, 3)}'),
      ...values.sublist(0, index).map((e) =>
          '${e.name.substring(0, 1).toUpperCase()}${e.name.substring(1, 3)}')
    ];
    return DefaultTextStyle(
      style: style,
      child: Row(
        children: [
          for (final day in weekDays)
            Container(
              width: 36,
              height: 32,
              alignment: Alignment.center,
              child: Text(day),
            )
        ],
      ),
    );
  }
}
