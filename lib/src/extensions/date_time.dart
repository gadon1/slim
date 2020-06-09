import 'int.dart';

extension SlimDateTimeX on DateTime {
  DateTime minutesInterval(int interval) =>
      this.add((interval - this.minute % interval).minutes);
}
