import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../design/theme.dart';
import '../models/menu.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/result_viewmodel.dart';

class ResultScreen extends StatelessWidget {
  final Menu menu;

  const ResultScreen({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResultViewModel(menu: menu),
      child: Consumer<ResultViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 상단 헤더
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    color: AppTheme.primaryColor,
                    child: Column(
                      children: [
                        Text(
                          '오늘의 추천 메뉴',
                          style: AppTheme.titleSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '행복한 점심 시간 되세요!',
                          style: AppTheme.bodySmall.copyWith(
                            color: const Color.fromRGBO(255, 255, 255, 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 메인 컨텐츠
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 카테고리 배지
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '카테고리: ${viewModel.getCategoryName()}',
                              style: AppTheme.tagText,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // 메뉴 아이콘
                          Icon(
                            Icons.restaurant,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),

                          const SizedBox(height: 30),

                          // 메뉴 이름
                          Text(
                            viewModel.menu.name,
                            style: AppTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 10),

                          // 메뉴 설명
                          Text(
                            '오늘은 ${viewModel.menu.name}(을)를 추천합니다',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const Spacer(),

                          // 버튼
                          ElevatedButton(
                            style: AppTheme.primaryButtonStyle,
                            onPressed: () {
                              // 홈 화면으로 돌아가기 전에 상태 초기화
                              final homeViewModel = Provider.of<HomeViewModel>(
                                context,
                                listen: false,
                              );
                              homeViewModel.reset();

                              // 홈 화면으로 돌아가기
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            },
                            child: Text(
                              '홈 화면으로 돌아가기',
                              style: AppTheme.buttonText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
