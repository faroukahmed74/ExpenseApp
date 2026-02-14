import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';

String categoryLabel(BuildContext context, ExpenseCategory category) {
  final l10n = AppLocalizations.of(context)!;
  return switch (category) {
    ExpenseCategory.food => l10n.categoryFood,
    ExpenseCategory.transport => l10n.categoryTransport,
    ExpenseCategory.bills => l10n.categoryBills,
    ExpenseCategory.shopping => l10n.categoryShopping,
    ExpenseCategory.entertainment => l10n.categoryEntertainment,
    ExpenseCategory.health => l10n.categoryHealth,
    ExpenseCategory.other => l10n.categoryOther,
  };
}

String currencyLocalizedName(BuildContext context, String currencyCode) {
  final l10n = AppLocalizations.of(context)!;
  return switch (currencyCode) {
    'EGP' => l10n.currencyEgp,
    'USD' => l10n.currencyUsd,
    'EUR' => l10n.currencyEur,
    'GBP' => l10n.currencyGbp,
    'SAR' => l10n.currencySar,
    'AED' => l10n.currencyAed,
    _ => currencyCode,
  };
}
