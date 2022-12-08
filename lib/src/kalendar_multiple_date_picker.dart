import 'package:flutter/material.dart';

import 'base_kalendar_date_picker.dart';

class KalendarMultipleDatePicker extends BaseKalendarDatePicker {
  KalendarMultipleDatePicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.style,
    super.firstDayOfWeek,
    this.currentDates = const [],
    this.onChange,
  });

  final List<DateTime> currentDates;

  final ValueChanged<List<DateTime>>? onChange;

  @override
  State<StatefulWidget> createState() => _KalendarMultipleDatePickerState();
}

class _KalendarMultipleDatePickerState
    extends BaseKalendarDatePickerState<KalendarMultipleDatePicker> {
  Map<DateTime, bool> currentDates = {};

  @override
  void initState() {
    super.initState();
    updateCurrentDates();
  }

  @override
  void didUpdateWidget(covariant KalendarMultipleDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCurrentDates();
  }

  void updateCurrentDates() {
    var map = <DateTime, bool>{};
    for (var date in dates) {
      map[DateUtils.dateOnly(date)] = true;
    }
    currentDates = map;
  }

  void onSelectDate(DateTime date) {
    if (widget.readonly) return;
    if (optionalDateMap.isNotEmpty && !optionalDateMap.containsKey(date)) {
      return;
    }
    if (currentDates.containsKey(date)) {
      currentDates.remove(date);
    } else {
      currentDates[date] = true;
    }
    if (date.month != initDate.month) {
      onInitDateChange(date);
    } else {
      setState(() {});
    }
    widget.onChange?.call(currentDates.keys.toList());
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    final isAccent = currentDates.containsKey(date);
    if (optionalDateMap.isNotEmpty) {
      if (isAccent && optionalDateMap.containsKey(date)) {
        return const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        );
      }
      return const TextStyle(fontWeight: FontWeight.w600);
    }
    if (isAccent) {
      return const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
    }
    return const TextStyle(fontWeight: FontWeight.w600);
  }

  Color? getDateForegroundColor(Set<MaterialState> states, DateTime date) {
    final isAccent = currentDates.containsKey(date) ||
        date == DateUtils.dateOnly(DateTime.now());
    if (optionalDateMap.isNotEmpty) {
      if (optionalDateMap.containsKey(date)) {
        if (isAccent) return style.accentColor;
        return style.primaryColor;
      }
      return style.secondaryColor;
    }
    if (isAccent) {
      return style.accentColor;
    }
    if (date.month == initDate.month) {
      return style.primaryColor;
    }
    return style.secondaryColor;
  }

  Color? getDateBackground(Set<MaterialState> states, DateTime date) {
    final isAccent = currentDates.containsKey(date);
    if (optionalDateMap.isNotEmpty) {
      if (isAccent && optionalDateMap.containsKey(date)) {
        return style.accentBackgroundColor;
      }
      return null;
    }
    if (isAccent) {
      return style.accentBackgroundColor;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return datesBuilder(
      context,
      (date) => TextButton(
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
          overlayColor: MaterialStateProperty.resolveWith(
            (states) => getDateOverlayColor(states, date),
          ),
        ),
        onPressed: () => onSelectDate(date),
        child: Text('${date.day}'),
      ),
    );
  }
}
