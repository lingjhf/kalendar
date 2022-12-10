import 'package:flutter/material.dart';

import 'animation.dart';
import 'base.dart';
import 'enums.dart';
import 'kalendar_month_picker_container.dart';
import 'kalendar_picker_container.dart';
import 'kalendar_year_picker.dart';

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
