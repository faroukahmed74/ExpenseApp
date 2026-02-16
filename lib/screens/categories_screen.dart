import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../providers/expense_provider.dart';
import '../utils/localization_utils.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  static const String routeName = '/categories';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.categories)),
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final list = provider.categories;
            if (list.isEmpty) {
              return Center(
                child: Text(
                  l10n.noCategoriesYet,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final cat = list[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: cat.color.withValues(alpha: 0.2),
                      child: Icon(cat.icon, color: cat.color),
                    ),
                    title: Text(categoryLabel(context, cat)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _showCategoryDialog(
                            context,
                            provider,
                            existing: cat,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () => _confirmDeleteCategory(context, provider, cat),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, context.read<ExpenseProvider>()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCategoryDialog(
    BuildContext context,
    ExpenseProvider provider, {
    Category? existing,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final nameEnController = TextEditingController(text: existing?.nameEn ?? '');
    final nameArController = TextEditingController(text: existing?.nameAr ?? '');
    int iconIndex = existing?.iconIndex ?? 6;
    int colorValue = existing?.colorValue ?? 0xFF90A4AE;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: Text(existing != null ? l10n.editCategory : l10n.addCategory),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameEnController,
                    decoration: InputDecoration(
                      labelText: l10n.categoryNameEn,
                      hintText: 'e.g. Food',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameArController,
                    decoration: InputDecoration(
                      labelText: l10n.categoryNameAr,
                      hintText: 'مثال: طعام',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.icon,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(Category.iconOptions.length, (i) {
                      final selected = i == iconIndex;
                      return InkWell(
                        onTap: () => setState(() => iconIndex = i),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Category.iconOptions[i],
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.color,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: Category.colorOptions.asMap().entries.map((e) {
                      final clr = e.value;
                      final selected = clr.toARGB32() == colorValue;
                      return InkWell(
                        onTap: () => setState(() => colorValue = clr.toARGB32()),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: clr,
                            shape: BoxShape.circle,
                            border: selected
                                ? Border.all(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    width: 3,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () async {
                  final nameEn = nameEnController.text.trim();
                  final nameAr = nameArController.text.trim();
                  if (existing != null) {
                    await provider.updateCategory(Category(
                      id: existing.id,
                      nameEn: nameEn.isEmpty ? existing.nameEn : nameEn,
                      nameAr: nameAr.isEmpty ? existing.nameAr : nameAr,
                      iconIndex: iconIndex,
                      colorValue: colorValue,
                    ));
                  } else {
                    await provider.addCategory(
                      nameEn: nameEn,
                      nameAr: nameAr,
                      iconIndex: iconIndex,
                      colorValue: colorValue,
                    );
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Text(l10n.save),
              ),
            ],
          );
        },
      ),
    );
    nameEnController.dispose();
    nameArController.dispose();
  }

  Future<void> _confirmDeleteCategory(
    BuildContext context,
    ExpenseProvider provider,
    Category cat,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final count = provider.categories.length;
    if (count <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.keepAtLeastOneCategory)),
      );
      return;
    }
    final deleted = await provider.deleteCategory(cat);
    if (context.mounted) {
      if (deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.categoryDeleted)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.cannotDeleteCategoryInUse)),
        );
      }
    }
  }
}
