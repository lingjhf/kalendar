import 'package:flutter/material.dart';

import 'enums.dart';
import 'kalendar_date_picker.dart';
import 'kalendar_month_picker.dart';
import 'kalendar_year_picker.dart';
import 'localization.dart';
import 'theme.dart';

class Kalendar extends StatelessWidget {
  const Kalendar({
    super.key,
    this.initDate,
    this.mode = KalendarMode.day,
    this.multiple = false,
    this.range = false,
    this.minDate,
    this.maxDate,
    this.optionalDates = const [],
    this.disable = false,
    this.readonly = false,
    this.firstDayOfWeek = KalendarWeekDays.sunday,
    this.monthLocal = const KalendarMonthLocal(),
    this.monthShortLocal = const KalendarMonthShortLocal(),
    this.weekLocal = const KalendarWeekLocal(),
    this.weekShortLocal = const KalendarWeekShortLocal(),
    this.style,
    this.currentDate,
    this.currentDateRange,
    this.currentDates = const [],
    this.onDateChange,
    this.onDateRangeChange,
    this.onMultipleDateChange,
  });

  final KalendarMode mode;

  final bool multiple;

  final bool range;

  //初始化日期，如果没有设置则为今天
  final DateTime? initDate;

  //可选择的最小日期
  final DateTime? minDate;

  //可选择的最大日期
  final DateTime? maxDate;

  //指定可选日期
  final List<DateTime> optionalDates;

  //禁止操作
  final bool disable;

  //只读日历
  final bool readonly;

  final KalendarWeekDays firstDayOfWeek;

  final KalendarMonthLocal monthLocal;

  final KalendarMonthLocal monthShortLocal;

  final KalendarWeekLocal weekLocal;

  final KalendarWeekLocal weekShortLocal;

  final KalendarStyle? style;

  final DateTime? currentDate;

  final DateTimeRange? currentDateRange;

  final List<DateTime> currentDates;

  final ValueChanged<DateTime?>? onDateChange;

  final ValueChanged<DateTimeRange?>? onDateRangeChange;

  final ValueChanged<List<DateTime>>? onMultipleDateChange;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case KalendarMode.day:
        if (multiple) {
          return KalendarMultipleDatePicker(
            initDate: initDate,
            minDate: minDate,
            maxDate: maxDate,
            optionalDates: optionalDates,
            disable: disable,
            readonly: readonly,
            monthLocal: monthLocal,
            monthShortLocal: monthShortLocal,
            weekLocal: weekLocal,
            weekShortLocal: weekShortLocal,
            style: style,
            firstDayOfWeek: firstDayOfWeek,
            currentDates: currentDates,
            onChange: onMultipleDateChange,
          );
        }
        if (range) {
          return KalendarDateRangePicker(
            initDate: initDate,
            minDate: minDate,
            maxDate: maxDate,
            optionalDates: optionalDates,
            disable: disable,
            readonly: readonly,
            monthLocal: monthLocal,
            monthShortLocal: monthShortLocal,
            weekLocal: weekLocal,
            weekShortLocal: weekShortLocal,
            style: style,
            firstDayOfWeek: firstDayOfWeek,
            currentDateRange: currentDateRange,
            onChange: onDateRangeChange,
          );
        }
        return KalendarDatePicker(
          initDate: initDate,
          minDate: minDate,
          maxDate: maxDate,
          optionalDates: optionalDates,
          disable: disable,
          readonly: readonly,
          monthLocal: monthLocal,
          monthShortLocal: monthShortLocal,
          weekLocal: weekLocal,
          weekShortLocal: weekShortLocal,
          style: style,
          firstDayOfWeek: firstDayOfWeek,
          currentDate: currentDate,
          onChange: onDateChange,
        );
      case KalendarMode.month:
        if (multiple) {
          return KalendarMultipleMonthPicker(
            initDate: initDate,
            minDate: minDate,
            maxDate: maxDate,
            optionalDates: optionalDates,
            disable: disable,
            readonly: readonly,
            monthShortLocal: monthShortLocal,
            style: style,
            currentDates: currentDates,
            onChange: onMultipleDateChange,
          );
        }
        if (range) {
          return KalendarMonthRangePicker(
            initDate: initDate,
            minDate: minDate,
            maxDate: maxDate,
            optionalDates: optionalDates,
            disable: disable,
            readonly: readonly,
            monthShortLocal: monthShortLocal,
            style: style,
            currentDateRange: currentDateRange,
            onChange: onDateRangeChange,
          );
        }
        return KalendarMonthPicker(
          initDate: initDate,
          minDate: minDate,
          maxDate: maxDate,
          optionalDates: optionalDates,
          disable: disable,
          readonly: readonly,
          monthShortLocal: monthShortLocal,
          style: style,
          currentDate: currentDate,
          onChange: onDateChange,
        );
      case KalendarMode.year:
        if (multiple) {
          return KalendarMultipleYearPicker(
            initDate: initDate,
            minDate: minDate,
            maxDate: maxDate,
            optionalDates: optionalDates,
            disable: disable,
            readonly: readonly,
            style: style,
            currentDates: currentDates,
            onChange: onMultipleDateChange,
          );
        }
        return KalendarYearPicker(
          initDate: initDate,
          minDate: minDate,
          maxDate: maxDate,
          optionalDates: optionalDates,
          disable: disable,
          readonly: readonly,
          style: style,
          currentDate: currentDate,
          onChange: onDateChange,
        );
    }
  }
}
