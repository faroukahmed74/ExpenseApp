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

  ExpenseCategory? _categoryFilter;
  DateTime? _dateStart;
  DateTime? _dateEnd;

  List<Expense> get _allExpenses => _repo.getAllExpenses();

  List<Expense> get filteredExpenses {
    var list = _allExpenses;
    if (_categoryFilter != null) {
      list = list.where((e) => e.categoryName == _categoryFilter!.name).toList();
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

  double spentForCategory(ExpenseCategory cat) => _allExpenses
      .where((e) => e.categoryName == cat.name)
      .fold<double>(0, (sum, e) => sum + e.amount);

  double? budgetLimitForCategory(ExpenseCategory cat) {
    final b = _repo.getBudgetForCategory(cat.name);
    return b?.limit;
  }

  List<Budget> get budgets => _repo.getAllBudgets();

  Map<ExpenseCategory, double> get spendingByCategory {
    final map = <ExpenseCategory, double>{};
    for (final cat in ExpenseCategory.values) {
      final sum = spentForCategory(cat);
      if (sum > 0) map[cat] = sum;
    }
    return map;
  }

  Future<void> load() async {
    notifyListeners();
  }

  void setCategoryFilter(ExpenseCategory? cat) {
    _categoryFilter = cat;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _dateStart = start;
    _dateEnd = end;
    notifyListeners();
  }

  void clearFilters() {
    _categoryFilter = null;
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
}
