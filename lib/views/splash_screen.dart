
import 'package:flutter/material.dart';
import 'package:pick_eat/design/theme.dart';
import 'package:pick_eat/viewmodels/lotto_viewmodel.dart';
import 'package:pick_eat/views/lotto_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  void _navigateToResult(BuildContext context) {
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LottoScreen(),
        ),
      );
    }
  }

  @override  void initState() {
    super.initState();        // 페이지 진입 후 4초 후에 자동으로 메뉴 선택 및 결과 화면으로 이동
    Future.delayed(
      const Duration(seconds: 4), (){
        _navigateToResult(context);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: SafeArea(
            child: Column(    // TODO 앱로고 디자인 추가
              children: [
                Icon(
                  Icons.restaurant,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),

              ],
            ),
          ),
        );
      },
    );
  }

}
