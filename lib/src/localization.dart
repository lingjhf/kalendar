class KalendarMonthLocal {
  const KalendarMonthLocal({
    this.january = 'January',
    this.february = 'February',
    this.march = 'March',
    this.april = 'April',
    this.may = 'May',
    this.june = 'June',
    this.july = 'July',
    this.august = 'August',
    this.september = 'September',
    this.october = 'October',
    this.november = 'November',
    this.december = 'December',
  });
  final String january;
  final String february;
  final String march;
  final String april;
  final String may;
  final String june;
  final String july;
  final String august;
  final String september;
  final String october;
  final String november;
  final String december;

  String getLocalName(int month) {
    switch (month) {
      case DateTime.january:
        return january;
      case DateTime.february:
        return february;
      case DateTime.march:
        return march;
      case DateTime.april:
        return april;
      case DateTime.may:
        return may;
      case DateTime.june:
        return june;
      case DateTime.july:
        return july;
      case DateTime.august:
        return august;
      case DateTime.september:
        return september;
      case DateTime.october:
        return october;
      case DateTime.november:
        return november;
      default:
        return december;
    }
  }

  KalendarMonthLocal copyWith({
    String? january,
    String? february,
    String? march,
    String? april,
    String? may,
    String? june,
    String? july,
    String? august,
    String? september,
    String? october,
    String? november,
    String? december,
  }) {
    return KalendarMonthLocal(
      january: january ?? this.january,
      february: february ?? this.february,
      march: march ?? this.march,
      april: april ?? this.april,
      may: may ?? this.may,
      june: june ?? this.june,
      july: july ?? this.july,
      august: august ?? this.august,
      september: september ?? this.september,
      october: october ?? this.october,
      november: november ?? this.november,
      december: december ?? this.december,
    );
  }

  KalendarMonthLocal merge(KalendarMonthLocal? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      january: other.january,
      february: other.february,
      march: other.march,
      april: other.april,
      may: other.may,
      june: other.june,
      july: other.july,
      august: other.august,
      september: other.september,
      october: other.october,
      november: other.november,
      december: other.december,
    );
  }
}

class KalendarMonthShortLocal extends KalendarMonthLocal {
  const KalendarMonthShortLocal({
    super.january = '1',
    super.february = '2',
    super.march = '3',
    super.april = '4',
    super.may = '5',
    super.june = '6',
    super.july = '7',
    super.august = '8',
    super.september = '9',
    super.october = '10',
    super.november = '11',
    super.december = '12',
  });
}

class KalendarWeekLocal {
  const KalendarWeekLocal({
    this.monday = 'Monday',
    this.tuesday = 'Tuesday',
    this.wednesday = 'Wednesday',
    this.thursday = 'Thursday',
    this.friday = 'Friday',
    this.saturday = 'Saturday',
    this.sunday = 'Sunday',
  });

  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  String getLocalName(int weekDay) {
    switch (weekDay) {
      case DateTime.monday:
        return monday;
      case DateTime.tuesday:
        return tuesday;
      case DateTime.wednesday:
        return wednesday;
      case DateTime.thursday:
        return thursday;
      case DateTime.friday:
        return friday;
      case DateTime.saturday:
        return saturday;
      default:
        return sunday;
    }
  }

  KalendarWeekLocal copyWith({
    String? monday,
    String? tuesday,
    String? wednesday,
    String? thursday,
    String? friday,
    String? saturday,
    String? sunday,
  }) {
    return KalendarWeekLocal(
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
    );
  }

  KalendarWeekLocal merge(KalendarWeekLocal? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      monday: other.monday,
      tuesday: other.tuesday,
      wednesday: other.wednesday,
      thursday: other.thursday,
      friday: other.friday,
      saturday: other.saturday,
      sunday: other.sunday,
    );
  }
}

class KalendarWeekShortLocal extends KalendarWeekLocal {
  const KalendarWeekShortLocal({
    super.monday = 'Mon',
    super.tuesday = 'Tue',
    super.wednesday = 'Wed',
    super.thursday = 'Thu',
    super.friday = 'Fri',
    super.saturday = 'Sat',
    super.sunday = 'Sun',
  });
}
