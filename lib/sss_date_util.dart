library sss_date_util;

/// 枚举：时间格式化方式
enum DateFormatType {
  /// yyyy-MM-dd
  style1,

  /// yyyy.MM.dd
  style2,

  /// yyyy年MM月dd日
  style3,

  /// yyyyMMdd
  style4,

  /// yyyy-MM-dd HH:mm
  style5,

  /// HH:mm
  style6,

  /// yyyy.MM.dd HH:mm
  style7,

  /// MM月dd日 HH:mm:ss
  style8,

  /// yyyy年MM月dd日 HH:mm
  style9,

  /// HH:mm:ss
  style10,

  /// MM月dd日 HH:mm
  style11,

  /// yyyy-MM-dd HH:mm:ss
  style12,
}

class SssDateUtil {

  /// 获取-DateFormatString
  static String getBaseFormat(DateFormatType? type) {
    if (type == null) return '';
    switch (type) {
      case DateFormatType.style1:
        return 'yyyy-MM-dd';
      case DateFormatType.style2:
        return 'yyyy.MM.dd';
      case DateFormatType.style3:
        return 'yyyy年MM月dd日';
      case DateFormatType.style4:
        return 'yyyyMMdd';
      case DateFormatType.style5:
        return 'yyyy-MM-dd HH:mm';
      case DateFormatType.style6:
        return 'HH:mm';
      case DateFormatType.style7:
        return 'yyyy.MM.dd HH:mm';
      case DateFormatType.style8:
        return 'MM月dd日 HH:mm:ss';
      case DateFormatType.style9:
        return 'yyyy年MM月dd日 HH:mm';
      case DateFormatType.style10:
        return 'HH:mm:ss';
      case DateFormatType.style11:
        return 'MM月dd日 HH:mm';
      case DateFormatType.style12:
        return 'yyyy-MM-dd HH:mm:ss';
      default:
        return '';
    }
  }

  /// 带时区时间转换DateTime
  static DateTime parse(String datetime) {
    if (datetime.length > 19) {
      return DateTime.parse(datetime.substring(0, 19));
    }
    return DateTime.parse(datetime);
  }

  /// 转化年龄工具类
  static String getAgeByBirth(DateTime brt) {
    int age = 0;
    DateTime dateTime = DateTime.now();
    if (brt.isAfter(dateTime)) {
      return '出生日期不正确'; //出生日期晚于当前时间，无法计算
    }
    int yearNow = dateTime.year; //当前年份
    int monthNow = dateTime.month; //当前月份
    int dayOfMonthNow = dateTime.day; //当前日期

    int yearBirth = brt.year;
    int monthBirth = brt.month;
    int dayOfMonthBirth = brt.day;
    age = yearNow - yearBirth; //计算整岁数
    if (monthNow <= monthBirth) {
      if (monthNow == monthBirth) {
        if (dayOfMonthNow < dayOfMonthBirth) age--; //当前日期在生日之前，年龄减一
      } else {
        age--; //当前月份在生日之前，年龄减一
      }
    }
    return age.toString();
  }

  /// 计算时间差 - <单位:天>
  static int differenceDays(String fromDateStr, String toDateStr) {
    DateTime fromDate = SssDateUtil.parse(fromDateStr);
    DateTime toDate = SssDateUtil.parse(toDateStr);
    var difference = toDate.difference(fromDate);
    return difference.inDays;
  }

  /// 是否为昨天
  static bool isToday(DateTime dateTime) {
    return (DateTime.now().year == dateTime.year &&
        DateTime.now().month == dateTime.month &&
        DateTime.now().day == dateTime.day)
        ? true
        : false;
  }

  /// 是否为昨天
  static bool isYesterday(DateTime dateTime) {
    DateTime yesterday = DateTime.now().add(const Duration(days: -1));
    return (yesterday.year == dateTime.year &&
        yesterday.month == dateTime.month &&
        yesterday.day == dateTime.day)
        ? true
        : false;
  }

  /// 是否为当月第一天
  static bool isFirstDayOfMonth(DateTime dateTime) {
    return dateTime.day == 1 ? true : false;
  }

  /// 是否为当月最后天
  static bool isLastDayOfMonth(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;

    if ((month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 10 ||
        month == 12) &&
        day == 31) {
      return true;
    } else if ((month == 4 || month == 6 || month == 9 || month == 11) &&
        day == 30) {
      return true;
    } else if (month == 2 &&
        ((year % 4 == 0 && day == 29) || (year % 4 != 0 && day == 28))) {
      return true;
    } else {
      return false;
    }
  }

  /// 是否为当年第一天
  static bool isFirstDayOfYear(DateTime dateTime) {
    return (dateTime.month == 1 && dateTime.day == 1) ? true : false;
  }

  /// 是否为当年最后天
  static bool isLastDayOfYear(DateTime dateTime) {
    return (dateTime.month == 12 && dateTime.day == 31) ? true : false;
  }

  /// 获取间隔月份第一天-> DateTime
  /// `startDateTime` 初始时间
  /// `monthInterval` < 0 向前计算
  /// `monthInterval` > 0 向后计算
  static DateTime getMonthIntervalFirstDayDate(
      DateTime? startDateTime, int monthInterval) {
    startDateTime ??= DateTime.now();
    int year = startDateTime.year;
    int month = startDateTime.month;

    int targetYear = year + (month + monthInterval) ~/ 12;
    int targetMonth = (month + monthInterval) % 12;

    return DateTime.parse(
        '$targetYear-${targetMonth.toString().padLeft(2, '0')}-01');
  }

  /// 获取间隔月份最后一天-> DateTime
  /// `startDateTime` 初始时间
  /// `monthInterval` < 0 向前计算
  /// `monthInterval` > 0 向后计算
  static DateTime getMonthIntervalLastDayDate(
      DateTime? startDateTime, int monthInterval) {
    return SssDateUtil.getMonthIntervalFirstDayDate(
        startDateTime, monthInterval + 1)
        .add(const Duration(days: -1));
  }

  /// 计算时间间距 <两个时间间距>
  static String cutDownString(DateTime toDate, DateTime? fromDate) {
    fromDate ??= DateTime.now();
    var difference = toDate.difference(fromDate);
    if (difference.inSeconds < 0) return '已过期';

    String timeStr = '';
    if (difference.inDays > 0) {
      timeStr =
      '${difference.inDays}天${difference.inHours % 24}时${difference.inMinutes % 24 % 60}分钟';
    } else {
      if (difference.inHours > 0) {
        timeStr = '${difference.inHours % 24}时${difference.inMinutes % 60}分钟';
      } else {
        timeStr = '${difference.inMinutes % 60}分钟';
      }
    }

    return timeStr;
  }
}
