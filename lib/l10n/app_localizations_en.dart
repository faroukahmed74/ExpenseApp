// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Expense Tracker';

  @override
  String get spentThisMonth => 'Spent this month';

  @override
  String get quickByCategory => 'Quick by category';

  @override
  String get addExpense => 'Add expense';

  @override
  String get transactions => 'Transactions';

  @override
  String get noExpensesYet => 'No expenses yet';

  @override
  String get tapToAddOne => 'Tap + to add one';

  @override
  String get total => 'Total';

  @override
  String get delete => 'Delete';

  @override
  String get deleteExpenseTitle => 'Delete expense?';

  @override
  String get cancel => 'Cancel';

  @override
  String get statistics => 'Statistics';

  @override
  String get noDataYet => 'No data yet';

  @override
  String get noSpendingToShow => 'No spending to show';

  @override
  String get totalSpentAllTime => 'Total spent (all time)';

  @override
  String get byCategory => 'By category';

  @override
  String get thisMonth => 'This month';

  @override
  String get budgets => 'Budgets';

  @override
  String get budgetsHint =>
      'Set a monthly limit per category. You\'ll see how much is left on the home screen.';

  @override
  String get noLimitSet => 'No limit set';

  @override
  String budgetFor(String category) {
    return 'Budget for $category';
  }

  @override
  String monthlyLimit(String symbol) {
    return 'Monthly limit ($symbol)';
  }

  @override
  String get remove => 'Remove';

  @override
  String get save => 'Save';

  @override
  String get editExpense => 'Edit expense';

  @override
  String get amount => 'Amount';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get enterPositiveAmount => 'Enter a positive amount';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get currency => 'Currency';

  @override
  String get filterByCategory => 'Filter by category';

  @override
  String get byDateRange => 'By date range';

  @override
  String get left => 'left';

  @override
  String spentOf(String spent, String limit, String remaining) {
    return 'Spent $spent of $limit · $remaining left';
  }

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryBills => 'Bills';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryOther => 'Other';

  @override
  String get currencyEgp => 'Egyptian Pound';

  @override
  String get currencyUsd => 'US Dollar';

  @override
  String get currencyEur => 'Euro';

  @override
  String get currencyGbp => 'British Pound';

  @override
  String get currencySar => 'Saudi Riyal';

  @override
  String get currencyAed => 'UAE Dirham';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get developedBy => 'Developed by Ahmed Farouk';

  @override
  String get version => 'Version';
}
