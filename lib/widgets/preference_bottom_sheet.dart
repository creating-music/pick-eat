import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/dislike_category.dart';

class PreferenceBottomSheet extends StatefulWidget {
  final String title;
  final bool isPreference; // true: 선호도, false: 불호도
  final Set<Category> initialSelectedPreferences;
  final Set<DislikeCategory> initialSelectedDislikes;
  final Function(Set<Category>)? onConfirmPreferences;
  final Function(Set<DislikeCategory>)? onConfirmDislikes;

  const PreferenceBottomSheet({
    super.key,
    required this.title,
    required this.isPreference,
    this.initialSelectedPreferences = const {},
    this.initialSelectedDislikes = const {},
    this.onConfirmPreferences,
    this.onConfirmDislikes,
  });

  @override
  State<PreferenceBottomSheet> createState() => _PreferenceBottomSheetState();
}

class _PreferenceBottomSheetState extends State<PreferenceBottomSheet> {
  late Set<Category> _selectedPreferences;
  late Set<DislikeCategory> _selectedDislikes;

  @override
  void initState() {
    super.initState();
    _selectedPreferences = Set.from(widget.initialSelectedPreferences);
    _selectedDislikes = Set.from(widget.initialSelectedDislikes);
  }

  String _getCategoryDisplayName(Category category) {
    switch (category) {
      case Category.korean:
        return '한식';
      case Category.chinese:
        return '중식';
      case Category.japanese:
        return '일식';
      case Category.western:
        return '양식';
      case Category.fastFood:
        return '패스트푸드';
      case Category.others:
        return '기타';
      default:
        return '그 외';
    }
  }

  String _getDislikeCategoryDisplayName(DislikeCategory category) {
    switch (category) {
      case DislikeCategory.seafood:
        return '해산물';
      case DislikeCategory.meat:
        return '육류';
      case DislikeCategory.beef:
        return '소고기';
      case DislikeCategory.pork:
        return '돼지고기';
      case DislikeCategory.chicken:
        return '닭고기';
      case DislikeCategory.fish:
        return '생선';
      case DislikeCategory.spicy:
        return '매운음식';
      case DislikeCategory.sweet:
        return '단음식';
      case DislikeCategory.salty:
        return '짠음식';
      case DislikeCategory.cold:
        return '찬음식';
      case DislikeCategory.hot:
        return '뜨거운음식';
      case DislikeCategory.dairy:
        return '유제품';
      default:
        return '그 외';
    }
  }

  String get _getDescriptionText {
    if (widget.isPreference) {
      return '좋아하는 음식을 선택해주세요';
    } else {
      return '싫어하는 음식을 선택해주세요';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.7;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10),
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 타이틀
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getDescriptionText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // 카테고리 리스트 (스크롤 가능)
          Expanded(
            child: 
              ScrollbarTheme(data: ScrollbarThemeData(
                crossAxisMargin: 10,
              ), child: 
            Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    if (widget.isPreference)
                      // 선호도 리스트
                      ...Category.values.asMap().entries.map((entry) {
                        final index = entry.key;
                        final category = entry.value;
                        final isSelected = _selectedPreferences.contains(category);
                        final isLast = index == Category.values.length - 1;
                        
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: CheckboxListTile(
                                title: Text(
                                  _getCategoryDisplayName(category),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedPreferences.add(category);
                                    } else {
                                      _selectedPreferences.remove(category);
                                    }
                                  });
                                },
                                activeColor: Colors.red.shade400,
                                checkColor: Colors.white,
                                controlAffinity: ListTileControlAffinity.trailing,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected 
                                        ? Colors.red.shade400 
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                tileColor: isSelected 
                                    ? Colors.red.shade50 
                                    : Colors.transparent,
                              ),
                            ),
                            // 점선 구분선 (마지막 아이템이 아닐 때만)
                            if (!isLast)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                                child: CustomPaint(
                                  size: const Size(double.infinity, 1),
                                  painter: DashedLinePainter(),
                                ),
                              ),
                          ],
                        );
                      })
                    else
                      // 불호도 리스트
                      ...DislikeCategory.values.asMap().entries.map((entry) {
                        final index = entry.key;
                        final category = entry.value;
                        final isSelected = _selectedDislikes.contains(category);
                        final isLast = index == DislikeCategory.values.length - 1;
                        
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: CheckboxListTile(
                                title: Text(
                                  _getDislikeCategoryDisplayName(category),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedDislikes.add(category);
                                    } else {
                                      _selectedDislikes.remove(category);
                                    }
                                  });
                                },
                                activeColor: Colors.red.shade400,
                                checkColor: Colors.white,
                                controlAffinity: ListTileControlAffinity.trailing,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isSelected 
                                        ? Colors.red.shade400 
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                tileColor: isSelected 
                                    ? Colors.red.shade50 
                                    : Colors.transparent,
                              ),
                            ),
                            // 점선 구분선 (마지막 아이템이 아닐 때만)
                            if (!isLast)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                                child: CustomPaint(
                                  size: const Size(double.infinity, 1),
                                  painter: DashedLinePainter(),
                                ),
                              ),
                          ],
                        );
                      }),
                  ],
                ),
              ),
            ),
            ),
          ),

          // 확인 버튼
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
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
                  if (widget.isPreference) {
                    widget.onConfirmPreferences?.call(_selectedPreferences);
                  } else {
                    widget.onConfirmDislikes?.call(_selectedDislikes);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // 하단 안전 영역
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

// 점선을 그리는 CustomPainter
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.0;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 
