class MenuItem {
  final String category;
  final String name;
  final String gram;

  MenuItem({
    required this.category,
    required this.name,
    required this.gram,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      category: json['category'] as String? ?? '',
      name: json['name'] as String? ?? '',
      gram: json['gram'] as String? ?? '',
    );
  }
}