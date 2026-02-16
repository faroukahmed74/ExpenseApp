import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';

String categoryLabel(BuildContext context, Category category) {
  final locale = Localizations.localeOf(context);
  return locale.languageCode == 'ar' ? category.nameAr : category.nameEn;
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
