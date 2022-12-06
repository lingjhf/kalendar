import 'package:flutter/material.dart';

import 'base_kalendar_date_picker.dart';


class KalendarDatePicker extends BaseKalendarDatePicker {
  KalendarDatePicker({
    super.key,
    super.initDate,
    super.minDate,
    super.maxDate,
    super.optionalDates,
    super.disable,
    super.readonly,
    super.style,
    super.firstDayOfWeek,
    this.currentDate,
    this.onChange,
  });

  final DateTime? currentDate;

  final ValueChanged<DateTime?>? onChange;

  @override
  State<StatefulWidget> createState() => _KalendarDatePicker();
}

class _KalendarDatePicker
    extends BaseKalendarDatePickerState<KalendarDatePicker> {
  DateTime? currentDate;

  @override
  void initState() {
    super.initState();
    updateCurrentDate();
  }

  @override
  void didUpdateWidget(covariant KalendarDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCurrentDate();
  }

  void updateCurrentDate() {
    if (widget.currentDate != null) {
      currentDate = DateUtils.dateOnly(widget.currentDate!);
    }
  }

  bool isCurrentDate(DateTime date) {
    return date == currentDate;
  }

  //点击选择日期
  void onSelectDate(DateTime date) {
    if (widget.readonly) return;
    if (optionalDateMap.isNotEmpty && !optionalDateMap.containsKey(date)) {
      return;
    }
    currentDate = isCurrentDate(date) ? null : date;
    if (date.month != initDate.month) {
      onInitDateChange(date);
    } else {
      setState(() {});
    }
    widget.onChange?.call(currentDate);
  }

  TextStyle? getDateTextStyle(Set<MaterialState> states, DateTime date) {
    final isAccent = isCurrentDate(date);
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
    final isAccent =
        isCurrentDate(date) || date == DateUtils.dateOnly(DateTime.now());
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
    if (date.month == initDate.month) {
      return style.primaryColor;
    }
    return style.secondaryColor;
  }

  Color? getDateBackground(Set<MaterialState> states, DateTime date) {
    final isAccent = isCurrentDate(date);
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
    initStyle(context);
    return buildContainer(
      context,
      GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: 36,
        ),
        children: [
          for (var date in dates)
            Center(
              child: SizedBox(
                width: 36,
                height: 32,
                child: TextButton(
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
                  onPressed: () => onSelectDate(date),
                  child: Text('${date.day}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
