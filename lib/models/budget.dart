import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Budget extends HiveObject {
  @HiveField(0)
  String categoryName;

  @HiveField(1)
  double limit;

  Budget({
    required this.categoryName,
    required this.limit,
  });

  Budget copyWith({String? categoryName, double? limit}) {
    return Budget(
      categoryName: categoryName ?? this.categoryName,
      limit: limit ?? this.limit,
    );
  }
}

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final int typeId = 1;

  @override
  Budget read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Budget(
      categoryName: fields[0] as String,
      limit: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.categoryName)
      ..writeByte(1)
      ..write(obj.limit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
