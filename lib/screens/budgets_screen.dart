import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../providers/expense_provider.dart';
import '../utils/localization_utils.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});
  static const String routeName = '/budgets';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.budgets)),
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final format = provider.currencyFormat;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.budgetsHint,
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
                      title: Text(categoryLabel(context, cat)),
                      subtitle: limit != null
                          ? Text(
                              l10n.spentOf(
                                format.format(spent),
                                format.format(limit),
                                format.format(remaining ?? 0),
                              ),
                              style: TextStyle(
                                color: remaining != null && remaining < 0
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                              ),
                            )
                          : Text(l10n.noLimitSet),
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
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: currentLimit?.toStringAsFixed(2) ?? '',
    );
    final symbol = provider.currency.symbol;
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.budgetFor(categoryLabel(ctx, category))),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.monthlyLimit(symbol),
            prefixText: '$symbol ',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
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
                l10n.remove,
                style: TextStyle(color: Theme.of(ctx).colorScheme.error),
              ),
            ),
          FilledButton(
            onPressed: () {
              final v = double.tryParse(controller.text);
              if (v != null && v > 0) Navigator.pop(ctx, v);
            },
            child: Text(l10n.save),
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
