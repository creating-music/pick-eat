import 'dart:math';

import '../models/menu.dart';
import '../repositories/menu_repository.dart';

/// 메뉴 선택 전략을 정의하는 인터페이스
abstract class MenuSelectionStrategy {
  Future<Menu> selectMenu(List<Menu> menus);
}

/// 완전 랜덤 선택 전략
class RandomSelectionStrategy implements MenuSelectionStrategy {
  @override
  Future<Menu> selectMenu(List<Menu> menus) async {
    final random = Random();
    return menus[random.nextInt(menus.length)];
  }
}

/// 메뉴 선택 서비스
class MenuSelectionService {
  final MenuRepository _menuRepository;
  MenuSelectionStrategy _selectionStrategy;

  MenuSelectionService({
    required MenuRepository menuRepository,
    MenuSelectionStrategy? selectionStrategy,
  }) : _menuRepository = menuRepository,
       _selectionStrategy = selectionStrategy ?? RandomSelectionStrategy();

  /// 선택 전략 변경
  void setSelectionStrategy(MenuSelectionStrategy strategy) {
    _selectionStrategy = strategy;
  }

  /// 선택 전략에 따라 메뉴 선택
  Future<Menu> selectMenu() async {
    final menus = await _menuRepository.getMenus();
    return _selectionStrategy.selectMenu(menus);
  }
}
