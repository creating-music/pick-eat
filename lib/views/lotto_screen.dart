import 'package:flutter/material.dart';
import 'package:pick_eat/models/category.dart';
import 'package:pick_eat/models/menu.dart';
import 'package:pick_eat/views/result_screen.dart';
import 'package:provider/provider.dart';

import '../design/theme.dart';
import '../game/lotto_machine_widget.dart';
import '../widgets/lottery_machine.dart';
import '../viewmodels/lotto_viewmodel.dart';
import '../widgets/preference_bottom_sheet.dart';
import '../widgets/menu_card.dart';

class LottoScreen extends StatefulWidget {
  const LottoScreen({super.key});

  @override
  State<LottoScreen> createState() => _LottoScreenState();
}

class _LottoScreenState extends State<LottoScreen> with WidgetsBindingObserver {
  late LottoViewModel _viewModel;
  bool _callbackRegistered = false;

  // 게임 위젯 관련 상태
  bool _showGameWidget = false;

  void _onGameComplete() {
    if (mounted) {
      // ViewModel 상태 변경
      // 1. 뽑기 실행 중 상태를 false로 변경
      _viewModel.isLotteryRunning = false;

      // 2. selectedMenu가 없다면 임시 메뉴 설정 (이미 있다면 그대로 유지)
      _viewModel.selectedMenu ??= Menu(
        id: '1',
        name: "임시 메뉴",
        category: Category.korean,
      );

      // 3. 게임 위젯 숨기기
      setState(() {
        _showGameWidget = false;
      });

      // 이제 조건문 if (viewModel.selectedMenu != null && !viewModel.isLotteryRunning)이
      // true가 되어 MenuCard가 표시됩니다.
    }
  }

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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 백그라운드로 갔다가 돌아올 때 리소스 정리
    if (state == AppLifecycleState.paused) {
      _viewModel.reset();
    }
  }

  void _registerCallback() {
    if (!_callbackRegistered) {
      _viewModel = Provider.of<LottoViewModel>(context, listen: false);
      _viewModel.onGameComplete = () {
        if (mounted) {
          // 게임 완료 시 게임 위젯 숨기기만 함 (네비게이션 제거)
          setState(() {
            _showGameWidget = false;
          });
        }
      };
      _callbackRegistered = true;
    }
  }

  // 뽑기 시작 메서드
  Future<void> _startLottery() async {
    if (_viewModel.isLotteryRunning) return;

    // 상태 업데이트 (UI 즉시 반영)
    _viewModel.isLotteryRunning = true;

    // UI 업데이트 기다림
    await Future.microtask(() {});

    // 메뉴 선택
    await _viewModel.selectRandomMenu();

    // 게임 위젯 표시
    if (mounted) {
      setState(() {
        _showGameWidget = true;
      });
    }
  }

  // 다시 뽑기 메서드
  void _retryLottery() async {
    setState(() {
      _showGameWidget = false;
    });

    // 리셋 후 바로 새로운 뽑기 시작
    await _startLottery();
  }

  // 선호도 선택 BottomSheet 표시
  void _showPreferenceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => PreferenceBottomSheet(
            title: '선호 확인',
            isPreference: true,
            initialSelectedPreferences: _viewModel.preferredCategories,
            onConfirmPreferences: (selectedCategories) {
              _viewModel.updatePreferredCategories(selectedCategories);
            },
          ),
    );
  }

  // 불호도 선택 BottomSheet 표시
  void _showDislikeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => PreferenceBottomSheet(
            title: '불호 확인',
            isPreference: false,
            initialSelectedDislikes: _viewModel.dislikedCategories,
            onConfirmDislikes: (selectedCategories) {
              _viewModel.updateDislikedCategories(selectedCategories);
            },
          ),
    );
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
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // 메뉴가 뽑힌 상태에서는 다른 제목 표시
                    viewModel.selectedMenu != null &&
                            !viewModel.isLotteryRunning
                        ? '오늘의 추천 메뉴'
                        : '추천 메뉴 뽑기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    // 메뉴가 뽑힌 상태에서는 다른 설명 표시
                    viewModel.selectedMenu != null &&
                            !viewModel.isLotteryRunning
                        ? '이런 메뉴는 어떠신가요?'
                        : '오늘 먹을 메뉴를 뽑아보세요',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.red.shade400,
            elevation: 0,
            centerTitle: false,
            toolbarHeight: 80,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // 메인 컨텐츠 영역 - 조건부 렌더링
                Expanded(child: _buildMainContent(viewModel)),

                // 하단 버튼 영역 - 조건부 렌더링
                _buildBottomButtons(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  // 메인 컨텐츠 빌드 (조건부 렌더링)
  Widget _buildMainContent(LottoViewModel viewModel) {
    // 뽑힌 메뉴가 있고 뽑기가 실행중이 아닌 경우 → 결과 카드 표시
    if (viewModel.selectedMenu != null && !viewModel.isLotteryRunning) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            MenuCard(menu: viewModel.selectedMenu!),
            const Spacer(),
          ],
        ),
      );
    }

    // 뽑기 실행 중인 경우 → 게임 위젯 표시
    if (viewModel.isLotteryRunning) {
      return _showGameWidget
          ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LottoMachineWidget(onBallCollision: _onGameComplete),
          )
          : const Center(child: CircularProgressIndicator());
    }

    // 기본 상태 → 로또 머신 표시
    return const LotteryMachine();
  }

  // 하단 버튼 빌드 (조건부 렌더링)
  Widget _buildBottomButtons(LottoViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // 메인 버튼
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              onPressed:
                  viewModel.isLotteryRunning
                      ? null
                      : (viewModel.selectedMenu != null
                          ? _retryLottery
                          : _startLottery),
              child: Text(
                viewModel.selectedMenu != null ? '다시 뽑기' : '뽑기',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 뽑기 실행 중이 아닐 때만 하단 두 버튼 표시
          if (!viewModel.isLotteryRunning) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade400,
                        side: BorderSide(color: Colors.red.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.5),
                        ),
                      ),
                      onPressed: _showPreferenceBottomSheet,
                      child: const Text(
                        '선호 선택',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade400,
                        side: BorderSide(color: Colors.red.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.5),
                        ),
                      ),
                      onPressed: _showDislikeBottomSheet,
                      child: const Text(
                        '불호 선택',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
