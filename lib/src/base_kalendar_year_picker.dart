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
    return buildContainer(
      GridView(gridDelegate: gridDelegate, children: [
        for (var date in dates)
          Center(
            child: SizedBox(
              width: cellSize.width,
              height: cellSize.width - 10,
              child: callback(date),
            ),
          )
      ]),
    );
  }
}
