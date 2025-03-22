import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 디자인 토큰 모음
class AppTheme {
  // 기본 색상 팔레트
  static const Color primaryColor = Color(0xFF2196F3); // 메인 파란색
  static const Color primaryLight = Color(0xFFE3F2FD); // 밝은 파란색 배경
  static const Color primaryDark = Color(0xFF1976D2); // 진한 파란색
  static const Color accentColor = Color(0xFFF44336); // 강조 빨간색 (가격 할인 등)
  static const Color backgroundColor = Color(0xFFF5F5F5); // 배경색
  static const Color cardColor = Colors.white; // 카드 배경색
  static const Color textPrimary = Color(0xFF212121); // 기본 텍스트 색상
  static const Color textSecondary = Color(0xFF757575); // 부가 텍스트 색상
  static const Color dividerColor = Color(0xFFEEEEEE); // 구분선 색상

  // 텍스트 스타일
  static TextStyle get titleLarge => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    color: textPrimary,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    color: textPrimary,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    color: textSecondary,
  );

  static TextStyle get buttonText => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get tagText => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primaryColor,
  );

  static TextStyle get priceOriginal => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle get priceDiscounted => const TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: accentColor,
  );

  // 카드 스타일
  static BoxDecoration get cardDecoration =>
      BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16));

  // 버튼 스타일
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 56),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
  );

  // 배지 스타일
  static BoxDecoration get badgeDecoration => BoxDecoration(
    color: primaryLight,
    borderRadius: BorderRadius.circular(12),
  );

  // 앱 테마 생성
  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: cardColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Pretendard',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
    textTheme: TextTheme(
      headlineLarge: titleLarge,
      headlineMedium: titleMedium,
      headlineSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
    ),
    useMaterial3: true,
  );
}
