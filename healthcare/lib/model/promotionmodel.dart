import 'package:healthcare/db/database_helper.dart';

class PromotionModel {
  final int id;
  final String title;
  final String description;
  final int discountPercent;
  final String clinicName;
  final String imageUrl;

  const PromotionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountPercent,
    required this.clinicName,
    required this.imageUrl,
  });

  factory PromotionModel.fromMap(Map<String, Object?> map) {
    return PromotionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      discountPercent: map['discountPercent'] as int,
      clinicName: map['clinicName'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}

Future<List<PromotionModel>> getPromotions() async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.query('Promotions');

  return rows.map((row) => PromotionModel.fromMap(row)).toList();
}
