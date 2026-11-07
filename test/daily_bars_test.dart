// Hábitos daily bars: with no days before measured, a label says so instead of any fixed line
import 'package:apptime/screens/habits/daily_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _empty = 'Sem histórico para comparar';

Widget _bars(int lineMs) => MaterialApp(
      home: Scaffold(
        body: DailyBars(dailyMs: const [3600000, 7200000], lineMs: lineMs,
            lineLabel: 'linha: 6 dos 30 dias anteriores', emptyLabel: _empty),
      ),
    );

void main() {
  testWidgets('no days before measured: the empty label shows', (tester) async {
    await tester.pumpWidget(_bars(0));
    expect(find.text(_empty), findsOneWidget);
  });

  testWidgets('days before measured: no empty label', (tester) async {
    await tester.pumpWidget(_bars(5400000));
    expect(find.text(_empty), findsNothing);
  });
}
