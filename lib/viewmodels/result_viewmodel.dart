import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/menu.dart';

class ResultViewModel extends ChangeNotifier {
  final Menu menu;

  ResultViewModel({required this.menu});

  String getCategoryName() {
    switch (menu.category) {
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
    }
  }
}
