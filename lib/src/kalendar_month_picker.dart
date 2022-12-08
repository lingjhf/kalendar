import 'package:flutter/material.dart';

import 'base.dart';
import 'base_kalendar_month_picker.dart';

class KalendarMonthPicker extends BaseKalendarPicker {
  KalendarMonthPicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.style,
    this.currentDate,
    this.onChange,
  });

  final DateTime? currentDate;

  final ValueChanged<DateTime?>? onChange;

  @override
  State<StatefulWidget> createState() => _KalendarMonthPickerState();
}

class _KalendarMonthPickerState
    extends BaseKalendarMonthPickerState<KalendarMonthPicker> {
  DateTime? currentDate;

  @override
  void initState() {
    super.initState();
    updateCurrentDate();
  }

  @override
  void didUpdateWidget(covariant KalendarMonthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCurrentDate();
  }

  void updateCurrentDate() {
    if (widget.currentDate != null) {
      currentDate = DateUtils.dateOnly(widget.currentDate!);
    }
  }

  bool isCurrentMonth(DateTime date) {
    return DateUtils.isSameMonth(currentDate, date);
  }

  //点击选择日期
  void onSelectMonth(DateTime date) {
    if (widget.readonly) return;
    if (optionalDateMap.isNotEmpty && !optionalDateMap.containsKey(date)) {
      return;
    }
    currentDate = isCurrentMonth(date) ? null : date;
    if (date.year != initDate.year) {
      onInitDateChange(date);
    } else {
      setState(() {});
    }
    widget.onChange?.call(currentDate);
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    final isAccent = isCurrentMonth(date);
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
    final isAccent = isCurrentMonth(date);
    if (DateUtils.isSameMonth(date, DateTime.now())) {
      return style.accentColor;
    }
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
    if (date.year == initDate.year) {
      return style.primaryColor;
    }
    return style.secondaryColor;
  }

  Color? getDateBackground(Set<MaterialState> states, DateTime date) {
    final isAccent = isCurrentMonth(date);
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
        onPressed: () => onSelectMonth(date),
        child: Text('${date.month}'),
      ),
    );
  }
}
