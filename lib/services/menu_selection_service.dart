import 'dart:math';

import '../models/menu.dart';
import '../models/category.dart';
import '../models/dislike_category.dart';
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

/// 선호도/불호도를 반영하는 선택 전략
class PreferenceBasedSelectionStrategy implements MenuSelectionStrategy {
  final Set<Category> preferredCategories;
  final Set<DislikeCategory> dislikedCategories;

  PreferenceBasedSelectionStrategy({
    required this.preferredCategories,
    required this.dislikedCategories,
  });

  @override
  Future<Menu> selectMenu(List<Menu> menus) async {
    print('=== 메뉴 필터링 시작 ===');
    print('전체 메뉴 수: ${menus.length}');
    print(
      '사용자 불호도: ${dislikedCategories.map((d) => d.displayName).join(', ')}',
    );
    print('사용자 선호도: ${preferredCategories.map((p) => p.name).join(', ')}');

    // 1. 불호도에 맞지 않는 메뉴 필터링 (불호도 속성이 하나라도 있으면 제외)
    List<Menu> filteredMenus =
        menus.where((menu) {
          bool hasDislikedAttribute = menu.dislikes.any(
            (dislike) => dislikedCategories.contains(dislike),
          );

          if (hasDislikedAttribute && dislikedCategories.isNotEmpty) {
            print(
              '❌ 제외: ${menu.name} - 불호도 속성: ${menu.dislikes.where((d) => dislikedCategories.contains(d)).map((d) => d.displayName).join(', ')}',
            );
          }

          return !hasDislikedAttribute;
        }).toList();

    print('불호도 필터링 후 메뉴 수: ${filteredMenus.length}');
    if (filteredMenus.isNotEmpty) {
      print('남은 메뉴들: ${filteredMenus.map((m) => m.name).join(', ')}');
    }

    // 2. 필터링 후 메뉴가 없으면 전체 메뉴에서 선택
    if (filteredMenus.isEmpty) {
      print('⚠️ 필터링된 메뉴가 없음 - 전체 메뉴에서 선택');
      filteredMenus = menus;
    }

    // 3. 선호도가 설정되어 있으면 우선순위 적용
    if (preferredCategories.isNotEmpty) {
      List<Menu> preferredMenus =
          filteredMenus.where((menu) {
            return preferredCategories.contains(menu.category);
          }).toList();

      // 선호하는 카테고리의 메뉴가 있으면 그 중에서 선택
      if (preferredMenus.isNotEmpty) {
        print('선호도 필터링 후 메뉴 수: ${preferredMenus.length}');
        print('선호하는 메뉴들: ${preferredMenus.map((m) => m.name).join(', ')}');
        filteredMenus = preferredMenus;
      }
    }

    // 4. 최종 필터링된 메뉴 중에서 랜덤 선택
    final random = Random();
    final selectedMenu = filteredMenus[random.nextInt(filteredMenus.length)];
    print('✅ 최종 선택: ${selectedMenu.name}');
    print(
      '메뉴 불호도 속성: ${selectedMenu.dislikes.map((d) => d.displayName).join(', ')}',
    );
    print('========================\n');

    return selectedMenu;
  }
}

/// 메뉴 선택 서비스
class MenuSelectionService {
  final MenuRepository _menuRepository;
  MenuSelectionStrategy _selectionStrategy;

  // 사용자 선호도/불호도
  Set<Category> _preferredCategories = <Category>{};
  Set<DislikeCategory> _dislikedCategories = <DislikeCategory>{};

  MenuSelectionService({
    required MenuRepository menuRepository,
    MenuSelectionStrategy? selectionStrategy,
  }) : _menuRepository = menuRepository,
       _selectionStrategy = selectionStrategy ?? RandomSelectionStrategy();

  /// 선택 전략 변경
  void setSelectionStrategy(MenuSelectionStrategy strategy) {
    _selectionStrategy = strategy;
  }

  /// 선호도 업데이트
  void updatePreferences({
    Set<Category>? preferredCategories,
    Set<DislikeCategory>? dislikedCategories,
  }) {
    if (preferredCategories != null) {
      _preferredCategories = preferredCategories;
    }
    if (dislikedCategories != null) {
      _dislikedCategories = dislikedCategories;
    }

    // 선호도가 설정되어 있으면 PreferenceBasedSelectionStrategy 사용
    if (_preferredCategories.isNotEmpty || _dislikedCategories.isNotEmpty) {
      _selectionStrategy = PreferenceBasedSelectionStrategy(
        preferredCategories: _preferredCategories,
        dislikedCategories: _dislikedCategories,
      );
    } else {
      // 선호도가 없으면 랜덤 선택
      _selectionStrategy = RandomSelectionStrategy();
    }
  }

  /// 선택 전략에 따라 메뉴 선택
  Future<Menu> selectMenu() async {
    final menus = await _menuRepository.getMenus();
    return _selectionStrategy.selectMenu(menus);
  }
}
