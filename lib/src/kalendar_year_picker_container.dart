import 'package:flutter/material.dart';

import 'animation.dart';
import 'extensions.dart';
import 'theme.dart';

class KalendarYearPickerContainer extends StatelessWidget {
  const KalendarYearPickerContainer({
    super.key,
    required this.initDate,
    required this.dateRange,
    required this.direction,
    required this.style,
    required this.onPrevYear,
    required this.onNextYear,
    this.readonly = false,
    required this.child,
  });

  final DateTime initDate;

  final DateTimeRange dateRange;

  final bool readonly;

  final AxisDirection direction;

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
            height: style.toolbarHeight,
            child: KalendarYearPickerToolbar(
              dateRange: dateRange,
              direction: direction,
              style: style,
              onPrevYear: () =>
                  onPrevYear(DateTime(initDate.subtractYear(10).year)),
              onNextYear: () => onNextYear(DateTime(initDate.addYear(10).year)),
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

class KalendarYearPickerToolbar extends StatelessWidget {
  const KalendarYearPickerToolbar({
    super.key,
    required this.dateRange,
    required this.direction,
    required this.style,
    required this.onPrevYear,
    required this.onNextYear,
  });

  final DateTimeRange dateRange;

  final AxisDirection direction;

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
        HorizontalAnimation(
          direction: direction,
          child: Text(
            '${dateRange.start.year} - ${dateRange.end.year}',
            key: ValueKey(dateRange),
            style: titleStyle,
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
