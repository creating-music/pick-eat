import '../models/menu.dart';

abstract class MenuRepository {
  Future<List<Menu>> getMenus();
}
