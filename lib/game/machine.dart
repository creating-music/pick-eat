import 'dart:math' as math;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Machine extends BodyComponent {
  final Vector2 gameSize;

  // 구멍 시작, 끝 각도
  final double exitStartAngle = (80 / 180) * math.pi; // 출구 시작 각도 (하단 중앙)
  final double exitEndAngle = (100 / 180) * math.pi;

  @override
  late final Vector2 center;

  late final double radius;

  // 상승기류 관련 속성 추가
  late final Vector2 forceOrigin; // 힘의 원천
  late final double forceHeight; // 힘이 영향을 미치는 높이
  late final double forceWidth; // 힘이 영향을 미치는 반경
  late final double forceStrength; // 힘의 세기

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
    final segments = 64; // 원을 구성할 세그먼트 수
    final angleStep = (2 * math.pi) / segments;

    for (var i = 0; i < segments; i++) {
      final startAngle = i * angleStep;
      final endAngle = (i + 1) * angleStep;

      // 출구 부분 건너뛰기
      if (startAngle >= exitStartAngle && startAngle <= exitEndAngle) {
        continue;
      }

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

    final fillPaint =
        Paint()
          ..color = const Color.fromARGB(255, 240, 241, 243)!
          ..style = PaintingStyle.fill;

    final arcPaint =
        Paint()
          ..color = const Color.fromARGB(255, 107, 112, 116)!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // 원형 경계 그리기
    final sweepAngle = 2 * math.pi - (exitEndAngle - exitStartAngle);
    canvas.drawCircle(centerOffset, radius, fillPaint);
    canvas.drawArc(
      Rect.fromCircle(center: centerOffset, radius: radius),
      exitEndAngle, // 시작 각도
      sweepAngle, // 출구 부분을 제외한 나머지 부분
      false,
      arcPaint,
    );

    _renderHole(canvas, centerOffset, radius);
    // 받침대
    _renderSupport(canvas, centerOffset, radius);
  }

  void _renderHole(Canvas canvas, Offset center, double radius) {
    final Paint supportPaint =
        Paint()
          ..color = const Color.fromARGB(255, 219, 219, 221)!
          ..style = PaintingStyle.fill;

    // 출구 양 끝점 계산
    final Offset leftExit = Offset(
      center.dx + radius * math.cos(exitStartAngle),
      center.dy + radius * math.sin(exitStartAngle),
    );

    final Offset rightExit = Offset(
      center.dx + radius * math.cos(exitEndAngle),
      center.dy + radius * math.sin(exitEndAngle),
    );

    // 지지대 높이 설정 (좀 더 두껍게)
    final double supportHeight = radius * 0.2; // 기존보다 약간 두껍게
    final double supportWidth = (rightExit.dx - leftExit.dx) * 1.3; // 출구보다 더 넓게

    // 지지대 위치 설정 (출구 바로 아래)
    final Rect supportRect = Rect.fromLTRB(
      leftExit.dx, // 왼쪽 끝
      leftExit.dy, // 원과 닿는 높이
      rightExit.dx, // 오른쪽 끝
      leftExit.dy + supportHeight, // 아래쪽으로 supportHeight만큼
    );

    canvas.drawRect(supportRect, supportPaint);
  }

  void _renderSupport(Canvas canvas, Offset center, double radius) {
    final Paint basePaint =
        Paint()
          ..color = const Color.fromARGB(80, 148, 68, 19)!
          ..style = PaintingStyle.fill;

    // 사다리꼴 위치 및 크기 설정
    final double topWidth = radius * 1.2; // 윗변 (지지대보다 살짝 넓게)
    final double bottomWidth = radius * 1.8; // 아랫변 (넓게 퍼지도록)
    final double height = radius * 0.4; // 사다리꼴 높이

    // 사다리꼴 중심점 (지지대 아래)
    final double baseCenterY = center.dy + radius + height * 0.5;

    // 사다리꼴 꼭짓점 좌표
    final Offset topLeft = Offset(
      center.dx - topWidth / 2,
      baseCenterY - height,
    );
    final Offset topRight = Offset(
      center.dx + topWidth / 2,
      baseCenterY - height,
    );
    final Offset bottomLeft = Offset(center.dx - bottomWidth / 2, baseCenterY);
    final Offset bottomRight = Offset(center.dx + bottomWidth / 2, baseCenterY);

    final Path trapezoidPath =
        Path()
          ..moveTo(topLeft.dx, topLeft.dy)
          ..lineTo(topRight.dx, topRight.dy)
          ..lineTo(bottomRight.dx, bottomRight.dy)
          ..lineTo(bottomLeft.dx, bottomLeft.dy)
          ..close();

    canvas.drawPath(trapezoidPath, basePaint);
  }
}
