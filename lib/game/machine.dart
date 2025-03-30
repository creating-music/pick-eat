import 'dart:math' as math;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Machine extends BodyComponent {
  final Vector2 gameSize;

  @override
  late final Vector2 center;

  late final double radius;
  
  // 상승기류 관련 속성 추가
  late final Vector2 forceOrigin; // 힘의 원천
  late final double forceHeight;  // 힘이 영향을 미치는 높이
  late final double forceWidth;  // 힘이 영향을 미치는 반경
  late final double forceStrength;  // 힘의 세기

  Machine({required this.gameSize}) : super(renderBody: false) {
    center = Vector2(gameSize.x * 0.5, gameSize.y * 0.5);
    radius = gameSize.x * 0.3;

    final extraHeight = gameSize.y * 0.1;
    
    // 상승기류 속성 초기화
    forceOrigin = Vector2(center.x, center.y - radius);
    forceHeight = 2 * (center.y - radius) + extraHeight;
    forceWidth = radius * 0.15;
    forceStrength = 100000.0;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(position: Vector2.zero(), type: BodyType.static);
    final body = world.createBody(bodyDef);

    // 원형 경계 생성
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

    final centerOffset = Offset(center.x, center.y);
    
    // 머신 몸체 그리기
    final outlinePaint = Paint()
      ..color = Colors.blue[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final fillPaint = Paint()
      ..color = Colors.blue[100]!
      ..style = PaintingStyle.fill;

    // 원형 경계 그리기
    canvas.drawCircle(centerOffset, radius, fillPaint);
    canvas.drawCircle(centerOffset, radius, outlinePaint);
  }
}
