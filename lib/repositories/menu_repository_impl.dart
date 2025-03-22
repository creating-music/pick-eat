import '../models/category.dart';
import '../models/menu.dart';
import 'menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final List<Menu> _menus = [
    Menu(id: '1', name: '김치찌개', category: Category.korean),
    Menu(id: '2', name: '짜장면', category: Category.chinese),
    Menu(id: '3', name: '초밥', category: Category.japanese),
    Menu(id: '4', name: '파스타', category: Category.western),
    Menu(id: '5', name: '햄버거', category: Category.fastFood),
    Menu(id: '6', name: '비빔밥', category: Category.korean),
    Menu(id: '7', name: '탕수육', category: Category.chinese),
    Menu(id: '8', name: '라멘', category: Category.japanese),
    Menu(id: '9', name: '피자', category: Category.western),
    Menu(id: '10', name: '샐러드', category: Category.others),
  ];

  @override
  Future<List<Menu>> getMenus() async {
    return _menus;
  }
}
