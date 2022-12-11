import 'package:flutter/material.dart';

import 'animation.dart';
import 'base.dart';
import 'enums.dart';
import 'extensions.dart';
import 'kalendar_date_picker_container.dart';
import 'kalendar_month_picker.dart';
import 'kalendar_picker_container.dart';
import 'kalendar_year_picker.dart';

abstract class BaseKalendarDatePicker extends BaseKalendarPicker {
  BaseKalendarDatePicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.monthLocal,
    super.monthShortLocal,
    super.weekLocal,
    super.weekShortLocal,
    super.style,
    this.firstDayOfWeek = KalendarWeekDays.sunday,
  });

  //可以设计一个星期的开始是星期几，默认为星期日
  final KalendarWeekDays firstDayOfWeek;
}

abstract class BaseKalendarDatePickerState<T extends BaseKalendarDatePicker>
    extends BaseKalendarPickerState<T> {
  KalendarMode mode = KalendarMode.day;

  //default width:36,height:36
  @override
  void updateCellSize() {
    cellSize = Size(
      style.width / 7,
      (style.height - style.toolbarHeight - style.weekBarHeight) / 6,
    );
    gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7,
      mainAxisExtent: cellSize.height,
    );
  }

  @override
  void updateDatesWithInitDate(DateTime date) {
    super.updateDatesWithInitDate(date);
    final dates = <DateTime>[];
    final day1 = DateTime(date.year, date.month, 1);
    if (day1.weekday != widget.firstDayOfWeek.value) {
      var tempDate = day1;
      while (true) {
        tempDate = tempDate.subtract(const Duration(days: 1));
        dates.insert(0, tempDate);
        if (tempDate.weekday == widget.firstDayOfWeek.value) break;
      }
    }
    var rowCount = 0;
    var tempDate = day1;
    while (rowCount < 6) {
      dates.add(tempDate);
      tempDate = tempDate.add(const Duration(days: 1));
      if (tempDate.weekday == widget.firstDayOfWeek.value) {
        rowCount++;
      }
    }
    this.dates = dates;
  }

  void onMonthPick() {
    setState(() {
      mode = KalendarMode.month;
    });
  }

  void onMonthPickerChange(DateTime? date) {
    setState(() {
      updateDatesWithInitDate(date!);
      mode = KalendarMode.day;
    });
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
      case KalendarMode.day:
        container = KalendarPickerContainer(
          width: style.width,
          height: style.height,
          style: style,
          disable: widget.disable,
          child: KalendarDatePickerContainer(
            initDate: initDate,
            firstDayOfWeek: widget.firstDayOfWeek,
            direction: direction,
            monthLocal: widget.monthLocal,
            weekShortLocal: widget.weekShortLocal,
            style: style,
            onMonthPick: onMonthPick,
            onYearPick: onYearPick,
            onPrevMonth: onInitDateChange,
            onNextMonth: onInitDateChange,
            onPrevYear: onInitDateChange,
            onNextYear: onInitDateChange,
            child: SizedBox(key: ValueKey(initDate), child: child),
          ),
        );
        break;
      case KalendarMode.month:
        container = KalendarMonthPicker(
          initDate: initDate,
          minDate: widget.minDate,
          maxDate: widget.maxDate,
          optionalDates: widget.optionalDates,
          monthShortLocal: widget.monthShortLocal,
          style: widget.style,
          onChange: onMonthPickerChange,
        );
        break;
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
    }

    return VisibilityAnimation(child: container);
  }

  Widget datesBuilder(
    BuildContext context,
    Widget Function(DateTime date) callback,
  ) {
    initStyle(context);
    return buildContainer(
      GridView(gridDelegate: gridDelegate, children: [
        for (var date in dates)
          Center(
            child: SizedBox(
              width: cellSize.width,
              height: cellSize.height - 4,
              child: callback(date),
            ),
          )
      ]),
    );
  }
}

class KalendarDatePicker extends BaseKalendarDatePicker {
  KalendarDatePicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.monthLocal,
    super.monthShortLocal,
    super.weekLocal,
    super.weekShortLocal,
    super.style,
    super.firstDayOfWeek,
    this.currentDate,
    this.onChange,
  });

  final DateTime? currentDate;

  final ValueChanged<DateTime?>? onChange;

  @override
  State<StatefulWidget> createState() => _KalendarDatePicker();
}

class _KalendarDatePicker
    extends BaseKalendarDatePickerState<KalendarDatePicker> {
  DateTime? currentDate;

  @override
  void initState() {
    super.initState();
    updateCurrentDate();
  }

  @override
  void didUpdateWidget(covariant KalendarDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCurrentDate();
  }

  void updateCurrentDate() {
    if (widget.currentDate != null) {
      currentDate = DateUtils.dateOnly(widget.currentDate!);
    }
  }

  bool isCurrentDate(DateTime date) {
    return date == currentDate;
  }

  //点击选择日期
  void onSelectDate(DateTime date) {
    if (widget.readonly) return;
    if (checkDateOutOfBoundaries(date)) return;
    if (optionalDateMap.isNotEmpty && !optionalDateMap.containsKey(date)) {
      return;
    }
    currentDate = isCurrentDate(date) ? null : date;
    if (date.month != initDate.month) {
      onInitDateChange(date);
    } else {
      setState(() {});
    }
    widget.onChange?.call(currentDate);
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    final isAccent = isCurrentDate(date);
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
    final isAccent =
        isCurrentDate(date) || date == DateUtils.dateOnly(DateTime.now());
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
    final isAccent = isCurrentDate(date);
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

class KalendarMultipleDatePicker extends BaseKalendarDatePicker {
  KalendarMultipleDatePicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.monthLocal,
    super.monthShortLocal,
    super.weekLocal,
    super.weekShortLocal,
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
    if (checkDateOutOfBoundaries(date)) return;
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

class KalendarDateRangePicker extends BaseKalendarDatePicker {
  KalendarDateRangePicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.monthLocal,
    super.monthShortLocal,
    super.weekLocal,
    super.weekShortLocal,
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
