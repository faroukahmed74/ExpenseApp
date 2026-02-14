import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/expense_repository.dart';
import 'providers/expense_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = ExpenseRepository();
  await repo.init();
  runApp(
    ChangeNotifierProvider<ExpenseProvider>(
      create: (_) => ExpenseProvider(repo)..load(),
      child: const ExpenseApp(),
    ),
  );
}
