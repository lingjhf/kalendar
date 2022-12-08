import 'package:flutter/material.dart';

import 'base.dart';
import 'base_kalendar_month_picker.dart';
import 'extensions.dart';
import 'range_painter.dart';

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
      child: Text('${date.month}'),
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
