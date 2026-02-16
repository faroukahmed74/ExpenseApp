import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/expense_provider.dart';
import '../utils/localization_utils.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
  static const String routeName = '/stats';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statistics)),
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final byCategory = provider.spendingByCategoryId;
            final total = byCategory.values.fold<double>(0, (a, b) => a + b);
            final format = provider.currencyFormat;

            if (byCategory.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pie_chart, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noDataYet,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            }

            final entries = byCategory.entries
                .where((e) => e.value > 0)
                .map((e) {
                  final cat = provider.categoryById(e.key);
                  return MapEntry(cat, e.value);
                })
                .where((e) => e.key != null)
                .map((e) => MapEntry(e.key!, e.value))
                .toList();
            if (entries.isEmpty) {
              return Center(child: Text(l10n.noSpendingToShow));
            }

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
                            l10n.totalSpentAllTime,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            format.format(total),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                    l10n.byCategory,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: entries.asMap().entries.map((e) {
                          final cat = e.value.key;
                          final value = e.value.value;
                          final pct = total > 0 ? (value / total) : 0.0;
                          return PieChartSectionData(
                            value: value,
                            title: '${(pct * 100).toStringAsFixed(0)}%',
                            color: cat.color,
                            radius: 48,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...entries.map((e) {
                    final pct = total > 0 ? (e.value / total) : 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: e.key.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(categoryLabel(context, e.key)),
                          ),
                          Text(
                            '${format.format(e.value)} (${(pct * 100).toStringAsFixed(0)}%)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Text(
                    l10n.thisMonth,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        format.format(provider.totalSpentThisMonth),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
