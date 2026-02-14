import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/budget.dart';
import '../models/category.dart';
import '../providers/expense_provider.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});
  static const String routeName = '/budgets';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final format = provider.currencyFormat;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
              Text(
                'Set a monthly limit per category. You\'ll see how much is left on the home screen.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
              const SizedBox(height: 24),
              ...ExpenseCategory.values.map((cat) {
                final limit = provider.budgetLimitForCategory(cat);
                final spent = provider.spentForCategory(cat);
                final remaining = limit != null ? limit - spent : null;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cat.color.withValues(alpha: 0.2),
                      child: Icon(cat.icon, color: cat.color),
                    ),
                    title: Text(cat.label),
                    subtitle: limit != null
                        ? Text(
                            'Spent ${format.format(spent)} of ${format.format(limit)} · ${format.format(remaining ?? 0)} left',
                            style: TextStyle(
                              color: remaining != null && remaining < 0
                                  ? Theme.of(context).colorScheme.error
                                  : null,
                            ),
                          )
                        : const Text('No limit set'),
                    trailing: limit != null
                        ? IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showSetBudgetDialog(
                              context,
                              provider,
                              cat,
                              limit,
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () =>
                                _showSetBudgetDialog(context, provider, cat, null),
                          ),
                  ),
                );
              }),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showSetBudgetDialog(
    BuildContext context,
    ExpenseProvider provider,
    ExpenseCategory category,
    double? currentLimit,
  ) async {
    final controller = TextEditingController(
      text: currentLimit?.toStringAsFixed(2) ?? '',
    );
    final symbol = provider.currency.symbol;
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Budget for ${category.label}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Monthly limit ($symbol)',
            prefixText: '$symbol ',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          if (currentLimit != null)
            TextButton(
              onPressed: () async {
                final b = provider.budgets
                    .where((x) => x.categoryName == category.name)
                    .firstOrNull;
                if (b != null) await provider.removeBudget(b);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(
                'Remove',
                style: TextStyle(color: Theme.of(ctx).colorScheme.error),
              ),
            ),
          FilledButton(
            onPressed: () {
              final v = double.tryParse(controller.text);
              if (v != null && v > 0) Navigator.pop(ctx, v);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && result > 0) {
      await provider.setBudget(Budget(
        categoryName: category.name,
        limit: result,
      ));
    }
  }
}
