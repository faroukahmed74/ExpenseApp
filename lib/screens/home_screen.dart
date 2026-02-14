import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/expense_provider.dart';
import '../widgets/currency_picker.dart';
import 'add_edit_expense_screen.dart';
import 'budgets_screen.dart';
import 'expense_list_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icon/app_icon.png',
                height: 32,
                width: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Text('Expense Tracker'),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.currency_exchange),
            tooltip: 'Currency',
            onPressed: () => showCurrencyPicker(context),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () =>
                Navigator.pushNamed(context, ExpenseListScreen.routeName),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () =>
                Navigator.pushNamed(context, StatsScreen.routeName),
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () =>
                Navigator.pushNamed(context, BudgetsScreen.routeName),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final total = provider.totalSpentThisMonth;
            final format = provider.currencyFormat;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Spent this month',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          format.format(total),
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Quick by category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ...ExpenseCategory.values.map((cat) {
                  final spent = provider.spentForCategory(cat);
                  final limit = provider.budgetLimitForCategory(cat);
                  final hasBudget = limit != null;
                  final remaining = hasBudget ? (limit - spent) : null;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: cat.color.withValues(alpha: 0.2),
                        child: Icon(cat.icon, color: cat.color),
                      ),
                      title: Text(cat.label),
                      subtitle: hasBudget && remaining != null
                          ? Text(
                              '${format.format(spent)} / ${format.format(limit)} · ${format.format(remaining)} left',
                              style: TextStyle(
                                color: remaining < 0
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                              ),
                            )
                          : Text(format.format(spent)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AddEditExpenseScreen.routeName,
                        arguments: AddEditExpenseArgs(category: cat),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(
          context,
          AddEditExpenseScreen.routeName,
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
    );
  }
}
