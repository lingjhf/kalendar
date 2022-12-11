import 'package:flutter/material.dart';

import 'animation.dart';
import 'base.dart';
import 'enums.dart';
import 'extensions.dart';
import 'kalendar_month_picker_container.dart';
import 'kalendar_picker_container.dart';
import 'kalendar_year_picker.dart';
import 'range_painter.dart';

abstract class BaseKalendarMonthPickerState<T extends BaseKalendarPicker>
    extends BaseKalendarPickerState<T> {
  KalendarMode mode = KalendarMode.day;

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
    for (int i = 1; i <= 12; i++) {
      dates.add(DateTime(initDate.year, i));
    }
    for (int i = 1; i <= 4; i++) {
      dates.add(DateTime(initDate.year + 1, i));
    }
    this.dates = dates;
  }

  @override
  void updateOptionalDateMap() {
    var map = <DateTime, bool>{};
    for (var date in widget.optionalDates) {
      map[DateTime(date.year, date.month)] = true;
    }
    optionalDateMap = map;
  }

  @override
  bool checkDateOutOfBoundaries(DateTime date) {
    if (widget.minDate != null &&
        DateTime(date.year, date.month)
            .isBefore(DateTime(widget.minDate!.year, widget.minDate!.month))) {
      return true;
    }
    if (widget.maxDate != null &&
        DateTime(date.year, date.month)
            .isAfter(DateTime(widget.maxDate!.year, widget.maxDate!.month))) {
      return true;
    }
    return false;
  }

  void onYearPick() {
    setState(() {
      mode = KalendarMode.year;
    });
  }

  void onYearPickerChange(DateTime? date) {
    setState(() {
      updateDatesWithInitDate(date!);
      mode = KalendarMode.day;
    });
  }

  Widget buildContainer(Widget child) {
    late Widget container;
    switch (mode) {
      case KalendarMode.year:
        container = KalendarYearPicker(
          initDate: initDate,
          minDate: widget.minDate,
          maxDate: widget.maxDate,
          optionalDates: widget.optionalDates,
          style: widget.style,
          onChange: onYearPickerChange,
        );

        break;

      default:
        container = KalendarPickerContainer(
          width: style.width,
          height: style.height,
          style: style,
          disable: widget.disable,
          child: KalendarMonthPickerContainer(
            direction: direction,
            initDate: initDate,
            style: style,
            onYearPick: onYearPick,
            onPrevYear: onInitDateChange,
            onNextYear: onInitDateChange,
            child: SizedBox(key: ValueKey(initDate), child: child),
          ),
        );
        break;
    }

    return VisibilityAnimation(child: container);
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

class KalendarMonthPicker extends BaseKalendarPicker {
  KalendarMonthPicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.monthShortLocal,
    super.style,
    this.currentDate,
    this.onChange,
  });

  final DateTime? currentDate;

  final ValueChanged<DateTime?>? onChange;

  @override
  State<StatefulWidget> createState() => _KalendarMonthPickerState();
}

class _KalendarMonthPickerState
    extends BaseKalendarMonthPickerState<KalendarMonthPicker> {
  DateTime? currentDate;

  @override
  void initState() {
    super.initState();
    updateCurrentDate();
  }

  @override
  void didUpdateWidget(covariant KalendarMonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCurrentDate();
  }

  void updateCurrentDate() {
    if (widget.currentDate != null) {
      currentDate = DateUtils.dateOnly(widget.currentDate!);
    }
  }

  bool isCurrentMonth(DateTime date) {
    return DateUtils.isSameMonth(currentDate, date);
  }

  //点击选择日期
  void onSelectMonth(DateTime date) {
    if (widget.readonly) return;
    if (checkDateOutOfBoundaries(date)) return;
    if (optionalDateMap.isNotEmpty && !optionalDateMap.containsKey(date)) {
      return;
    }
    currentDate = isCurrentMonth(date) ? null : date;
    if (date.year != initDate.year) {
      onInitDateChange(date);
    } else {
      setState(() {});
    }
    widget.onChange?.call(currentDate);
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    final isAccent = isCurrentMonth(date);
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
    final isAccent = isCurrentMonth(date);
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
    final isAccent = isCurrentMonth(date);
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
        child: Text(widget.monthShortLocal.getLocalName(date.month)),
      ),
    );
  }
}

class KalendarMultipleMonthPicker extends BaseKalendarPicker {
  KalendarMultipleMonthPicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.monthShortLocal,
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
        child: Text(widget.monthShortLocal.getLocalName(date.month)),
      ),
    );
  }
}

class KalendarMonthRangePicker extends BaseKalendarPicker {
  KalendarMonthRangePicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.monthShortLocal,
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
    if (checkDateOutOfBoundaries(date)) return;
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
    return TextButton(
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
      child: Text(widget.monthShortLocal.getLocalName(date.month)),
    );
  }

  Widget buildDates() {
    final columns = <Widget>[];
    var rows = <Widget>[];
    Offset? startOffset;
    Offset? endOffset;
    bool shouldPaintRange = false;
    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      final rowIndex = i % 4;
      if (currentDateRange != null) {
        if (date == currentDateRange!.start) {
          shouldPaintRange = true;
          startOffset = Offset(rowIndex * cellSize.width, 0);
        } else if (date == currentDateRange!.end) {
          shouldPaintRange = true;
          endOffset = Offset(rowIndex * cellSize.width, 0);
        } else if (currentDateRange!.contains(date)) {
          shouldPaintRange = true;
        }
      }
      rows.add(
        SizedBox(
          width: cellSize.width,
          height: cellSize.height - 10,
          child: buildCell(date),
        ),
      );
      if (rowIndex == 3) {
        columns.add(
          SizedBox(
            height: cellSize.height,
            child: Center(
              child: SizedBox(
                height: cellSize.height - 10,
                child: Stack(
                  children: [
                    if (shouldPaintRange)
                      Positioned.fill(
                        left: 5,
                        right: 5,
                        child: DateRangePainter(
                          start: startOffset,
                          end: endOffset,
                          radius: (cellSize.height - 10) / 2,
                          color: style.accentBackgroundColor,
                        ),
                      ),
                    Positioned.fill(child: Row(children: rows)),
                  ],
                ),
              ),
            ),
          ),
        );
        rows = [];
        shouldPaintRange = false;
        startOffset = null;
        endOffset = null;
      }
    }
    return Column(children: columns);
  }

  @override
  Widget build(BuildContext context) {
    initStyle(context);
    return buildContainer(buildDates());
  }
}
