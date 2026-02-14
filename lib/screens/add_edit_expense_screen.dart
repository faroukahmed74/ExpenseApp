import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddEditExpenseArgs {
  final Expense? expense;
  final ExpenseCategory? category;

  AddEditExpenseArgs({this.expense, this.category});
}

class AddEditExpenseScreen extends StatefulWidget {
  const AddEditExpenseScreen({super.key});
  static const String routeName = '/add';

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  ExpenseCategory _category = ExpenseCategory.other;
  DateTime _date = DateTime.now();
  bool _isEdit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as AddEditExpenseArgs?;
    if (args != null && args.expense != null && !_isEdit) {
      _isEdit = true;
      final e = args.expense!;
      _amountController.text = e.amount.toStringAsFixed(2);
      _noteController.text = e.note;
      _category = e.category;
      _date = e.date;
    } else if (args?.category != null && _amountController.text.isEmpty) {
      _category = args!.category!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final provider = context.read<ExpenseProvider>();
    if (_isEdit) {
      final args = ModalRoute.of(context)?.settings.arguments as AddEditExpenseArgs?;
      final existing = args?.expense;
      if (existing != null) {
        await provider.updateExpense(existing.copyWith(
          amount: amount,
          categoryName: _category.name,
          note: _noteController.text.trim(),
          date: _date,
        ));
      }
    } else {
      await provider.addExpense(Expense(
        amount: amount,
        categoryName: _category.name,
        note: _noteController.text.trim(),
        date: _date,
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final currencySymbol = provider.currency.symbol;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit expense' : 'Add expense'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '$currencySymbol ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter amount';
                final n = double.tryParse(v);
                if (n == null || n <= 0) return 'Enter a positive amount';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ExpenseCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ExpenseCategory.values
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Icon(c.icon, color: c.color, size: 20),
                            const SizedBox(width: 8),
                            Text(c.label),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Date'),
              subtitle: Text(DateFormat.yMMMd().format(_date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(_isEdit ? 'Save' : 'Add expense'),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
