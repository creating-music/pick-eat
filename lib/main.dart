import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'design/theme.dart';
import 'repositories/menu_repository_impl.dart';
import 'services/history_service.dart';
import 'services/menu_selection_service.dart';
import 'viewmodels/lotto_viewmodel.dart';
import 'views/home_screen.dart';

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 날짜 형식 로케일 초기화 (한국어)
  await initializeDateFormatting('ko_KR', null);

  // 의존성 주입 (DI)
  final menuRepository = MenuRepositoryImpl();
  final historyService = MemoryHistoryService();
  final menuSelectionService = MenuSelectionService(
    menuRepository: menuRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => LottoViewModel(
                historyService: historyService,
                menuSelectionService: menuSelectionService,
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '랜덤 점심 추천기',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
