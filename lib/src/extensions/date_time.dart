import 'int.dart';

extension SlimDateTimePrivateX on DateTime {
  DateTime minutesInterval(int interval) =>
      add((interval - minute % interval).minutes);
}

extension SlimDateTimeX on DateTime {
  String format(String pattern) => pattern.toLowerCase()
    ..replaceFirst('dd', "$day".padLeft(2, '0'))
    ..replaceFirst('d', "$day")
    ..replaceFirst('mi', "$minute".padLeft(2, '0'))
    ..replaceFirst('mm', "$month".padLeft(2, '0'))
    ..replaceFirst('m', "$month")
    ..replaceFirst('yyyy', "$year")
    ..replaceFirst('yy', "$year".substring(2))
    ..replaceFirst('ss', "$second".padLeft(2, '0'))
    ..replaceFirst('s', "$second")
    ..replaceFirst('hh', "$hour".padLeft(2, '0'))
    ..replaceFirst('h', "$hour");
}
