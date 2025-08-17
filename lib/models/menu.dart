import 'category.dart';
import 'preference.dart';
import 'dislike_category.dart';

class Menu {
  final String id;
  final String name;
  final Category category;
  final String? imageUrl;
  final PreferenceCategory preference; // 선호도
  final List<DislikeCategory> dislikes; // 불호도 리스트

  Menu({
    required this.id,
    required this.name,
    required this.category,
    this.imageUrl,
    required this.preference,
    required this.dislikes,
  });
}
