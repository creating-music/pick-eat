import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design/theme.dart';
import '../game/lottery_game.dart';
import '../viewmodels/lotto_viewmodel.dart';
import '../widgets/lottery_machine.dart';
import 'result_screen.dart';

class LottoScreen extends StatefulWidget {
  const LottoScreen({super.key});

  @override
  State<LottoScreen> createState() => _LottoScreenState();
}

class _LottoScreenState extends State<LottoScreen> with WidgetsBindingObserver {
  late LottoViewModel _viewModel;
  bool _callbackRegistered = false;

  // 게임 인스턴스를 위젯 내부에서 직접 관리
  LotteryGame? _gameInstance;
  bool _creatingGame = false;

  // 게임 위젯 관련 상태
  bool _showGameWidget = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 첫 프레임 렌더링 후 콜백 등록
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerCallback();
    });
  }

  @override
  void dispose() {
    _cleanupGameInstance();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 백그라운드로 갔다가 돌아올 때 리소스 정리
    if (state == AppLifecycleState.paused) {
      _viewModel.reset();
      _cleanupGameInstance();
    }
  }

  void _registerCallback() {
    if (!_callbackRegistered) {
      _viewModel = Provider.of<LottoViewModel>(context, listen: false);
      _viewModel.onGameComplete = () {
        if (mounted) {
          _navigateToResult(context, _viewModel);
        }
      };
      _callbackRegistered = true;
    }
  }

  // 메뉴 선택 후 결과 화면으로 이동하는 메서드
  void _navigateToResult(BuildContext context, LottoViewModel viewModel) async {
    // 게임 위젯 즉시 숨기기
    if (mounted) {
      setState(() {
        _showGameWidget = false;
      });
    }

    // UI 업데이트 보장
    await Future.microtask(() {});

    // 게임 인스턴스 정리
    _cleanupGameInstance();

    if (mounted && viewModel.selectedMenu != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(menu: viewModel.selectedMenu!),
        ),
      );
    }
  }

  // 게임 인스턴스 정리 메서드
  void _cleanupGameInstance() {
    if (_gameInstance != null) {
      try {
        _gameInstance!.cleanupResources();
        _gameInstance = null;
        debugPrint('Game instance successfully cleaned up in widget');
      } catch (e) {
        debugPrint('Error cleaning up game instance: $e');
      }
    }
  }

  // 게임 인스턴스 생성 메서드
  Future<void> _createGameInstance() async {
    if (_creatingGame) return;

    _creatingGame = true;
    try {
      // 기존 게임 인스턴스 정리
      _cleanupGameInstance();

      // 새 게임 인스턴스 생성
      final instance = LotteryGame();

      // 공 선택 완료 시 히스토리 처리 및 결과 화면 이동
      instance.onBallSelected = () async {
        if (_viewModel.isLotteryRunning) {
          // 뽑기 상태 업데이트
          _viewModel.isLotteryRunning = false;
          _viewModel.notifyListeners();

          // 히스토리에 추가
          if (_viewModel.selectedMenu != null) {
            await _viewModel.addMenuToHistory(_viewModel.selectedMenu!);
          }

          // 결과 화면으로 이동
          if (mounted) {
            _navigateToResult(context, _viewModel);
          }
        }
      };

      if (mounted) {
        setState(() {
          _gameInstance = instance;
          _showGameWidget = true;
        });
      }
    } finally {
      _creatingGame = false;
    }
  }

  // 뽑기 시작 메서드
  Future<void> _startLottery() async {
    if (_viewModel.isLotteryRunning) return;

    // 상태 업데이트 (UI 즉시 반영)
    _viewModel.isLotteryRunning = true;
    _viewModel.notifyListeners();

    // UI 업데이트 기다림
    await Future.microtask(() {});

    // 게임 인스턴스 생성
    await _createGameInstance();

    // 메뉴 서비스 직접 접근 대신 뷰모델의 메서드 활용
    await _viewModel.selectRandomMenu();

    // 게임 시작
    if (mounted && _gameInstance != null && _viewModel.isLotteryRunning) {
      _gameInstance!.startLottery();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LottoViewModel>(
      builder: (context, viewModel, child) {
        // 뷰모델 참조 저장
        _viewModel = viewModel;

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pick Eat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // 뽑기 머신 (게임 영역)
                Expanded(
                  child:
                      viewModel.isLotteryRunning
                          ? _showGameWidget && _gameInstance != null
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: ClipRect(
                                  child: GameWidget(game: _gameInstance!),
                                ),
                              )
                              : const Center(child: CircularProgressIndicator())
                          : const LotteryMachine(),
                ),

                // 액션 버튼
                if (!viewModel.isLotteryRunning)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      style: AppTheme.primaryButtonStyle,
                      onPressed: () => _startLottery(),
                      child: Text('메뉴 뽑기', style: AppTheme.buttonText),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
