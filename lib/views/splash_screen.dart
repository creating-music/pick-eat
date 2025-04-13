import 'package:flutter/material.dart';
import 'package:pick_eat/design/theme.dart';
import 'package:pick_eat/viewmodels/lotto_viewmodel.dart';
import 'package:pick_eat/views/lotto_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigateToResult(BuildContext context) {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LottoScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding을 사용하여 첫 프레임 렌더링 후 타이머 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 페이지 진입 후 4초 후에 자동으로 결과 화면으로 이동
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          _navigateToResult(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LottoViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                SvgPicture.asset(
                  'assets/images/pick-eat-logo.svg',
                  width: 160,
                  height: 160,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pick Eat',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
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
