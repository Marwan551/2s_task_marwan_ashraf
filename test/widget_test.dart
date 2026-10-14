import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_2s_marwan_ashraf/main.dart';

void main() {
  testWidgets('Odoo Sales App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
