import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/currency.dart';
import '../providers/expense_provider.dart';

/// Shows a dialog to pick the app currency. Call from a currency icon button.
Future<void> showCurrencyPicker(BuildContext context) async {
  final provider = context.read<ExpenseProvider>();
  final selected = provider.currency;

  final picked = await showDialog<AppCurrency>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.attach_money),
          SizedBox(width: 8),
          Text('Currency'),
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
              title: Text(c.name),
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
