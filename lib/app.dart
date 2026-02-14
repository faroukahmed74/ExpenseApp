import 'package:flutter/material.dart';

import 'screens/add_edit_expense_screen.dart';
import 'screens/budgets_screen.dart';
import 'screens/expense_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/stats_screen.dart';

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
          primary: const Color(0xFF2E7D32),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
        ),
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        ExpenseListScreen.routeName: (_) => const ExpenseListScreen(),
        StatsScreen.routeName: (_) => const StatsScreen(),
        BudgetsScreen.routeName: (_) => const BudgetsScreen(),
        AddEditExpenseScreen.routeName: (_) => const AddEditExpenseScreen(),
      },
    );
  }
}
