// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تتبع المصروفات';

  @override
  String get spentThisMonth => 'المصروف هذا الشهر';

  @override
  String get quickByCategory => 'سريع حسب الفئة';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get transactions => 'المعاملات';

  @override
  String get noExpensesYet => 'لا مصروفات بعد';

  @override
  String get tapToAddOne => 'اضغط + للإضافة';

  @override
  String get total => 'المجموع';

  @override
  String get delete => 'حذف';

  @override
  String get deleteExpenseTitle => 'حذف المصروف؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get noDataYet => 'لا توجد بيانات بعد';

  @override
  String get noSpendingToShow => 'لا مصروفات لعرضها';

  @override
  String get totalSpentAllTime => 'إجمالي المصروفات (كل الوقت)';

  @override
  String get byCategory => 'حسب الفئة';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get budgets => 'الميزانيات';

  @override
  String get budgetsHint =>
      'حدد حداً شهرياً لكل فئة. سترى المتبقي في الصفحة الرئيسية.';

  @override
  String get noLimitSet => 'لم يُحدد حد';

  @override
  String budgetFor(String category) {
    return 'ميزانية $category';
  }

  @override
  String monthlyLimit(String symbol) {
    return 'الحد الشهري ($symbol)';
  }

  @override
  String get remove => 'إزالة';

  @override
  String get save => 'حفظ';

  @override
  String get editExpense => 'تعديل مصروف';

  @override
  String get amount => 'المبلغ';

  @override
  String get enterAmount => 'أدخل المبلغ';

  @override
  String get enterPositiveAmount => 'أدخل مبلغاً موجباً';

  @override
  String get category => 'الفئة';

  @override
  String get date => 'التاريخ';

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get currency => 'العملة';

  @override
  String get filterByCategory => 'تصفية حسب الفئة';

  @override
  String get byDateRange => 'حسب فترة زمنية';

  @override
  String get left => 'متبقي';

  @override
  String spentOf(String spent, String limit, String remaining) {
    return 'مصروف $spent من $limit · $remaining متبقي';
  }

  @override
  String get categoryFood => 'طعام';

  @override
  String get categoryTransport => 'مواصلات';

  @override
  String get categoryBills => 'فواتير';

  @override
  String get categoryShopping => 'تسوق';

  @override
  String get categoryEntertainment => 'ترفيه';

  @override
  String get categoryHealth => 'صحة';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get currencyEgp => 'جنيه مصري';

  @override
  String get currencyUsd => 'دولار أمريكي';

  @override
  String get currencyEur => 'يورو';

  @override
  String get currencyGbp => 'جنيه إسترليني';

  @override
  String get currencySar => 'ريال سعودي';

  @override
  String get currencyAed => 'درهم إماراتي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get developedBy => 'تطوير بواسطه احمد فاروق';

  @override
  String get version => 'الإصدار';

  @override
  String get categories => 'الفئات';

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get editCategory => 'تعديل الفئة';

  @override
  String get categoryNameEn => 'الاسم (إنجليزي)';

  @override
  String get categoryNameAr => 'الاسم (عربي)';

  @override
  String get icon => 'الأيقونة';

  @override
  String get color => 'اللون';

  @override
  String get noCategoriesYet => 'لا توجد فئات بعد';

  @override
  String get categoryDeleted => 'تم حذف الفئة';

  @override
  String get cannotDeleteCategoryInUse =>
      'لا يمكن الحذف: توجد مصروفات بهذه الفئة';

  @override
  String get keepAtLeastOneCategory => 'يجب الإبقاء على فئة واحدة على الأقل';
}
