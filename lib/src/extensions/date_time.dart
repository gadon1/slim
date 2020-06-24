import 'int.dart';

extension SlimDateTimePrivateX on DateTime {
  DateTime minutesInterval(int interval) =>
      add((interval - minute % interval).minutes);
}

extension SlimDateTimeX on DateTime {
  String format(String pattern) {
    String res = pattern.toLowerCase();
    if (res.contains('dd'))
      res = res.replaceFirst('dd', "$day".padLeft(2, '0'));
    else
      res = res.replaceFirst('d', "$day");

    res = res.replaceFirst('mi', "$minute".padLeft(2, '0'));

    if (res.contains('mm'))
      res = res.replaceFirst('mm', "$month".padLeft(2, '0'));
    else
      res = res.replaceFirst('m', "$month");

    if (res.contains('yyyy'))
      res = res.replaceFirst('yyyy', "$year");
    else
      res = res.replaceFirst('yy', "$year".substring(2));

    if (res.contains('ss'))
      res = res.replaceFirst('ss', "$second".padLeft(2, '0'));
    else
      res.replaceFirst('s', "$second");

    if (res.contains('hh'))
      res = res.replaceFirst('hh', "$hour".padLeft(2, '0'));
    else
      res.replaceFirst('h', "$hour");

    return res;
  }
}
