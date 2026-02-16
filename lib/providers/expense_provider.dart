import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/expense_repository.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  ExpenseProvider(this._repo);

  final ExpenseRepository _repo;

  String? _categoryFilterId;
  DateTime? _dateStart;
  DateTime? _dateEnd;

  List<Expense> get _allExpenses => _repo.getAllExpenses();

  List<Category> get categories => _repo.getCategories();

  Category? categoryById(String id) => _repo.getCategoryById(id);

  List<Expense> get filteredExpenses {
    var list = _allExpenses;
    if (_categoryFilterId != null) {
      list = list.where((e) => e.categoryName == _categoryFilterId).toList();
    }
    if (_dateStart != null) {
      list = list.where((e) => !e.date.isBefore(_dateStart!)).toList();
    }
    if (_dateEnd != null) {
      final end = DateTime(_dateEnd!.year, _dateEnd!.month, _dateEnd!.day, 23, 59, 59);
      list = list.where((e) => !e.date.isAfter(end)).toList();
    }
    return list;
  }

  double get totalSpentFiltered =>
      filteredExpenses.fold<double>(0, (sum, e) => sum + e.amount);

  AppCurrency get currency => AppCurrency.fromCode(_repo.currencyCode);
  NumberFormat get currencyFormat => currency.formatter;

  double get totalSpentThisMonth {
    final now = DateTime.now();
    return _allExpenses
        .where((e) =>
            e.date.year == now.year && e.date.month == now.month)
        .fold<double>(0, (sum, e) => sum + e.amount);
  }

  double spentForCategoryId(String categoryId) => _allExpenses
      .where((e) => e.categoryName == categoryId)
      .fold<double>(0, (sum, e) => sum + e.amount);

  double? budgetLimitForCategoryId(String categoryId) {
    final b = _repo.getBudgetForCategory(categoryId);
    return b?.limit;
  }

  List<Budget> get budgets => _repo.getAllBudgets();

  Map<String, double> get spendingByCategoryId {
    final map = <String, double>{};
    for (final cat in categories) {
      final sum = spentForCategoryId(cat.id);
      if (sum > 0) map[cat.id] = sum;
    }
    return map;
  }

  Future<void> load() async {
    notifyListeners();
  }

  void setCategoryFilterId(String? id) {
    _categoryFilterId = id;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _dateStart = start;
    _dateEnd = end;
    notifyListeners();
  }

  void clearFilters() {
    _categoryFilterId = null;
    _dateStart = null;
    _dateEnd = null;
    notifyListeners();
  }

  Future<void> setCurrency(AppCurrency c) async {
    await _repo.setCurrencyCode(c.code);
    notifyListeners();
  }

  Future<void> setBudget(Budget b) async {
    await _repo.saveBudget(b);
    notifyListeners();
  }

  Future<void> removeBudget(Budget b) async {
    await _repo.removeBudget(b);
    notifyListeners();
  }

  Future<void> addExpense(Expense e) async {
    await _repo.addExpense(e);
    notifyListeners();
  }

  Future<void> updateExpense(Expense e) async {
    await _repo.updateExpense(e);
    notifyListeners();
  }

  Future<void> deleteExpense(Expense e) async {
    await _repo.deleteExpense(e);
    notifyListeners();
  }

  String _nextCustomCategoryId() {
    int n = 0;
    while (_repo.getCategoryById('custom_$n') != null) {
      n++;
    }
    return 'custom_$n';
  }

  Future<void> addCategory({required String nameEn, required String nameAr, int iconIndex = 6, int colorValue = 0xFF90A4AE}) async {
    final c = Category(
      id: _nextCustomCategoryId(),
      nameEn: nameEn.isEmpty ? 'Category' : nameEn,
      nameAr: nameAr.isEmpty ? 'فئة' : nameAr,
      iconIndex: iconIndex,
      colorValue: colorValue,
    );
    await _repo.addCategory(c);
    notifyListeners();
  }

  Future<void> updateCategory(Category c) async {
    await _repo.updateCategory(c);
    notifyListeners();
  }

  Future<bool> deleteCategory(Category c) async {
    if (_repo.expenseCountForCategory(c.id) > 0) return false;
    await _repo.deleteCategory(c);
    notifyListeners();
    return true;
  }
}
