import 'dart:math' as math;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Machine extends BodyComponent {
  final Vector2 gameSize;

  Machine({required this.gameSize}) : super(renderBody: false);

  @override
  Body createBody() {
    final bodyDef = BodyDef(position: Vector2.zero(), type: BodyType.static);
    final body = world.createBody(bodyDef);

    // 원형 경계 생성
    final center = Vector2(gameSize.x * 0.5, gameSize.y * 0.5);
    final radius = gameSize.x * 0.3;  // 반지름 설정
    
    // 원형 경계의 세그먼트를 만듭니다
    final segments = 64;  // 원을 구성할 세그먼트 수
    final angleStep = (2 * math.pi) / segments;
    
    for (var i = 0; i < segments; i++) {
      final startAngle = i * angleStep;
      final endAngle = (i + 1) * angleStep;
      
      // 하단 중앙 부분에 출구를 만들기 위해 해당 부분은 건너뜁니다
      final start = Vector2(
        center.x + radius * math.cos(startAngle),
        center.y + radius * math.sin(startAngle),
      );
      final end = Vector2(
        center.x + radius * math.cos(endAngle),
        center.y + radius * math.sin(endAngle),
      );
      
      final edgeShape = EdgeShape()..set(start, end);
      body.createFixture(FixtureDef(edgeShape));
    }

    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(gameSize.x * 0.5, gameSize.y * 0.5);
    final radius = gameSize.x * 0.3;

    // 머신 몸체 그리기
    final outlinePaint = Paint()
      ..color = Colors.blue[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final fillPaint = Paint()
      ..color = Colors.blue[100]!
      ..style = PaintingStyle.fill;

    // 원형 경계 그리기
    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, outlinePaint);
  }
}
