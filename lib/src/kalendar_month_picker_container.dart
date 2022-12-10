import 'package:flutter/material.dart';

import 'animation.dart';
import 'extensions.dart';
import 'theme.dart';

class KalendarMonthPickerContainer extends StatelessWidget {
  const KalendarMonthPickerContainer({
    super.key,
    required this.initDate,
    required this.direction,
    required this.style,
    required this.onYearPick,
    required this.onPrevYear,
    required this.onNextYear,
    this.readonly = false,
    required this.child,
  });
  final DateTime initDate;

  final bool readonly;

  final AxisDirection direction;

  final KalendarStyle style;

  final Widget child;

  final VoidCallback onYearPick;

  final ValueChanged<DateTime> onPrevYear;

  final ValueChanged<DateTime> onNextYear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!readonly)
          SizedBox(
            height: style.toolbarHeight,
            child: KalendarMonthPickerToolbar(
              date: initDate,
              direction: direction,
              style: style,
              onYearPick: onYearPick,
              onPrevYear: () =>
                  onPrevYear(DateTime(initDate.subtractYear().year)),
              onNextYear: () => onNextYear(DateTime(initDate.addYear().year)),
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

class KalendarMonthPickerToolbar extends StatelessWidget {
  const KalendarMonthPickerToolbar({
    super.key,
    required this.date,
    required this.direction,
    required this.style,
    required this.onYearPick,
    required this.onPrevYear,
    required this.onNextYear,
  });

  final DateTime date;

  final AxisDirection direction;

  final KalendarStyle style;

  final VoidCallback onYearPick;

  final VoidCallback onPrevYear;

  final VoidCallback onNextYear;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(style.primaryColor),
      overlayColor: MaterialStatePropertyAll(style.accentBackgroundColor),
    );
    final titleButtonStyle = buttonStyle;
    final actionButtonStyle = buttonStyle.copyWith(
      shape: const MaterialStatePropertyAll(CircleBorder()),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
      minimumSize: const MaterialStatePropertyAll(Size(0, 0)),
    );

    return Row(
      children: [
        TextButton(
          style: actionButtonStyle,
          onPressed: onPrevYear,
          child: const Icon(Icons.keyboard_arrow_left),
        ),
        const Spacer(),
        HorizontalAnimation(
          direction: direction,
          child: TextButton(
            key: ValueKey(date.year),
            style: titleButtonStyle,
            onPressed: onYearPick,
            child: Text('${date.year}'),
          ),
        ),
        const Spacer(),
        TextButton(
          style: actionButtonStyle,
          onPressed: onNextYear,
          child: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
    );
  }
}
