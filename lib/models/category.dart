import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// User-defined or default expense category with optional English and Arabic names.
@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nameEn;

  @HiveField(2)
  String nameAr;

  @HiveField(3)
  int iconIndex;

  @HiveField(4)
  int colorValue;

  Category({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.iconIndex,
    required this.colorValue,
  });

  IconData get icon => _iconOptions[iconIndex.clamp(0, _iconOptions.length - 1)];
  Color get color => Color(colorValue);

  static const List<IconData> _iconOptions = [
    Icons.restaurant,
    Icons.directions_car,
    Icons.receipt_long,
    Icons.shopping_bag,
    Icons.movie,
    Icons.favorite,
    Icons.category,
    Icons.home,
    Icons.flight,
    Icons.school,
    Icons.sports_esports,
    Icons.pets,
    Icons.local_gas_station,
    Icons.phone_android,
    Icons.wifi,
  ];

  static List<IconData> get iconOptions => _iconOptions;

  static const List<Color> colorOptions = [
    Color(0xFFE57373),
    Color(0xFF64B5F6),
    Color(0xFF81C784),
    Color(0xFFFFB74D),
    Color(0xFFBA68C8),
    Color(0xFF4DD0E1),
    Color(0xFF90A4AE),
    Color(0xFFF06292),
    Color(0xFF7986CB),
    Color(0xFF4DB6AC),
  ];
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      id: fields[0] as String,
      nameEn: fields[1] as String,
      nameAr: fields[2] as String,
      iconIndex: fields[3] as int,
      colorValue: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameEn)
      ..writeByte(2)
      ..write(obj.nameAr)
      ..writeByte(3)
      ..write(obj.iconIndex)
      ..writeByte(4)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
