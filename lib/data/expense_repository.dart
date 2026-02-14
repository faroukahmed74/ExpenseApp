import 'package:hive_flutter/hive_flutter.dart';

import '../models/budget.dart';
import '../models/expense.dart';

const String _expensesBox = 'expenses';
const String _budgetsBox = 'budgets';
const String _settingsBox = 'settings';
const String _keyLocale = 'locale';
const String _keyThemeMode = 'theme_mode';
const String _keyCurrency = 'currency';

class ExpenseRepository {
  Box<Expense>? _expensesBoxInstance;
  Box<Budget>? _budgetsBoxInstance;
  Box<dynamic>? _settingsBoxInstance;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(BudgetAdapter());
    _expensesBoxInstance = await Hive.openBox<Expense>(_expensesBox);
    _budgetsBoxInstance = await Hive.openBox<Budget>(_budgetsBox);
    _settingsBoxInstance = await Hive.openBox<dynamic>(_settingsBox);
  }

  Box<Expense> get _expenses => _expensesBoxInstance!;
  Box<Budget> get _budgets => _budgetsBoxInstance!;
  Box<dynamic> get _settings => _settingsBoxInstance!;

  // Settings
  String? get localeCode => _settings.get(_keyLocale) as String?;
  Future<void> setLocaleCode(String? value) async {
    if (value != null) {
      await _settings.put(_keyLocale, value);
    } else {
      await _settings.delete(_keyLocale);
    }
  }

  String get themeModeName => _settings.get(_keyThemeMode) as String? ?? 'system';
  Future<void> setThemeModeName(String value) async {
    await _settings.put(_keyThemeMode, value);
  }

  String get currencyCode => _settings.get(_keyCurrency) as String? ?? 'EGP';
  Future<void> setCurrencyCode(String value) async {
    await _settings.put(_keyCurrency, value);
  }

  // Expenses
  List<Expense> getAllExpenses() =>
      _expenses.values.toList()..sort((a, b) => b.date.compareTo(a.date));

  Future<void> addExpense(Expense e) async {
    await _expenses.add(e);
  }

  Future<void> updateExpense(Expense e) async {
    await e.save();
  }

  Future<void> deleteExpense(Expense e) async {
    await e.delete();
  }

  // Budgets
  List<Budget> getAllBudgets() => _budgets.values.toList();

  Future<void> saveBudget(Budget b) async {
    final existing = _budgets.values
        .where((x) => x.categoryName == b.categoryName)
        .firstOrNull;
    if (existing != null) {
      existing.limit = b.limit;
      await existing.save();
    } else {
      await _budgets.add(b);
    }
  }

  Future<void> removeBudget(Budget b) async {
    await b.delete();
  }

  Budget? getBudgetForCategory(String categoryName) =>
      _budgets.values.where((x) => x.categoryName == categoryName).firstOrNull;
}
