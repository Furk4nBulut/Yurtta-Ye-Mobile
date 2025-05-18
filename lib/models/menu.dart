import 'package:yurttaye_mobile/models/menu_item.dart';

class Menu {
  final int id;
  final int cityId;
  final String mealType;
  final DateTime date;
  final String energy;
  final List<MenuItem> items;

  Menu({
    required this.id,
    required this.cityId,
    required this.mealType,
    required this.date,
    required this.energy,
    required this.items,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] as int,
      cityId: json['cityId'] as int,
      mealType: json['mealType'] as String,
      date: DateTime.parse(json['date'] as String),
      energy: json['energy'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}