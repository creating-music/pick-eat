import 'package:flutter/material.dart';

import '../game/lottery_game.dart';
import '../models/menu.dart';
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

class HomeViewModel extends ChangeNotifier {
  final HistoryService _historyService;
  final MenuSelectionService _menuSelectionService;

  late LotteryGame lotteryGame;
  bool isLotteryRunning = false;
  Menu? selectedMenu;

  HomeViewModel({
    required HistoryService historyService,
    required MenuSelectionService menuSelectionService,
  }) : _historyService = historyService,
       _menuSelectionService = menuSelectionService {
    lotteryGame = LotteryGame();
    lotteryGame.onBallSelected = _onBallSelected;
  }

  void startLottery() async {
    isLotteryRunning = true;
    notifyListeners();

    // 메뉴 선택 서비스를 통한 랜덤 메뉴 선택
    selectedMenu = await _menuSelectionService.selectMenu();
    lotteryGame.startLottery();
  }

  void _onBallSelected() async {
    // 뽑기 완료 후 결과 처리
    if (selectedMenu != null) {
      await _historyService.addHistory(selectedMenu!);
    }

    isLotteryRunning = false;
    notifyListeners();
  }

  // 상태 초기화 메서드
  void reset() {
    selectedMenu = null;
    isLotteryRunning = false;
    lotteryGame = LotteryGame();
    lotteryGame.onBallSelected = _onBallSelected;
    notifyListeners();
  }

}
