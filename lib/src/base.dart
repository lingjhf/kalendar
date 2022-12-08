import 'package:flutter/material.dart';

import 'theme.dart';

abstract class BaseKalendarPicker extends StatefulWidget {
  BaseKalendarPicker({
    super.key,
    DateTime? initDate,
    this.minDate,
    this.maxDate,
    this.optionalDates = const [],
    this.disable = false,
    this.readonly = false,
    this.style,
  }) : initDate = initDate ?? DateTime.now() {
    assert(
      !(minDate != null && this.initDate.isBefore(minDate!)),
      'initDate $initDate must be on or after minDate $minDate',
    );
    assert(
      !(maxDate != null && this.initDate.isAfter(maxDate!)),
      'initDate $initDate must be on or after minDate $maxDate',
    );
    assert(
      !(minDate != null && maxDate != null && minDate!.isAfter(maxDate!)),
      'minDate $minDate must be on or before maxDate $maxDate',
    );
  }

  //初始化日期，如果没有设置则为今天
  final DateTime initDate;

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

  final KalendarStyle? style;
}

abstract class BaseKalendarPickerState<T extends BaseKalendarPicker>
    extends State<T> {
  late DateTime _initDate;

  List<DateTime> dates = [];

  KalendarStyle style = KalendarStyle();

  Map<DateTime, bool> optionalDateMap = {};

  DateTime? minDate;

  DateTime? maxDate;

  ButtonStyle cellStyle =
      const ButtonStyle(shape: MaterialStatePropertyAll(CircleBorder()));

  DateTime get initDate => _initDate;

  late Size cellSize;

  late SliverGridDelegate gridDelegate;

  @override
  void initState() {
    updateDatesWithInitDate(widget.initDate);
    updateOptionalDateMap();
    updateDateBroundaries();
    updateCellSize();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    updateDatesWithInitDate(widget.initDate);
    updateOptionalDateMap();
    updateDateBroundaries();
    updateCellSize();
    super.didUpdateWidget(oldWidget);
  }

  @mustCallSuper
  void updateDatesWithInitDate(DateTime date) {
    _initDate = date;
  }

  void updateCellSize();

  KalendarStyle disableStyle(KalendarStyle style) {
    return style.copyWith(
      accentColor: style.accentColor.withOpacity(0.6),
      primaryColor: style.primaryColor.withOpacity(0.6),
      secondaryColor: style.secondaryColor.withOpacity(0.6),
      backgroundColor: style.backgroundColor.withOpacity(0.6),
      accentBackgroundColor: style.accentBackgroundColor.withOpacity(0.6),
    );
  }

  void onInitDateChange(DateTime date) {
    if (checkDateOutOfBoundaries(date)) {
      return;
    }
    setState(() {
      updateDatesWithInitDate(date);
    });
  }

  void initStyle(BuildContext context) {
    style =
        widget.style ?? Theme.of(context).extension<KalendarStyle>() ?? style;
    if (widget.disable) {
      style = disableStyle(style);
    }
    cellStyle = cellStyle.copyWith(
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (widget.readonly) {
          return Colors.transparent;
        }
        return widget.style?.accentBackgroundColor;
      }),
    );
  }

  void updateOptionalDateMap() {
    var map = <DateTime, bool>{};
    for (var date in widget.optionalDates) {
      map[DateUtils.dateOnly(date)] = true;
    }
    optionalDateMap = map;
  }

  void updateDateBroundaries() {
    if (widget.minDate != null) {
      minDate = DateUtils.dateOnly(widget.minDate!);
    }
    if (widget.maxDate != null) {
      maxDate = DateUtils.dateOnly(widget.maxDate!);
    }
  }

  bool checkDateOutOfBoundaries(DateTime date) {
    if (minDate != null && date.isBefore(minDate!)) {
      return true;
    }
    if (maxDate != null && date.isAfter(maxDate!)) {
      return true;
    }
    return false;
  }

  Color? getDateOverlayColor(Set<MaterialState> states, DateTime date) {
    if (optionalDateMap.isNotEmpty && optionalDateMap.containsKey(date)) {
      return Colors.transparent;
    }
    return cellStyle.overlayColor?.resolve(states);
  }
}
