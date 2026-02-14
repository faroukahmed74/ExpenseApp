import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../data/expense_repository.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  ExpenseProvider(this._repo);

  final ExpenseRepository _repo;

  List<Expense> _expenses = [];
  List<Budget> _budgets = [];
  ExpenseCategory? _categoryFilter;
  DateTime? _startDate;
  DateTime? _endDate;
  AppCurrency _currency = AppCurrency.egp;

  List<Expense> get expenses => _expenses;
  List<Budget> get budgets => _budgets;
  ExpenseCategory? get categoryFilter => _categoryFilter;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  AppCurrency get currency => _currency;

  NumberFormat get currencyFormat => _currency.formatter;

  Future<void> setCurrency(AppCurrency value) async {
    _currency = value;
    await _repo.setCurrencyCode(value.code);
    notifyListeners();
  }

  List<Expense> get filteredExpenses {
    var list = _expenses.toList();
    if (_categoryFilter != null) {
      list = list.where((e) => e.categoryName == _categoryFilter!.name).toList();
    }
    if (_startDate != null) {
      list = list.where((e) => !e.date.isBefore(_startDate!)).toList();
    }
    if (_endDate != null) {
      final end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
      list = list.where((e) => !e.date.isAfter(end)).toList();
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  double get totalSpentThisMonth {
    final now = DateTime.now();
    return _expenses
        .where((e) =>
            e.date.year == now.year && e.date.month == now.month)
        .fold<double>(0, (sum, e) => sum + e.amount);
  }

  double get totalSpentFiltered {
    return filteredExpenses.fold<double>(0, (sum, e) => sum + e.amount);
  }

  Map<ExpenseCategory, double> get spendingByCategory {
    final map = <ExpenseCategory, double>{};
    for (final e in _expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  Map<ExpenseCategory, double> spendingByCategoryInRange(DateTime start, DateTime end) {
    final map = <ExpenseCategory, double>{};
    for (final e in _expenses) {
      if (!e.date.isBefore(start) && !e.date.isAfter(end)) {
        map[e.category] = (map[e.category] ?? 0) + e.amount;
      }
    }
    return map;
  }

  double spentForCategory(ExpenseCategory category) {
    return _expenses
        .where((e) => e.categoryName == category.name)
        .fold<double>(0, (sum, e) => sum + e.amount);
  }

  double? budgetLimitForCategory(ExpenseCategory category) {
    final b = _repo.getBudgetForCategory(category.name);
    return b?.limit;
  }

  double? remainingBudget(ExpenseCategory category) {
    final limit = budgetLimitForCategory(category);
    if (limit == null) return null;
    return limit - spentForCategory(category);
  }

  Future<void> load() async {
    _expenses = _repo.getAllExpenses();
    _budgets = _repo.getAllBudgets();
    _currency = AppCurrency.fromCode(_repo.currencyCode);
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _repo.addExpense(expense);
    await load();
  }

  Future<void> updateExpense(Expense expense) async {
    await _repo.updateExpense(expense);
    await load();
  }

  Future<void> deleteExpense(Expense expense) async {
    await _repo.deleteExpense(expense);
    await load();
  }

  Future<void> setBudget(Budget budget) async {
    await _repo.setBudget(budget);
    await load();
  }

  Future<void> removeBudget(Budget budget) async {
    await _repo.removeBudget(budget);
    await load();
  }

  void setCategoryFilter(ExpenseCategory? value) {
    _categoryFilter = value;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void clearFilters() {
    _categoryFilter = null;
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }
}
