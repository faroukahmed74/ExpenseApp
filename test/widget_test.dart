import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:expense_app/app.dart';
import 'package:expense_app/data/expense_repository.dart';
import 'package:expense_app/providers/expense_provider.dart';

void main() {
  testWidgets('App shows Expense Tracker title', (WidgetTester tester) async {
    final repo = ExpenseRepository();
    await repo.init();

    await tester.pumpWidget(
      ChangeNotifierProvider<ExpenseProvider>(
        create: (_) => ExpenseProvider(repo)..load(),
        child: const ExpenseApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Expense Tracker'), findsOneWidget);
  });
}
