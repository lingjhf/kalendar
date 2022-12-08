import 'package:flutter/material.dart';

import 'base_kalendar_date_picker.dart';
import 'extensions.dart';

class KalendarDateRangePicker extends BaseKalendarDatePicker {
  KalendarDateRangePicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.style,
    super.firstDayOfWeek,
    this.currentDateRange,
    this.onChange,
  });

  final DateTimeRange? currentDateRange;

  final ValueChanged<DateTimeRange?>? onChange;

  @override
  State<StatefulWidget> createState() => _KalendarDateRangePickerState();
}

class _KalendarDateRangePickerState
    extends BaseKalendarDatePickerState<KalendarDateRangePicker> {
  DateTimeRange? currentDateRange;
  DateTime? startDate;

  @override
  void initState() {
    super.initState();
    updateCurrentDateRange();
  }

  @override
  void didUpdateWidget(covariant KalendarDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCurrentDateRange();
  }

  void updateCurrentDateRange() {
    if (widget.currentDateRange != null) {
      currentDateRange = DateTimeRange(
        start: DateUtils.dateOnly(widget.currentDateRange!.start),
        end: DateUtils.dateOnly(widget.currentDateRange!.end),
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
    if (date.month != initDate.month) {
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
    if (isStartOrEndDate(date) || date == DateUtils.dateOnly(DateTime.now())) {
      return style.accentColor;
    }
    if (date.month == initDate.month) {
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

  @override
  Widget build(BuildContext context) {
    return datesBuilder(
      context,
      (date) => Container(
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
            child: Text('${date.day}'),
          ))
        ]),
      ),
    );
  }
}
