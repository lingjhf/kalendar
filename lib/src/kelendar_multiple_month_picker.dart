import 'package:flutter/material.dart';

import 'base.dart';
import 'base_kalendar_month_picker.dart';

class KalendarMultipleMonthPicker extends BaseKalendarPicker {
  KalendarMultipleMonthPicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.style,
    this.currentDates = const [],
    this.onChange,
  });

  final List<DateTime> currentDates;

  final ValueChanged<List<DateTime>>? onChange;
  @override
  State<StatefulWidget> createState() => _KalendarMultipleMonthPickerState();
}

class _KalendarMultipleMonthPickerState
    extends BaseKalendarMonthPickerState<KalendarMultipleMonthPicker> {
  Map<DateTime, bool> currentDates = {};

  void updateCurrentDates() {
    var map = <DateTime, bool>{};
    for (var date in dates) {
      map[DateTime(date.year, date.month)] = true;
    }
    currentDates = map;
  }

  void onSelectMonth(DateTime date) {
    if (widget.readonly) return;
    if (checkDateOutOfBoundaries(date)) return;
    if (optionalDateMap.isNotEmpty && !optionalDateMap.containsKey(date)) {
      return;
    }
    if (currentDates.containsKey(date)) {
      currentDates.remove(date);
    } else {
      currentDates[date] = true;
    }
    if (date.year != initDate.year) {
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
    final isAccent = currentDates.containsKey(date);
    if (DateUtils.isSameMonth(date, DateTime.now())) {
      return style.accentColor;
    }
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
    if (date.year == initDate.year) {
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
        onPressed: () => onSelectMonth(date),
        child: Text('${date.month}'),
      ),
    );
  }
}
