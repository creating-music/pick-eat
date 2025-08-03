import 'package:flutter/material.dart';
import 'package:pick_eat/views/lotto_screen.dart';
import 'package:pick_eat/views/temp.dart';
import 'package:provider/provider.dart';

import '../design/theme.dart';
import '../models/menu.dart';
import '../viewmodels/lotto_viewmodel.dart';
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
            appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '추천 메뉴 뽑기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '오늘 먹을 메뉴를 뽑아보세요',
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                
                  // 메인 컨텐츠
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),

                          // 메뉴 카드
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  // 음식 이미지 또는 아이콘
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: viewModel.menu.imageUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(60),
                                            child: Image.network(
                                              viewModel.menu.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.restaurant,
                                                  size: 60,
                                                  color: Colors.red.shade400,
                                                );
                                              },
                                            ),
                                          )
                                        : Icon(
                                            Icons.restaurant,
                                            size: 60,
                                            color: Colors.red.shade400,
                                          ),
                                  ),

                                  const SizedBox(height: 24),

                                  // 메뉴 이름
                                  Text(
                                    viewModel.menu.name,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 12),

                                  // 메뉴 설명
                                  Text(
                                    '오늘은 ${viewModel.menu.name} 어떠신가요?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),

                          // 버튼들
                          Column(
                            children: [
                              // 메인 버튼 - 다시 뽑기
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
                                  onPressed: () {
                                    // 홈 화면으로 돌아가기 전에 상태 초기화
                                    final lottoViewModel = Provider.of<LottoViewModel>(
                                      context,
                                      listen: false,
                                    );
                                    lottoViewModel.reset();

                                    // 홈 화면으로 돌아가기
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LottoScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '다시 뽑기',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // 하단 두 개 버튼
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
                                        onPressed: () {
                                          // TODO: 선호 저장 기능 구현
                                        },
                                        child: const Text(
                                          '선호 재선택',
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
                                        onPressed: () {
                                          // TODO: 불호 저장 기능 구현
                                        },
                                        child: const Text(
                                          '불호 재선택',
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
