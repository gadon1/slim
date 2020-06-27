import 'int.dart';

extension SlimDateTimePrivateX on DateTime {
  DateTime minutesInterval(int interval) =>
      add((interval - minute % interval).minutes);
}

extension SlimDateTimeX on DateTime {
  String format(String pattern) {
    String res = pattern.toLowerCase();
    res = res.replaceFirst('dd', "$day".padLeft(2, '0'));
    res = res.replaceFirst('d', "$day");
    res = res.replaceFirst('mi', "$minute".padLeft(2, '0'));
    res = res.replaceFirst('mm', "$month".padLeft(2, '0'));
    res = res.replaceFirst('m', "$month");
    res = res.replaceFirst('yyyy', "$year");
    res = res.replaceFirst('yy', "$year".substring(2));
    res = res.replaceFirst('ss', "$second".padLeft(2, '0'));
    res = res.replaceFirst('s', "$second");
    res = res.replaceFirst('hh', "$hour".padLeft(2, '0'));
    res = res.replaceFirst('h', "$hour");
    return res;
  }
}
