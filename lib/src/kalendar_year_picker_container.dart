import 'package:flutter/material.dart';

import 'extensions.dart';
import 'theme.dart';

class KalendarYearPickerContainer extends StatelessWidget {
  const KalendarYearPickerContainer({
    super.key,
    required this.initDate,
    required this.dateRange,
    required this.style,
    required this.onPrevYear,
    required this.onNextYear,
    this.readonly = false,
    required this.child,
  });

  final DateTime initDate;

  final DateTimeRange dateRange;

  final bool readonly;

  final KalendarStyle style;

  final Widget child;

  final ValueChanged<DateTime> onPrevYear;

  final ValueChanged<DateTime> onNextYear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!readonly)
          SizedBox(
            height: 32,
            child: KalendarYearPickerToolbar(
              dateRange: dateRange,
              style: style,
              onPrevYear: () => onPrevYear(initDate.subtractYear(10)),
              onNextYear: () => onNextYear(initDate.addYear(10)),
            ),
          ),
        Expanded(child: child)
      ],
    );
  }
}

class KalendarYearPickerToolbar extends StatelessWidget {
  const KalendarYearPickerToolbar({
    super.key,
    required this.dateRange,
    required this.style,
    required this.onPrevYear,
    required this.onNextYear,
  });

  final DateTimeRange dateRange;

  final KalendarStyle style;

  final VoidCallback onPrevYear;

  final VoidCallback onNextYear;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      foregroundColor: MaterialStatePropertyAll(style.primaryColor),
      overlayColor: MaterialStatePropertyAll(style.accentBackgroundColor),
    );
    final titleStyle = TextStyle(
      color: style.primaryColor,
      fontWeight: FontWeight.w600,
    );
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
        Text(
          '${dateRange.start.year} - ${dateRange.end.year}',
          style: titleStyle,
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
