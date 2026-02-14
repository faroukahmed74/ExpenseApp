import 'package:hive/hive.dart';

import 'category.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  double amount;

  @HiveField(1)
  String categoryName;

  @HiveField(2)
  String note;

  @HiveField(3)
  DateTime date;

  Expense({
    required this.amount,
    required this.categoryName,
    this.note = '',
    required this.date,
  });

  ExpenseCategory get category => ExpenseCategory.fromName(categoryName);

  Expense copyWith({
    double? amount,
    String? categoryName,
    String? note,
    DateTime? date,
  }) {
    return Expense(
      amount: amount ?? this.amount,
      categoryName: categoryName ?? this.categoryName,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 0;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      amount: fields[0] as double,
      categoryName: fields[1] as String,
      note: fields[2] as String? ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(fields[3] as int),
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.categoryName)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.date.millisecondsSinceEpoch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
