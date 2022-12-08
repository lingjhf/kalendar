import 'package:flutter/material.dart';

import 'base.dart';
import 'extensions.dart';
import 'kalendar_picker_container.dart';
import 'kalendar_year_picker_container.dart';

abstract class BaseKalendarYearPickerState<T extends BaseKalendarPicker>
    extends BaseKalendarPickerState<T> {
  late DateTimeRange yearRange;

  //width:63,height:62
  final SliverGridDelegate gridDelegate =
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
    mainAxisExtent: 62,
  );

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

  Widget buildContainer(BuildContext context, Widget child) {
    return KalendarPickerContainer(
      style: style,
      disable: widget.disable,
      child: KalendarYearPickerContainer(
        initDate: initDate,
        dateRange: yearRange,
        style: style,
        onPrevYear: onInitDateChange,
        onNextYear: onInitDateChange,
        child: child,
      ),
    );
  }

  Widget datesBuilder(
      BuildContext context, Widget Function(DateTime date) callback) {
    initStyle(context);
    return buildContainer(
      context,
      GridView(gridDelegate: gridDelegate, children: [
        for (var date in dates)
          Center(
            child: SizedBox(width: 63, height: 52, child: callback(date)),
          )
      ]),
    );
  }
}
