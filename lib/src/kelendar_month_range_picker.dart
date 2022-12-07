import 'package:flutter/material.dart';

import 'base.dart';
import 'base_kalendar_month_picker.dart';
import 'extensions.dart';

class KalendarMonthRangePicker extends BaseKalendarPicker {
  KalendarMonthRangePicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.style,
    this.currentDateRange,
    this.onChange,
  });

  final DateTimeRange? currentDateRange;

  final ValueChanged<DateTimeRange?>? onChange;

  @override
  State<StatefulWidget> createState() => _KalendarMonthRangePickerState();
}

class _KalendarMonthRangePickerState
    extends BaseKalendarMonthPickerState<KalendarMonthRangePicker> {
  DateTimeRange? currentDateRange;
  DateTime? startDate;

  @override
  void initState() {
    super.initState();
    updateCurrentDateRange();
  }

  @override
  void didUpdateWidget(covariant KalendarMonthRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCurrentDateRange();
  }

  void updateCurrentDateRange() {
    if (widget.currentDateRange != null) {
      currentDateRange = DateTimeRange(
        start: DateTime(
          widget.currentDateRange!.start.year,
          widget.currentDateRange!.start.month,
        ),
        end: DateTime(
          widget.currentDateRange!.start.year,
          widget.currentDateRange!.start.month,
        ),
      );
    }
  }

  bool isStartOrEndDate(DateTime date) {
    if (date == currentDateRange?.start || date == currentDateRange?.end) {
      return true;
    }
    if (date == startDate) {
      return true;
    }

    return false;
  }

  bool isStartAndEndDateEqual(DateTime date) {
    return currentDateRange?.start == currentDateRange?.end &&
        currentDateRange?.end == date;
  }

  void onSelectDate(DateTime date) {
    if (widget.readonly) return;
    if (startDate == null &&
        currentDateRange != null &&
        currentDateRange!.contains(date)) {
      currentDateRange = null;
    } else if (startDate != null) {
      currentDateRange = date.isBefore(startDate!)
          ? DateTimeRange(start: date, end: startDate!)
          : DateTimeRange(start: startDate!, end: date);
      startDate = null;
    } else {
      startDate = date;
    }
    if (date.year != initDate.year) {
      onInitDateChange(date);
    } else {
      setState(() {});
    }
    widget.onChange?.call(currentDateRange);
  }

  BoxDecoration? getDateBoxDecoration(DateTime date) {
    if (currentDateRange == null) return null;
    if (isStartAndEndDateEqual(date)) {
      return null;
    }
    LinearGradient? gradient;
    if (date == currentDateRange!.start) {
      gradient = LinearGradient(
        colors: [Colors.transparent, widget.style!.accentBackgroundColor],
        stops: const [0.5, 0.5],
      );
    }
    if (date == currentDateRange!.end) {
      gradient = LinearGradient(
        colors: [widget.style!.accentBackgroundColor, Colors.transparent],
        stops: const [0.5, 0.5],
      );
    }
    return BoxDecoration(
      color:
          currentDateRange!.between(date) ? style.accentBackgroundColor : null,
      gradient: gradient,
      border:
          const Border(right: BorderSide(width: 0, color: Colors.transparent)),
    );
  }

  BoxDecoration? getStartOrEndDateBoxDecoration(DateTime date) {
    if (currentDateRange == null) return null;
    if (isStartAndEndDateEqual(date)) {
      return null;
    }
    LinearGradient? gradient;
    if (date == currentDateRange!.start) {
      gradient = LinearGradient(
        colors: [widget.style!.accentBackgroundColor, Colors.transparent],
        stops: const [0.5, 0.5],
      );
    }
    if (date == currentDateRange!.end) {
      gradient = LinearGradient(
        colors: [Colors.transparent, widget.style!.accentBackgroundColor],
        stops: const [0.5, 0.5],
      );
    }
    return BoxDecoration(shape: BoxShape.circle, gradient: gradient);
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    if (isStartOrEndDate(date)) {
      return const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
    }
    return const TextStyle(fontWeight: FontWeight.w600);
  }

  Color? getDateForegroundColor(Set<MaterialState> states, DateTime date) {
    if (isStartOrEndDate(date) || DateUtils.isSameMonth(date, DateTime.now())) {
      return style.accentColor;
    }
    if (date.year == initDate.year) {
      return style.primaryColor;
    }
    return style.secondaryColor;
  }

  Color? getDateBackground(Set<MaterialState> states, DateTime date) {
    if (date == startDate || isStartAndEndDateEqual(date)) {
      return style.accentBackgroundColor;
    }
    return null;
  }

  Widget buildCell(DateTime date) {
    return Center(
      child: Container(
        width: 63,
        height: 52,
        decoration: getDateBoxDecoration(date),
        child: Stack(children: [
          Positioned.fill(
            child: Container(
              decoration: getStartOrEndDateBoxDecoration(date),
            ),
          ),
          Positioned.fill(
              child: TextButton(
            style: cellStyle.copyWith(
              textStyle: MaterialStateProperty.resolveWith(
                (states) => getDateTextStyle(states, date),
              ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) => getDateForegroundColor(states, date),
              ),
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => getDateBackground(states, date),
              ),
            ),
            onPressed: () => onSelectDate(date),
            child: Text('${date.month}'),
          ))
        ]),
      ),
    );
  }

  Widget buildDates() {
    for (int i = 0; i < 4; i++) {}
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    initStyle(context);
    return buildContainer(
      context,
      GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 62,
        ),
        children: [
          for (var date in dates) buildCell(date),
        ],
      ),
    );
  }
}
