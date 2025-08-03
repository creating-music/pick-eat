import 'category.dart';

class Menu {
  final String id;
  final String name;
  final Category category;
  final String? imageUrl;

  Menu({
    required this.id, 
    required this.name, 
    required this.category,
    this.imageUrl,
  });
}
