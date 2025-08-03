import 'package:flutter/material.dart';
import '../models/menu.dart';

class MenuCard extends StatelessWidget {
  final Menu menu;
  final VoidCallback? onRetry;
  final String? description;

  const MenuCard({
    super.key,
    required this.menu,
    this.onRetry,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
              child: menu.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        menu.imageUrl!,
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
              menu.name,
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
              description ?? '오늘은 ${menu.name} 어떠신가요?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 
