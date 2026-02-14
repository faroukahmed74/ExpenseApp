import 'package:flutter/material.dart';

/// Predefined expense categories with display info.
enum ExpenseCategory {
  food('Food', Icons.restaurant, Color(0xFFE57373)),
  transport('Transport', Icons.directions_car, Color(0xFF64B5F6)),
  bills('Bills', Icons.receipt_long, Color(0xFF81C784)),
  shopping('Shopping', Icons.shopping_bag, Color(0xFFFFB74D)),
  entertainment('Entertainment', Icons.movie, Color(0xFFBA68C8)),
  health('Health', Icons.favorite, Color(0xFF4DD0E1)),
  other('Other', Icons.category, Color(0xFF90A4AE));

  const ExpenseCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;

  static ExpenseCategory fromName(String name) {
    return ExpenseCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => ExpenseCategory.other,
    );
  }
}
