import 'package:flutter/material.dart';

import 'base.dart';
import 'enums.dart';
import 'kalendar_month_picker_container.dart';
import 'kalendar_picker_container.dart';
import 'kalendar_year_picker.dart';

abstract class BaseKalendarMonthPickerState<T extends BaseKalendarPicker>
    extends BaseKalendarPickerState<T> {
  KalendarMode mode = KalendarMode.day;

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

  Widget buildContainer(BuildContext context, Widget child) {
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
}
