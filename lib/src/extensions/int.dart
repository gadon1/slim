import 'date_time.dart';

/// Useful extension methods on [int]
extension SlimIntX on int {
  /// Get Duration of seconds
  Duration get seconds => Duration(seconds: this);

  /// Get Duration of hours
  Duration get hours => Duration(hours: this);

  /// Get Duration of days
  Duration get days => Duration(days: this);

  /// Get Duration of minutes
  Duration get minutes => Duration(minutes: this);

  /// Get Duration of milliseconds
  Duration get milliseconds => Duration(milliseconds: this);

  /// Get Duration of microseconds
  Duration get microseconds => Duration(microseconds: this);

  /// Get closest time with minutes interval
  DateTime get nowMinutesInterval => DateTime.now().minutesInterval(this);
}
