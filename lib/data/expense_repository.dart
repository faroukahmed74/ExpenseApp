import 'package:hive_flutter/hive_flutter.dart';

import '../models/budget.dart';
import '../models/expense.dart';

class ExpenseRepository {
  static const _expensesBox = 'expenses';
  static const _budgetsBox = 'budgets';
  static const _settingsBox = 'settings';
  static const _keyCurrency = 'currency';
  static const _keyLocale = 'locale';
  static const _keyThemeMode = 'theme_mode';

  Box<Expense>? _expenses;
  Box<Budget>? _budgets;
  Box<dynamic>? _settings;

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ExpenseAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BudgetAdapter());
    }
    _expenses = await Hive.openBox<Expense>(_expensesBox);
    _budgets = await Hive.openBox<Budget>(_budgetsBox);
    _settings = await Hive.openBox<dynamic>(_settingsBox);
  }

  Box<Expense> get expensesBox {
    if (_expenses == null) throw StateError('Repository not initialized');
    return _expenses!;
  }

  Box<Budget> get budgetsBox {
    if (_budgets == null) throw StateError('Repository not initialized');
    return _budgets!;
  }

  List<Expense> getAllExpenses() => expensesBox.values.toList();

  Future<void> addExpense(Expense expense) => expensesBox.add(expense);

  Future<void> updateExpense(Expense expense) => expense.save();

  Future<void> deleteExpense(Expense expense) => expense.delete();

  List<Budget> getAllBudgets() => budgetsBox.values.toList();

  Future<void> setBudget(Budget budget) async {
    final keys = budgetsBox.keys.toList();
    for (final key in keys) {
      final b = budgetsBox.get(key);
      if (b != null && b.categoryName == budget.categoryName) {
        await budgetsBox.put(key, budget);
        return;
      }
    }
    await budgetsBox.add(budget);
  }

  Future<void> removeBudget(Budget budget) => budget.delete();

  Budget? getBudgetForCategory(String categoryName) {
    try {
      return budgetsBox.values.firstWhere(
        (b) => b.categoryName == categoryName,
      );
    } catch (_) {
      return null;
    }
  }

  String get currencyCode =>
      _settings?.get(_keyCurrency) as String? ?? 'EGP';

  Future<void> setCurrencyCode(String code) async {
    await _settings?.put(_keyCurrency, code);
  }

  String? get localeCode => _settings?.get(_keyLocale) as String?;

  Future<void> setLocaleCode(String? code) async {
    if (code == null) {
      await _settings?.delete(_keyLocale);
    } else {
      await _settings?.put(_keyLocale, code);
    }
  }

  String get themeModeName =>
      _settings?.get(_keyThemeMode) as String? ?? 'system';

  Future<void> setThemeModeName(String value) async {
    await _settings?.put(_keyThemeMode, value);
  }
}
