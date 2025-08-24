import 'package:flutter/material.dart';

import '../game/lottery_game.dart';
import '../models/menu.dart';
import '../models/category.dart';
import '../models/dislike_category.dart';
import '../services/history_service.dart';
import '../services/menu_selection_service.dart';

/* 
 * 향후 개선사항:
 * 
 * 1. LotteryGame 의존성 주입으로 변경
 *    - 현재: ViewModel 내부에서 직접 생성
 *    - 개선: GameService 인터페이스 정의 후 의존성 주입으로 변경
 *    - 이유: 강한 결합 감소 및 테스트 용이성 확보
 * 
 * 3. LotteryGame과의 콜백 기반 통신 개선
 *    - 현재: onBallSelected 콜백을 통해 직접 통신
 *    - 개선: 이벤트 버스 또는 스트림 기반 통신으로 변경
 *    - 이유: 컴포넌트 간 결합도 감소
 * 
 * 4. 시간 지연 로직 추상화
 *    - 현재: startLottery()에서 게임 시작과 결과 화면 이동 사이 시간 하드코딩
 *    - 개선: 타이머 서비스 도입 또는 이벤트 기반 방식으로 변경
 *    - 이유: 테스트 용이성 향상 및 시간 관리 유연성 확보
 * 
 * 5. 뷰모델 책임 세분화
 *    - 현재: 여러 상태 관리와 뽑기 로직이 하나의 ViewModel에 집중
 *    - 개선: 필요시 더 작은 단위의 뷰모델로 분리 (예: LotteryViewModel, ResultViewModel)
 *    - 이유: 코드 응집도 향상 및 유지보수성 개선
 */

class LottoViewModel extends ChangeNotifier {
  final HistoryService _historyService;
  final MenuSelectionService _menuSelectionService;

  // 게임 인스턴스 관리
  LotteryGame? _lotteryGame;
  bool _isGameCreating = false; // 게임 생성 중 상태 추적

  bool isLotteryRunning = false;
  Menu? selectedMenu;

  // 선호도 관리
  Set<Category> _preferredCategories = <Category>{};
  Set<DislikeCategory> _dislikedCategories = <DislikeCategory>{};

  // 결과 화면 네비게이션을 위한 콜백
  Function? onGameComplete;

  LottoViewModel({
    required HistoryService historyService,
    required MenuSelectionService menuSelectionService,
  }) : _historyService = historyService,
       _menuSelectionService = menuSelectionService;

  // 선호도 getter
  Set<Category> get preferredCategories => Set.from(_preferredCategories);
  Set<DislikeCategory> get dislikedCategories => Set.from(_dislikedCategories);

  // 선호도 업데이트 메서드
  void updatePreferredCategories(Set<Category> categories) {
    debugPrint('=== 선호도 업데이트 ===');
    debugPrint('이전 선호도: ${_preferredCategories.map((c) => c.name).toList()}');
    debugPrint('새로운 선호도: ${categories.map((c) => c.name).toList()}');

    _preferredCategories = Set.from(categories);

    // MenuSelectionService에 선호도 전달
    _menuSelectionService.updatePreferences(
      preferredCategories: _preferredCategories,
      dislikedCategories: _dislikedCategories,
    );

    debugPrint('최종 선호도: ${_preferredCategories.map((c) => c.name).toList()}');
    debugPrint('최종 불호도: ${_dislikedCategories.map((c) => c.name).toList()}');
    debugPrint('===================\n');

    notifyListeners();
  }

  // 불호도 업데이트 메서드
  void updateDislikedCategories(Set<DislikeCategory> categories) {
    debugPrint('=== 불호도 업데이트 ===');
    debugPrint('이전 불호도: ${_dislikedCategories.map((c) => c.name).toList()}');
    debugPrint('새로운 불호도: ${categories.map((c) => c.name).toList()}');

    _dislikedCategories = Set.from(categories);

    // MenuSelectionService에 불호도 전달
    _menuSelectionService.updatePreferences(
      preferredCategories: _preferredCategories,
      dislikedCategories: _dislikedCategories,
    );

    debugPrint('최종 선호도: ${_preferredCategories.map((c) => c.name).toList()}');
    debugPrint('최종 불호도: ${_dislikedCategories.map((c) => c.name).toList()}');
    debugPrint('===================\n');

    notifyListeners();
  }

  // 게임 인스턴스에 대한 안전한 getter
  LotteryGame? get lotteryGame => _lotteryGame;

  // 새 게임 인스턴스 생성 메서드
  Future<LotteryGame> _createNewGameInstance() async {
    if (_isGameCreating) {
      // 생성 중이면 완료될 때까지 대기
      while (_isGameCreating) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      if (_lotteryGame != null) {
        return _lotteryGame!;
      }
    }

    _isGameCreating = true;

    try {
      final game = LotteryGame();
      game.onBallSelected = _onBallSelected;
      _lotteryGame = game;
      return game;
    } finally {
      _isGameCreating = false;
    }
  }

  Future<void> startLottery() async {
    // 기존 게임 인스턴스가 있다면 정리
    if (_lotteryGame != null) {
      _cleanupGame(_lotteryGame!);
      _lotteryGame = null;
    }

    // 상태 업데이트 먼저
    isLotteryRunning = true;
    notifyListeners();

    // 메뉴 선택 서비스를 통한 랜덤 메뉴 선택
    selectedMenu = await _menuSelectionService.selectMenu();

    // 새 게임 인스턴스 생성 후 시작
    final game = await _createNewGameInstance();

    // 상태 확인 후 게임 시작
    if (isLotteryRunning) {
      game.startLottery();
    }
  }

  void _onBallSelected() async {
    // 먼저 뽑기 완료 상태로 변경 (UI 업데이트를 위해)
    isLotteryRunning = false;
    notifyListeners();

    // 변경된 UI가 적용된 후에 비동기 작업 수행
    await Future.microtask(() {});

    // 선택된 메뉴가 있으면 히스토리에 추가
    if (selectedMenu != null) {
      await _historyService.addHistory(selectedMenu!);
    }

    // 게임 인스턴스 정리
    if (_lotteryGame != null) {
      _cleanupGame(_lotteryGame!);
      _lotteryGame = null;
    }

    // 게임 완료 콜백 호출
    if (onGameComplete != null) {
      onGameComplete!();
    }
  }

  // 메뉴 선택 서비스를 통한 랜덤 메뉴 선택 메서드 (widget에서 접근용)
  Future<void> selectRandomMenu() async {
    selectedMenu = await _menuSelectionService.selectMenu();
    notifyListeners();
  }

  // 히스토리에 메뉴 추가 메서드 (public API)
  Future<void> addMenuToHistory(Menu menu) async {
    await _historyService.addHistory(menu);
  }

  // 게임 인스턴스 정리를 위한 헬퍼 메서드
  void _cleanupGame(LotteryGame game) {
    try {
      // 게임 자원 정리 (LotteryGame 클래스의 메서드 사용)
      game.cleanupResources();
      debugPrint('Game instance cleaned up successfully');
    } catch (e) {
      debugPrint('Game cleanup error: $e');
    }
  }

  // 상태 초기화 메서드
  void reset() {
    // 기존 상태 정리
    selectedMenu = null;
    isLotteryRunning = false;

    // 기존 게임 인스턴스 정리 및 참조 제거
    if (_lotteryGame != null) {
      _cleanupGame(_lotteryGame!);
      _lotteryGame = null;
    }

    // 상태 변경 알림
    notifyListeners();
  }

  // ViewModel 제거 시 호출
  @override
  void dispose() {
    // 게임 인스턴스 정리
    if (_lotteryGame != null) {
      _cleanupGame(_lotteryGame!);
      _lotteryGame = null;
    }

    // 부모 클래스의 dispose 호출
    super.dispose();
  }
}
