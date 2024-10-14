import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/file_utils.dart';
import '../../widgets/widgets.export.dart';

class DateTimeHelper {
  static const String ddMMYY = "dd/MM/yyyy";
  static const String ddMMYYHH = "dd/MM/yyyy HH";
  static const String ddMMYYHHMM = "dd/MM/yyyy HH:mm";
  static const String yyMMDDHHMMSS1 = "yyyy/MM/dd HH:mm:ss";
  static const String yyMMDDHHMMSS2 = "yyyy-MM-dd HH:mm:ss";

  static const String hhmmDDMMYY = "hh:mm - dd/MM/yyyy";
  static const String yyyyMMDD = "yyyy-MM-dd";
  static const String ddMMyy = "dd-MM-yyy";
  static const String hhMM = "HH:mm";
  static const String ddMM = "dd/MM";
  static const String HHMMDDMMYY = "HH:mm dd/MM/yyyy";
  static const String DDMMYY = "dd/MM/yyyy";
  static const String ddMMYYYYHHMMSS = "dd/MM/yyyy HH:mm:ss";
  static const String dateTimeLocal = "yyyy-MM-ddT00:00:00.000000000";
  static const String dateTimeLocalOffset = "yyyy-MM-dd'TZ'HH:mm:ss.SSS";
  static const String dateTimeLocalOffsetTZ = "yyyy-MM-dd HH:mm:ss 'TZ'";

  static const String timeLocal = "yyyy-MM-ddTHH:mm:ss.000000000";
  static const String YY = "yyyy";
  static const String MYYYY = "M/yyyy";
  static const String MMYYYY = "MM/yyyy";

  static const int subDAYRANGER = 30; //30days

  static String formatDate(String temps, DateTime dateTime) {
    return DateFormat(temps).format(dateTime);
  }

  static String reFormatDateStr(String temps, String dateTimeStr) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      return DateFormat(temps).format(dateTime);
    } catch (e) {
      return "";
    }
  }

  static DateTime getNow() {
    return DateTime.now();
  }

  static DateTime getTimeBeginOfDay(DateTime time) {
    return DateTime(time.year, time.month, time.day);
  }

  static DateTime subDateByDaysFrom({required int days, required DateTime from}) {
    return from.subtract(Duration(days: days));
  }

  static DateTime subDateByDays([int days = subDAYRANGER]) {
    return DateTime.now().subtract(Duration(days: days));
  }

  static DateTime subDateByMonths([int months = 0]) {
    return DateTime(DateTime.now().year, DateTime.now().month - months, DateTime.now().day);
  }

  static DateTime subDateByYears([int years = 0]) {
    return DateTime(DateTime.now().year - years, DateTime.now().month, DateTime.now().day);
  }

  static DateTime toMidnight(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  static bool isToday(DateTime date) {
    var now = DateTime.now();
    return date.day == now.day && date.month == now.month && date.year == now.year;
  }

  static bool isPastDay(DateTime date) {
    var today = toMidnight(DateTime.now());
    return date.isBefore(today);
  }

  static bool isYesterday(DateTime dateToCheck) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    return aDate == yesterday;
  }

  static String parseTimeToFormat(String pattern, DateTime date) {
    var outputFormat = DateFormat(pattern);
    return outputFormat.format(date);
  }

  static DateTime addDaysToDate(DateTime date, int days) {
    DateTime newDate = date.add(Duration(days: days));

    if (date.hour != newDate.hour) {
      var hoursDifference = date.hour - newDate.hour;

      if (hoursDifference <= 3 && hoursDifference >= -3) {
        newDate = newDate.add(Duration(hours: hoursDifference));
      } else if (hoursDifference <= -21) {
        newDate = newDate.add(Duration(hours: 24 + hoursDifference));
      } else if (hoursDifference >= 21) {
        newDate = newDate.add(Duration(hours: hoursDifference - 24));
      }
    }
    return newDate;
  }

  static bool isSpecialPastDay(DateTime date) {
    return isPastDay(date) || (isToday(date) && DateTime.now().hour >= 12);
  }

  static DateTime getFirstDayOfCurrentMonth() {
    var dateTime = DateTime.now();
    dateTime = getFirstDayOfMonth(dateTime);
    return dateTime;
  }

  static DateTime getFirstDayOfNextMonth() {
    var dateTime = getFirstDayOfCurrentMonth();
    dateTime = addDaysToDate(dateTime, 31);
    dateTime = getFirstDayOfMonth(dateTime);
    return dateTime;
  }

  static DateTime getLastDayOfCurrentMonth() {
    return getLastDayOfMonth(DateTime.now());
  }

  static DateTime getLastDayOfNextMonth() {
    return getLastDayOfMonth(getFirstDayOfNextMonth());
  }

  static DateTime addMonths(DateTime fromMonth, int months) {
    DateTime firstDayOfCurrentMonth = fromMonth;
    for (int i = 0; i < months; i++) {
      firstDayOfCurrentMonth = getLastDayOfMonth(firstDayOfCurrentMonth).add(const Duration(days: 1));
    }

    return firstDayOfCurrentMonth;
  }

  static DateTime getFirstDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month);
  }

  static DateTime getLastDayOfMonth(DateTime month) {
    DateTime firstDayOfMonth = DateTime(month.year, month.month);
    DateTime nextMonth = firstDayOfMonth.add(const Duration(days: 32));
    DateTime firstDayOfNextMonth = DateTime(nextMonth.year, nextMonth.month);
    return firstDayOfNextMonth.subtract(const Duration(days: 1));
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day && date1.month == date2.month && date1.year == date2.year;
  }

  static bool isCurrentMonth(DateTime date) {
    var now = DateTime.now();
    return date.month == now.month && date.year == now.year;
  }

  static int calculateMaxWeeksNumberMonthly(DateTime startDate, DateTime endDate) {
    int monthsNumber = calculateMonthsDifference(startDate, endDate);

    List<int> weeksNumbersMonthly = [];

    if (monthsNumber == 0) {
      return calculateWeeksNumber(startDate, endDate);
    } else {
      weeksNumbersMonthly.add(calculateWeeksNumber(startDate, getLastDayOfMonth(startDate)));

      DateTime firstDateOfMonth = getFirstDayOfMonth(startDate);
      for (int i = 1; i <= monthsNumber - 2; i++) {
        firstDateOfMonth = firstDateOfMonth.add(const Duration(days: 31));
        weeksNumbersMonthly.add(calculateWeeksNumber(firstDateOfMonth, getLastDayOfMonth(firstDateOfMonth)));
      }

      weeksNumbersMonthly.add(calculateWeeksNumber(getFirstDayOfMonth(endDate), endDate));

      weeksNumbersMonthly.sort((a, b) => b.compareTo(a));
      return weeksNumbersMonthly[0];
    }
  }

  static int calculateMonthsDifference(DateTime startDate, DateTime endDate) {
    var yearsDifference = endDate.year - startDate.year;
    return 12 * yearsDifference + endDate.month - startDate.month;
  }

  static bool checkTimeBetterThanNumberDays(int days, DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays > days;
  }

  static int calculateWeeksNumber(DateTime monthStartDate, DateTime monthEndDate) {
    int rowsNumber = 1;

    DateTime currentDay = monthStartDate;
    while (currentDay.isBefore(monthEndDate)) {
      currentDay = currentDay.add(const Duration(days: 1));
      if (currentDay.weekday == DateTime.monday) {
        rowsNumber += 1;
      }
    }

    return rowsNumber;
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  static DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  static DateTime findFirstDateOfNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfNextWeek = dateTime.add(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfNextWeek);
  }

  static DateTime findLastDateOfNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfNextWeek = dateTime.add(const Duration(days: 7));
    return findLastDateOfTheWeek(sameWeekDayOfNextWeek);
  }

  static bool checkExpiredToken(int expriedToken, int startDate) {
    var currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    /// trong trong second
    if (startDate + expriedToken <= currentTime) {
      return false;
    } else {
      return true;
    }
  }

  static bool compareDate(DateTime firstDate, DateTime twoDate) {
    var firstTime = firstDate.millisecondsSinceEpoch;
    var twoTime = twoDate.millisecondsSinceEpoch;
    if (firstTime > twoTime) {
      return true;
    } else {
      return false;
    }
  }

  /*
  return : 0 - Bằng nhau
  return : 1 - first > second
  return : -1 - first < second
   */
  static int checkSameTime(DateTime firstDate, DateTime secondDate) {
    var firstTime = removeSeconds(firstDate).millisecondsSinceEpoch;
    var twoTime = removeSeconds(secondDate).millisecondsSinceEpoch;
    FileUtils.PrintLog("------------ ${formatDate(DateTimeHelper.HHMMDDMMYY, firstDate)} - ${formatDate(DateTimeHelper.HHMMDDMMYY, secondDate)} ------------");
    if (firstTime - twoTime > 0) {
      return 1;
    } else if (firstTime - twoTime < 0) {
      return -1;
    }
    return 0;
  }

  static DateTime removeSeconds(DateTime date) {
    date = DateTime(date.year, date.month, date.day, date.hour, date.minute);
    return date;
  }

  static bool isBiggerDay(DateTime first, DateTime second) {
    return first.year == second.year && first.month == second.month && first.day >= second.day;
  }

  /*{
    calculatorDayMinuteSecondToString
    fromDate < toDate;
    Input
      - 2022-08-12 12:08:10 (fromDate)
      - 2022-09-12 12:08:10 (toDate)
    Output
      Đã trình 1 ngày 0 giờ, 0 phút
  }*/

  static String calculatorDayMinuteSecondToString({required DateTime fromDate, required DateTime toDate}) {
    return 'Đã trình ${toDate.difference(fromDate).inDays} ngày, ${toDate.difference(fromDate).inHours % 24} giờ, ${toDate.difference(fromDate).inMinutes % 60} phút';
  }

  /*{
    calculatorDayMinuteSecondToString
    fromDate < toDate;
    Input
      - 2022-08-12 12:08:10 (fromDate)
      - 2022-09-12 12:08:10 (toDate)
    Output
      1 ngày 0 giờ, 0 phút
  }*/

  static String calculatorDayMinuteSecondToStringMultiLanguage({required DateTime fromDate, required DateTime toDate, required BuildContext context}) {
    return '${toDate.difference(fromDate).inDays} ${L10nX.of(context).date_str},'
        ' ${toDate.difference(fromDate).inHours % 24} ${L10nX.of(context).time_in_hour_str},'
        ' ${toDate.difference(fromDate).inMinutes % 60} ${L10nX.of(context).time_in_minute_str}';
  }

  static String dateNameStr({required DateTime date, String? dateType}) {
    DateTime now = DateTime.now();
    if (dateType != null) {
      return formatDate(dateType, date);
    }
    if (date.year == now.year) {
      return formatDate(ddMM, date);
    } else {
      return formatDate(DDMMYY, date);
    }
  }

  static String dateFormat({required DateTime? date, String? dateType}) {
    if (date == null) {
      return "";
    } else {
      return formatDate(dateType ?? DDMMYY, date);
    }
  }
  /*{
    isExpireByDayNumber
    fromDate < toDate;
    Input
      - 2022-08-12 12:08:10 (fromDate)
      - 2022-09-12 12:08:10 (toDate)
      - 3 (dayNumber)
    Output
      false
  }*/

  static bool isExpireByDayNumber({required DateTime fromDate, required DateTime toDate, required int dayNumber}) {
    return toDate.difference(fromDate).inSeconds > dayNumber * 24 * 60 * 60;
  }

  /*{
    isCurrentYear
    Input
      - date
    Output
      - bool
  }*/

  static bool isCurrentYear(
    DateTime date,
  ) {
    return date.year == DateTime.now().year;
  }

  static String parseStringDate(String date, {String? dateType}) {
    String receiveDateString = '';
    if (date != receiveDateString) {
      DateTime receiveDate = DateTime.parse(date);
      if (isToday(receiveDate)) {
        receiveDateString = formatDate(hhMM, receiveDate);
      } else {
        receiveDateString = dateNameStr(date: receiveDate);
      }
    }
    return receiveDateString;
  }

  static String parseStringDateForDocument(String date) {
    String receiveDateString = '';
    if (date != receiveDateString) {
      DateTime receiveDate = DateTime.parse(date);
      if (!isCurrentYear(receiveDate)) {
        receiveDateString = formatDate(ddMMYY, receiveDate);
      } else {
        receiveDateString = formatDate(ddMM, receiveDate);
      }
    }
    return receiveDateString;
  }

  static String parseDateFull(String date) {
    String receiveDateString = '';
    if (date != receiveDateString) {
      DateTime receiveDate = DateTime.parse(date);
      receiveDateString = formatDate(ddMMYYHHMM, receiveDate);
    }
    return receiveDateString;
  }

  static DateTime? stringToDate(String? dateTime, {String? currentTypeDate}) {
    if (dateTime?.isNotEmpty ?? false) {
      DateTime date = DateFormat(currentTypeDate).parse(dateTime!);
      return date;
    }
    return null;
  }

  static DateTime? isDate(String input, String format) {
    try {
      DateTime date = DateFormat(format).parseStrict(input);
      return date;
    } catch (e) {
      return null;
    }
  }

  static String? stringDateFormat(String? dateTime, {String typeDate = ddMMYY}) {
    if (typeDate == HHMMDDMMYY) {
      var date = stringToDate(dateTime);
      if (date != null) {
        if (date.minute > 0 || date.hour > 0) {
          return formatDate(typeDate, date);
        }
        return formatDate(ddMMYY, date);
      }
      return null;
    }
    var date = stringToDate(dateTime);
    return date != null ? formatDate(typeDate, date) : null;
  }

  static String changeTypeDate(String dateTime, String currentTypeDate, String newTypeDate) {
    try {
      DateTime date = DateFormat(currentTypeDate).parse(dateTime);
      return formatDate(newTypeDate, date);
    } catch (e) {
      return "";
    }
  }
}
