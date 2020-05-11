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
              expect(ctx.slim<String>(), 'slim works');
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
        builder: (context) =>
            [Slimer<String>('slim works'), Slimer<int>(10)].slim(
          child: Builder(
            builder: (ctx) {
              expect(ctx.slim<String>(), 'slim works');
              expect(ctx.slim<int>(), 10);
              return Container();
            },
          ),
        ),
      ),
    );
  });
}
