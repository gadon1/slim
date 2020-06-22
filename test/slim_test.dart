import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/slim.dart';
import 'test_app.dart';

class TestLocalization extends SlimLocaleLoader {
  final translations = {};

  @override
  Future<bool> load() async => true;

  @override
  String translate(String key, [String group]) => translations[key] ?? "";
}

void main() {
  test('levenshtein score', () {
    final res = "פלפלים".levenshteinScore('פלפל ירוק חריף');
    expect(res, 0.6428571428571429);
  });

  test('date format', () {
    final date = DateTime(2021, 6, 2);
    expect(date.format('d/m/yy'), '2/6/21');
    expect(date.format('dd-m-yyyy'), '02-6-2021');
    expect(date.format('dd/mm/yyyy'), '02/06/2021');
  });

  testWidgets('slim', (WidgetTester tester) async {
    DateTime dt = DateTime.now();

    String userName = dt.microsecondsSinceEpoch.toString();
    String hi = dt.add(1.microseconds).microsecondsSinceEpoch.toString();
    String password = dt.add(2.microseconds).microsecondsSinceEpoch.toString();

    SlimLocalizations.slimLocaleLoader = TestLocalization()
      ..translations["hi"] = hi;

    await tester.pumpWidget(TestApp());
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(FlatButton), findsNWidgets(2));

    await tester.enterText(find.byKey(userKey), userName);
    await tester.enterText(find.byKey(passwordKey), password);
    await tester.pumpAndSettle();

    expect(find.text('$hi $userName'), findsNothing);
    expect(find.text('$userName'), findsOneWidget);
    expect(find.text('$password'), findsOneWidget);

    await tester.tap(find.byKey(goodLoginKey));
    await tester.pumpAndSettle(10.seconds);

    expect(find.byType(TextFormField), findsNothing);
    expect(find.byType(FlatButton), findsNothing);

    expect(find.text('$hi $userName'), findsOneWidget);
  });
}
