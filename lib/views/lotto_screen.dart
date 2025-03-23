import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design/theme.dart';
import '../viewmodels/lotto_viewmodel.dart';
import '../widgets/lottery_machine.dart';
import 'result_screen.dart';

class LottoScreen extends StatefulWidget {
  const LottoScreen({super.key});

  @override
  State<LottoScreen> createState() => _LottoScreenState();
}

class _LottoScreenState extends State<LottoScreen> {
  // 메뉴 선택 후 결과 화면으로 이동하는 메서드
  void _navigateToResult(BuildContext context, LottoViewModel viewModel) {
    if (mounted && viewModel.selectedMenu != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(menu: viewModel.selectedMenu!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LottoViewModel>(
      builder: (context, viewModel, child) {
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
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ClipRect(
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
                        Future.delayed(
                          const Duration(seconds: 4),
                          () => _navigateToResult(context, viewModel),
                        );
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
