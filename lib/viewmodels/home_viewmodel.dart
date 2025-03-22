import 'package:flutter/material.dart';

import '../game/lottery_game.dart';
import '../models/menu.dart';
import '../repositories/menu_repository.dart';
import '../services/history_service.dart';

class HomeViewModel extends ChangeNotifier {
  final MenuRepository _menuRepository;
  final HistoryService _historyService;

  late LotteryGame lotteryGame;
  bool isLotteryRunning = false;
  Menu? selectedMenu;

  HomeViewModel({
    required MenuRepository menuRepository,
    required HistoryService historyService,
  }) : _menuRepository = menuRepository,
       _historyService = historyService {
    lotteryGame = LotteryGame();
    lotteryGame.onBallSelected = _onBallSelected;
  }

  void startLottery() async {
    isLotteryRunning = true;
    notifyListeners();

    // 랜덤 메뉴 선택
    selectedMenu = await _menuRepository.getRandomMenu();
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

  String getDayOfWeek() {
    switch (DateTime.now().weekday) {
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
      default:
        return '';
    }
  }
}
