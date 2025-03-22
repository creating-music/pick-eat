import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../design/theme.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/lottery_machine.dart';
import 'result_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text(
              '랜덤 점심 추천기',
              style: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // 날짜 표시 (배지 스타일)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: AppTheme.badgeDecoration,
                    child: Text(
                      DateFormat(
                        'yyyy년 MM월 dd일 (E)',
                        'ko_KR',
                      ).format(DateTime.now()),
                      style: AppTheme.tagText,
                    ),
                  ),
                ),

                // 제목
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text('오늘의 점심 메뉴 뽑기', style: AppTheme.titleLarge),
                ),

                // 뽑기 머신 (게임 영역)
                Expanded(
                  child:
                      viewModel.isLotteryRunning
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Container(
                              decoration: AppTheme.cardDecoration,
                              margin: const EdgeInsets.only(bottom: 24),
                              clipBehavior: Clip.antiAlias,
                              child: GameWidget(game: viewModel.lotteryGame),
                            ),
                          )
                          : const LotteryMachine(),
                ),

                // 액션 버튼
                if (!viewModel.isLotteryRunning)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: ElevatedButton(
                      style: AppTheme.primaryButtonStyle,
                      onPressed: () {
                        viewModel.startLottery();

                        // 결과가 선택되면 결과 화면으로 이동
                        Future.delayed(const Duration(seconds: 4), () {
                          if (viewModel.selectedMenu != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => ResultScreen(
                                      menu: viewModel.selectedMenu!,
                                    ),
                              ),
                            );
                          }
                        });
                      },
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
