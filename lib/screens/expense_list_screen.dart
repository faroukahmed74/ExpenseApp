import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import 'add_edit_expense_screen.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});
  static const String routeName = '/list';

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  ExpenseCategory? _categoryFilter;
  DateTime? _start;
  DateTime? _end;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          if (_categoryFilter != null || _start != null || _end != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              onPressed: () {
                context.read<ExpenseProvider>().clearFilters();
                setState(() {
                  _categoryFilter = null;
                  _start = null;
                  _end = null;
                });
              },
            ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'category') {
                final cat = await showDialog<ExpenseCategory>(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: const Text('Filter by category'),
                    children: [
                      ...ExpenseCategory.values.map((c) => SimpleDialogOption(
                            onPressed: () => Navigator.pop(ctx, c),
                            child: Row(
                              children: [
                                Icon(c.icon, color: c.color),
                                const SizedBox(width: 8),
                                Text(c.label),
                              ],
                            ),
                          )),
                    ],
                  ),
                );
                if (cat != null && context.mounted) {
                  context.read<ExpenseProvider>().setCategoryFilter(cat);
                  setState(() => _categoryFilter = cat);
                }
              } else if (value == 'date') {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (!context.mounted || range == null) return;
                context.read<ExpenseProvider>().setDateRange(range.start, range.end);
                setState(() {
                  _start = range.start;
                  _end = range.end;
                });
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'category', child: Text('By category')),
              const PopupMenuItem(value: 'date', child: Text('By date range')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final list = provider.filteredExpenses;
            final format = provider.currencyFormat;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No expenses yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add one',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${format.format(provider.totalSpentFiltered)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final e = list[index];
                      return _ExpenseTile(
                        expense: e,
                        format: format,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AddEditExpenseScreen.routeName,
                          arguments: AddEditExpenseArgs(expense: e),
                        ),
                        onDelete: () => _confirmDelete(context, provider, e),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          AddEditExpenseScreen.routeName,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ExpenseProvider provider,
    Expense expense,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete expense?'),
        content: Text(
          '${expense.category.label} · ${provider.currencyFormat.format(expense.amount)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await provider.deleteExpense(expense);
    }
  }
}

class _ExpenseTile extends StatelessWidget {
  const _ExpenseTile({
    required this.expense,
    required this.format,
    required this.onTap,
    required this.onDelete,
  });

  final Expense expense;
  final NumberFormat format;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cat = expense.category;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cat.color.withValues(alpha: 0.2),
          child: Icon(cat.icon, color: cat.color),
        ),
        title: Text(cat.label),
        subtitle: Text(
          '${DateFormat.yMMMd().format(expense.date)}${expense.note.isNotEmpty ? ' · ${expense.note}' : ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              format.format(expense.amount),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'delete') onDelete();
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
