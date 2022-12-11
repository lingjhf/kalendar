import 'package:flutter/material.dart';

import 'animation.dart';
import 'enums.dart';
import 'extensions.dart';
import 'kalendar_week.dart';
import 'localization.dart';
import 'theme.dart';

class KalendarDatePickerContainer extends StatelessWidget {
  const KalendarDatePickerContainer({
    super.key,
    required this.initDate,
    required this.firstDayOfWeek,
    required this.direction,
    required this.monthLocal,
    required this.weekShortLocal,
    required this.style,
    required this.onMonthPick,
    required this.onYearPick,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onPrevYear,
    required this.onNextYear,
    this.readonly = false,
    required this.child,
  });

  final DateTime initDate;

  final bool readonly;

  final KalendarWeekDays firstDayOfWeek;

  final AxisDirection direction;

  final KalendarMonthLocal monthLocal;

  final KalendarWeekLocal weekShortLocal;

  final KalendarStyle style;

  final Widget child;

  final VoidCallback onMonthPick;

  final VoidCallback onYearPick;

  final ValueChanged<DateTime> onPrevMonth;

  final ValueChanged<DateTime> onNextMonth;

  final ValueChanged<DateTime> onPrevYear;

  final ValueChanged<DateTime> onNextYear;

  void _onPrevMonth() {
    final date = initDate.subtractMonth();
    onPrevMonth(DateTime(date.year, date.month));
  }

  void _onNextMonth() {
    final date = initDate.addMonth();
    onNextMonth(DateTime(date.year, date.month));
  }

  void _onPrevYear() {
    final date = initDate.subtractYear();
    onPrevYear(DateTime(date.year, date.month));
  }

  void _onNextYear() {
    final date = initDate.addYear();
    onNextYear(DateTime(date.year, date.month));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!readonly)
          SizedBox(
            height: style.toolbarHeight,
            child: KalendarDatePickerToolbar(
              date: initDate,
              direction: direction,
              monthLocal: monthLocal,
              style: style,
              onMonthPick: onMonthPick,
              onYearPick: onYearPick,
              onPrevMonth: _onPrevMonth,
              onNextMonth: _onNextMonth,
              onPrevYear: _onPrevYear,
              onNextYear: _onNextYear,
            ),
          ),
        KalendarWeek(
          weekShortLocal: weekShortLocal,
          firstDayOfWeek: firstDayOfWeek,
          style: style.copyWith(
            weekTextStyle: style.weekTextStyle.copyWith(
              color: style.secondaryColor,
            ),
          ),
        ),
        Expanded(
          child: HorizontalAnimation(
            direction: direction,
            child: child,
          ),
        )
      ],
    );
  }
}

class KalendarDatePickerToolbar extends StatelessWidget {
  const KalendarDatePickerToolbar({
    super.key,
    required this.date,
    required this.direction,
    required this.monthLocal,
    required this.style,
    required this.onMonthPick,
    required this.onYearPick,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onPrevYear,
    required this.onNextYear,
  });

  final DateTime date;

  final AxisDirection direction;

  final KalendarMonthLocal monthLocal;

  final KalendarStyle style;

  final VoidCallback onMonthPick;

  final VoidCallback onYearPick;

  final VoidCallback onNextYear;

  final VoidCallback onPrevYear;

  final VoidCallback onNextMonth;

  final VoidCallback onPrevMonth;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(style.primaryColor),
      overlayColor: MaterialStatePropertyAll(style.accentBackgroundColor),
    );

    ButtonStyle titleButtonSytle = buttonStyle.copyWith(
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
    );

    ButtonStyle actionButtonStyle = buttonStyle.copyWith(
      shape: const MaterialStatePropertyAll(CircleBorder()),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
      minimumSize: const MaterialStatePropertyAll(Size(0, 0)),
    );

    return Row(
      children: [
        TextButton(
          style: actionButtonStyle,
          onPressed: onPrevMonth,
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        const SizedBox(width: 4),
        HorizontalAnimation(
          direction: direction,
          child: SizedBox(
            key: ValueKey(date.month),
            width: 80,
            child: TextButton(
              style: titleButtonSytle,
              onPressed: onMonthPick,
              child: Text(monthLocal.getLocalName(date.month)),
            ),
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          style: actionButtonStyle,
          onPressed: onNextMonth,
          child: const Icon(Icons.keyboard_arrow_right),
        ),
        const Spacer(),
        TextButton(
          style: actionButtonStyle,
          onPressed: onPrevYear,
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        const SizedBox(width: 4),
        HorizontalAnimation(
          direction: direction,
          child: SizedBox(
            key: ValueKey(date.year),
            width: 48,
            child: TextButton(
              style: titleButtonSytle,
              onPressed: onYearPick,
              child: Text('${date.year}'),
            ),
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          style: actionButtonStyle,
          onPressed: onNextYear,
          child: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }
}
