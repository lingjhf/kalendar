import 'package:flutter/material.dart';

import 'base.dart';
import 'enums.dart';
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
    super.style,
    this.firstDayOfWeek = KalendarWeekDay.sunday,
  });

  //可以设计一个星期的开始是星期几，默认为星期日
  final KalendarWeekDay firstDayOfWeek;
}

abstract class BaseKalendarDatePickerState<T extends BaseKalendarDatePicker>
    extends BaseKalendarPickerState<T> {
  KalendarMode mode = KalendarMode.day;

  //width:36,height:36
  final SliverGridDelegate gridDelegate =
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 7,
    mainAxisExtent: 36,
  );

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

  Widget buildContainer(BuildContext context, Widget child) {
    switch (mode) {
      case KalendarMode.day:
        return KalendarPickerContainer(
          style: style,
          disable: widget.disable,
          child: KalendarDatePickerContainer(
            initDate: initDate,
            firstDayOfWeek: widget.firstDayOfWeek,
            style: style,
            onMonthPick: onMonthPick,
            onYearPick: onYearPick,
            onPrevMonth: onInitDateChange,
            onNextMonth: onInitDateChange,
            onPrevYear: onInitDateChange,
            onNextYear: onInitDateChange,
            child: child,
          ),
        );
      case KalendarMode.month:
        return KalendarMonthPicker(
          initDate: initDate,
          minDate: widget.minDate,
          maxDate: widget.maxDate,
          optionalDates: widget.optionalDates,
          style: widget.style,
          onChange: onMonthPickerChange,
        );
      case KalendarMode.year:
        return KalendarYearPicker(
          initDate: initDate,
          minDate: widget.minDate,
          maxDate: widget.maxDate,
          optionalDates: widget.optionalDates,
          style: widget.style,
          onChange: onYearPickerChange,
        );
    }
  }

  Widget datesBuilder(
    BuildContext context,
    Widget Function(DateTime date) callback,
  ) {
    initStyle(context);
    return buildContainer(
      context,
      GridView(
        gridDelegate: gridDelegate,
        children: [
          for (var date in dates)
            Center(
              child: SizedBox(width: 36, height: 32, child: callback(date)),
            )
        ],
      ),
    );
  }
}
