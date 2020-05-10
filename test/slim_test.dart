import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slim/slim.dart';

void main() {
  testWidgets('single slim', (WidgetTester tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) => Slim<String>(
          child: Builder(
            builder: (ctx) {
              expect(Slim.of<String>(ctx), 'slim works');
              return Container();
            },
          ),
          stateObject: 'slim works',
        ),
      ),
    );
  });

  testWidgets('multi slim', (WidgetTester tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) => MultiSlim(
          slimers: [Slimer<String>('slim works'), Slimer<int>(10)],
          child: Builder(
            builder: (ctx) {
              expect(Slim.of<String>(ctx), 'slim works');
              expect(Slim.of<int>(ctx), 10);
              return Container();
            },
          ),
        ),
      ),
    );
  });
}
