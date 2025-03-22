import 'package:flutter/material.dart';
import '../design/theme.dart';

class LotteryMachine extends StatelessWidget {
  const LotteryMachine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 화면 크기에 비례하도록 조정
    final size = MediaQuery.of(context).size;
    final height = size.height * 0.5; // 화면 높이의 50%로 설정

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: AppTheme.cardDecoration.copyWith(
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 상단 라벨
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Text(
                '랜덤 메뉴 추첨기',
                style: AppTheme.tagText.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

            // 아이콘 원
            Container(
              width: height * 0.55,
              height: height * 0.55,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
                border: Border.all(color: AppTheme.primaryLight, width: 4),
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: height * 0.25,
                color: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 20),

            // 안내 텍스트
            Text(
              '아래 버튼을 눌러 메뉴를 뽑아보세요',
              style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // 부가 설명
            Text(
              '인기 한식, 중식, 일식, 양식 중에서\n랜덤으로 추천해드립니다',
              style: AppTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
