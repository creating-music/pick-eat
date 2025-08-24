// 선호도 카테고리 enum
enum PreferenceCategory {
  fastFood('패스트푸드'),
  korean('한식'),
  chinese('중식'),
  japanese('일식'),
  western('양식/멕시칸'),
  snack('분식'),
  asian('아시안'),
  meat('고기'),
  saladSandwich('샐러드/샌드위치'),
  dessert('디저트');

  const PreferenceCategory(this.displayName);
  final String displayName;
}
