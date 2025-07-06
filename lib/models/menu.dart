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

  // Kahvaltı menüsü getter'ı
  List<String> get breakfast {
    return items
        .where((item) => item.category.toLowerCase().contains('kahvaltı') ||
                        item.category.toLowerCase().contains('breakfast'))
        .map((item) => item.name)
        .toList();
  }

  // Akşam yemeği menüsü getter'ı
  List<String> get dinner {
    return items
        .where((item) => item.category.toLowerCase().contains('akşam') ||
                        item.category.toLowerCase().contains('dinner') ||
                        item.category.toLowerCase().contains('ana yemek'))
        .map((item) => item.name)
        .toList();
  }

  factory Menu.fromJson(Map<String, dynamic> json) {
    try {
      final items = (json['items'] as List<dynamic>?)?.map((item) {
        if (item is Map<String, dynamic>) {
          return MenuItem.fromJson(item);
        }
        throw FormatException('Invalid item format: $item');
      }).toList() ?? [];

      return Menu(
        id: json['id'] as int? ?? 0,
        cityId: json['cityId'] as int? ?? 0,
        mealType: json['mealType'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        energy: json['energy'] as String? ?? '',
        items: items,
      );
    } catch (e) {
      print('Error parsing Menu JSON: $e, JSON: $json');
      return Menu(
        id: 0,
        cityId: 0,
        mealType: '',
        date: DateTime.now(),
        energy: '',
        items: [],
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'cityId': cityId,
    'mealType': mealType,
    'date': date.toIso8601String(),
    'energy': energy,
    'items': items.map((item) => {
      'category': item.category,
      'name': item.name,
      'gram': item.gram,
    }).toList(),
  };
}