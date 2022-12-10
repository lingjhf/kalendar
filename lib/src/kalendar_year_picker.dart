import 'package:flutter/material.dart';

import 'base.dart';
import 'extensions.dart';
import 'kalendar_picker_container.dart';
import 'kalendar_year_picker_container.dart';

abstract class BaseKalendarYearPickerState<T extends BaseKalendarPicker>
    extends BaseKalendarPickerState<T> {
  late DateTimeRange yearRange;

  //default width:63,height:62
  @override
  void updateCellSize() {
    cellSize = Size(style.width / 4, (style.height - style.toolbarHeight) / 4);
    gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      mainAxisExtent: cellSize.height,
    );
  }

  @override
  void updateDatesWithInitDate(DateTime date) {
    super.updateDatesWithInitDate(date);
    var dates = <DateTime>[];
    var n = date.year % 10;
    for (int i = 0; i <= 9 - n; i++) {
      dates.add(date.addYear(i));
    }
    for (int i = 1; i <= n; i++) {
      dates.insert(0, date.subtractYear(i));
    }
    final lastYear = dates.last;
    yearRange = DateTimeRange(start: dates.first, end: lastYear);
    for (int i = 1; i <= 6; i++) {
      dates.add(lastYear.addYear(i));
    }
    this.dates = dates;
  }

  @override
  bool checkDateOutOfBoundaries(DateTime date) {
    if (widget.minDate != null && date.year < widget.minDate!.year) {
      return true;
    }
    if (widget.maxDate != null && date.year > widget.maxDate!.year) {
      return true;
    }
    return false;
  }

  Widget buildContainer(Widget child) {
    return KalendarPickerContainer(
      width: style.width,
      height: style.height,
      style: style,
      disable: widget.disable,
      child: KalendarYearPickerContainer(
        initDate: initDate,
        dateRange: yearRange,
        direction: direction,
        style: style,
        onPrevYear: onInitDateChange,
        onNextYear: onInitDateChange,
        child: SizedBox(key: ValueKey(initDate), child: child),
      ),
    );
  }

  Widget datesBuilder(
      BuildContext context, Widget Function(DateTime date) callback) {
    initStyle(context);
    var rows = <Widget>[];
    var columns = <Widget>[];
    for (int i = 0; i < dates.length; i++) {
      var date = dates[i];
      rows.add(SizedBox(
        width: cellSize.width,
        height: cellSize.height,
        child: Center(
          child: SizedBox(
            width: cellSize.width,
            height: cellSize.height - 10,
            child: callback(date),
          ),
        ),
      ));
      if (i % 4 == 3) {
        columns.add(Row(children: rows));
        rows = [];
      }
    }
    return buildContainer(Column(children: columns));
  }
}

class KalendarYearPicker extends BaseKalendarPicker {
  KalendarYearPicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.style,
    this.currentDate,
    this.onChange,
  });

  final DateTime? currentDate;

  final ValueChanged<DateTime?>? onChange;

  @override
  State<StatefulWidget> createState() => _KalendarYearPickerState();
}

class _KalendarYearPickerState
    extends BaseKalendarYearPickerState<KalendarYearPicker> {
  DateTime? currentDate;

  @override
  void initState() {
    super.initState();
    updateCurrentDate();
  }

  @override
  void didUpdateWidget(covariant KalendarYearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCurrentDate();
  }

  void updateCurrentDate() {
    if (widget.currentDate != null) {
      currentDate = DateUtils.dateOnly(widget.currentDate!);
    }
  }

  bool isCurrentYear(DateTime date) {
    return currentDate?.year == date.year;
  }

  void onSelectYear(DateTime date) {
    if (widget.readonly) return;
    if (checkDateOutOfBoundaries(date)) return;
    if (optionalDateMap.isNotEmpty && !optionalDateMap.containsKey(date)) {
      return;
    }
    currentDate = isCurrentYear(date) ? null : date;
    if (!yearRange.contains(date)) {
      onInitDateChange(date);
    } else {
      setState(() {});
    }
    widget.onChange?.call(currentDate);
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    final isAccent = isCurrentYear(date);
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
    final isAccent = isCurrentYear(date) || date.year == DateTime.now().year;
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
    final isAccent = isCurrentYear(date);
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
        onPressed: () => onSelectYear(date),
        child: Text('${date.year}'),
      ),
    );
  }
}

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
    if (checkDateOutOfBoundaries(date)) return;
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
        onPressed: () => onSelectYear(date),
        child: Text('${date.year}'),
      ),
    );
  }
}
