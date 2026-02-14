import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/currency.dart';
import '../providers/expense_provider.dart';
import '../utils/localization_utils.dart';

/// Shows a dialog to pick the app currency. Call from a currency icon button.
Future<void> showCurrencyPicker(BuildContext context) async {
  final provider = context.read<ExpenseProvider>();
  final selected = provider.currency;
  final l10n = AppLocalizations.of(context)!;

  final picked = await showDialog<AppCurrency>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.attach_money),
          const SizedBox(width: 8),
          Text(l10n.currency),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppCurrency.values.map((c) {
            final isSelected = c == selected;
            return ListTile(
              leading: Text(
                c.symbol,
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              title: Text(currencyLocalizedName(ctx, c.code)),
              subtitle: Text(c.code),
              trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
              selected: isSelected,
              onTap: () => Navigator.pop(ctx, c),
            );
          }).toList(),
        ),
      ),
    ),
  );

  if (picked != null && picked != selected) {
    await provider.setCurrency(picked);
  }
}
