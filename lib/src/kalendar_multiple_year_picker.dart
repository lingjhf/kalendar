import 'package:flutter/material.dart';

import 'base.dart';
import 'base_kalendar_year_picker.dart';
import 'extensions.dart';

class KalendarMultipleYearPicker extends BaseKalendarPicker {
  KalendarMultipleYearPicker({
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
  State<StatefulWidget> createState() => _KalendarMultipleYearPickerState();
}

class _KalendarMultipleYearPickerState
    extends BaseKalendarYearPickerState<KalendarMultipleYearPicker> {
  Map<DateTime, bool> currentDates = {};

  @override
  void initState() {
    super.initState();
    updateCurrentDate();
  }

  @override
  void didUpdateWidget(covariant KalendarMultipleYearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCurrentDate();
  }

  void updateCurrentDate() {
    var map = <DateTime, bool>{};
    for (var date in dates) {
      map[DateTime(date.year)] = true;
    }
    currentDates = map;
  }

  void onSelectYear(DateTime date) {
    if (widget.readonly) return;
    if (optionalDateMap.isNotEmpty && !optionalDateMap.containsKey(date)) {
      return;
    }
    if (currentDates.containsKey(date)) {
      currentDates.remove(date);
    } else {
      currentDates[date] = true;
    }
    if (!yearRange.contains(date)) {
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
    if (yearRange.contains(date)) {
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
    initStyle(context);
    return buildContainer(
      context,
      GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 62,
        ),
        children: [
          for (var date in dates)
            TextButton(
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
              onPressed: () => onSelectYear(date),
              child: Text('${date.year}'),
            )
        ],
      ),
    );
  }
}
