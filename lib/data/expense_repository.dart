import 'package:hive_flutter/hive_flutter.dart';

import '../models/budget.dart';
import '../models/category.dart';
import '../models/expense.dart';

const String _expensesBox = 'expenses';
const String _budgetsBox = 'budgets';
const String _categoriesBox = 'categories';
const String _settingsBox = 'settings';
const String _keyLocale = 'locale';
const String _keyThemeMode = 'theme_mode';
const String _keyCurrency = 'currency';
const String _keyCategoriesSeeded = 'categories_seeded';

class ExpenseRepository {
  Box<Expense>? _expensesBoxInstance;
  Box<Budget>? _budgetsBoxInstance;
  Box<Category>? _categoriesBoxInstance;
  Box<dynamic>? _settingsBoxInstance;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(BudgetAdapter());
    Hive.registerAdapter(CategoryAdapter());
    _expensesBoxInstance = await Hive.openBox<Expense>(_expensesBox);
    _budgetsBoxInstance = await Hive.openBox<Budget>(_budgetsBox);
    _categoriesBoxInstance = await Hive.openBox<Category>(_categoriesBox);
    _settingsBoxInstance = await Hive.openBox<dynamic>(_settingsBox);
    await _seedCategoriesIfNeeded();
  }

  Box<Expense> get _expenses => _expensesBoxInstance!;
  Box<Budget> get _budgets => _budgetsBoxInstance!;
  Box<Category> get _categories => _categoriesBoxInstance!;
  Box<dynamic> get _settings => _settingsBoxInstance!;

  Future<void> _seedCategoriesIfNeeded() async {
    if (_settings.get(_keyCategoriesSeeded) == true) return;
    final defaults = [
      Category(id: 'food', nameEn: 'Food', nameAr: 'طعام', iconIndex: 0, colorValue: 0xFFE57373),
      Category(id: 'transport', nameEn: 'Transport', nameAr: 'مواصلات', iconIndex: 1, colorValue: 0xFF64B5F6),
      Category(id: 'bills', nameEn: 'Bills', nameAr: 'فواتير', iconIndex: 2, colorValue: 0xFF81C784),
      Category(id: 'shopping', nameEn: 'Shopping', nameAr: 'تسوق', iconIndex: 3, colorValue: 0xFFFFB74D),
      Category(id: 'entertainment', nameEn: 'Entertainment', nameAr: 'ترفيه', iconIndex: 4, colorValue: 0xFFBA68C8),
      Category(id: 'health', nameEn: 'Health', nameAr: 'صحة', iconIndex: 5, colorValue: 0xFF4DD0E1),
      Category(id: 'other', nameEn: 'Other', nameAr: 'أخرى', iconIndex: 6, colorValue: 0xFF90A4AE),
    ];
    for (final c in defaults) {
      if (_categories.values.every((x) => x.id != c.id)) {
        await _categories.add(c);
      }
    }
    await _settings.put(_keyCategoriesSeeded, true);
  }

  List<Category> getCategories() => _categories.values.toList();

  Category? getCategoryById(String id) =>
      _categories.values.where((c) => c.id == id).firstOrNull;

  Future<void> addCategory(Category c) async {
    await _categories.add(c);
  }

  Future<void> updateCategory(Category c) async {
    await c.save();
  }

  Future<void> deleteCategory(Category c) async {
    await c.delete();
  }

  int expenseCountForCategory(String categoryId) =>
      _expenses.values.where((e) => e.categoryName == categoryId).length;

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
