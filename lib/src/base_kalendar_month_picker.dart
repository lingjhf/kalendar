import 'package:flutter/material.dart';

import 'base.dart';
import 'enums.dart';
import 'kalendar_month_picker_container.dart';
import 'kalendar_picker_container.dart';
import 'kalendar_year_picker.dart';

abstract class BaseKalendarMonthPickerState<T extends BaseKalendarPicker>
    extends BaseKalendarPickerState<T> {
  KalendarMode mode = KalendarMode.day;

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
    if (mode == KalendarMode.year) {
      return KalendarYearPicker(
        initDate: initDate,
        minDate: widget.minDate,
        maxDate: widget.maxDate,
        optionalDates: widget.optionalDates,
        style: widget.style,
        onChange: onYearPickerChange,
      );
    }
    return KalendarPickerContainer(
      style: style,
      disable: widget.disable,
      child: KalendarMonthPickerContainer(
        initDate: initDate,
        style: style,
        onYearPick: onYearPick,
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
      GridView(gridDelegate: gridDelegate, children: [
        for (var date in dates)
          Center(
            child: SizedBox(width: 63, height: 52, child: callback(date)),
          )
      ]),
    );
  }
}
