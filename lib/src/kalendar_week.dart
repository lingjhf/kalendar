import 'package:flutter/material.dart';

import 'enums.dart';
import 'localization.dart';
import 'theme.dart';

class KalendarWeek extends StatelessWidget {
  const KalendarWeek({
    super.key,
    required this.weekShortLocal,
    required this.style,
    this.firstDayOfWeek = KalendarWeekDays.sunday,
  });

  //todo一个星期的开始
  final KalendarWeekDays firstDayOfWeek;

  final KalendarWeekLocal weekShortLocal;

  final KalendarStyle style;

  @override
  Widget build(BuildContext context) {
    var values = KalendarWeekDays.values.toList();
    final index = values.indexOf(firstDayOfWeek);
    final weekDays = [
      ...values.sublist(index).map((e) => weekShortLocal.getLocalName(e.value)),
      ...values
          .sublist(0, index)
          .map((e) => weekShortLocal.getLocalName(e.value))
    ];
    return DefaultTextStyle(
      style: style.weekTextStyle,
      child: Row(
        children: [
          for (final day in weekDays)
            Container(
              width: 36,
              height: style.weekBarHeight,
              alignment: Alignment.center,
              child: Text(day),
            )
        ],
      ),
    );
  }
}
