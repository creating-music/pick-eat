import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Machine extends BodyComponent {
  final Vector2 gameSize;

  Machine({required this.gameSize}) : super(renderBody: false);

  @override
  Body createBody() {
    // 머신의 경계를 만듭니다.
    final bodyDef = BodyDef(position: Vector2.zero(), type: BodyType.static);

    final body = world.createBody(bodyDef);

    // 바닥
    final bottomShape =
        EdgeShape()..set(
          Vector2(0, gameSize.y * 0.7),
          Vector2(gameSize.x, gameSize.y * 0.7),
        );
    body.createFixture(FixtureDef(bottomShape));

    // 왼쪽 벽
    final leftShape =
        EdgeShape()..set(
          Vector2(gameSize.x * 0.2, gameSize.y * 0.3),
          Vector2(gameSize.x * 0.2, gameSize.y * 0.7),
        );
    body.createFixture(FixtureDef(leftShape));

    // 오른쪽 벽
    final rightShape =
        EdgeShape()..set(
          Vector2(gameSize.x * 0.8, gameSize.y * 0.3),
          Vector2(gameSize.x * 0.8, gameSize.y * 0.7),
        );
    body.createFixture(FixtureDef(rightShape));

    // 출구 (중간에 틈)
    final exitLeftShape =
        EdgeShape()..set(
          Vector2(gameSize.x * 0.4, gameSize.y * 0.7),
          Vector2(gameSize.x * 0.5, gameSize.y * 0.8),
        );
    body.createFixture(FixtureDef(exitLeftShape));

    final exitRightShape =
        EdgeShape()..set(
          Vector2(gameSize.x * 0.6, gameSize.y * 0.7),
          Vector2(gameSize.x * 0.5, gameSize.y * 0.8),
        );
    body.createFixture(FixtureDef(exitRightShape));

    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // 그림자 효과
    final shadowPath =
        Path()
          ..moveTo(gameSize.x * 0.2, gameSize.y * 0.3)
          ..lineTo(gameSize.x * 0.2, gameSize.y * 0.7)
          ..lineTo(gameSize.x * 0.4, gameSize.y * 0.7)
          ..lineTo(gameSize.x * 0.5, gameSize.y * 0.8)
          ..lineTo(gameSize.x * 0.6, gameSize.y * 0.7)
          ..lineTo(gameSize.x * 0.8, gameSize.y * 0.7)
          ..lineTo(gameSize.x * 0.8, gameSize.y * 0.3)
          ..close();

    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = const Color.fromRGBO(0, 0, 0, 0.1)
        ..style = PaintingStyle.fill,
    );

    // 머신 몸체 그리기
    final outlinePaint =
        Paint()
          ..color = Colors.blue[700]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0;

    final fillPaint =
        Paint()
          ..color = Colors.blue[100]!
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(gameSize.x * 0.2, gameSize.y * 0.3)
          ..lineTo(gameSize.x * 0.2, gameSize.y * 0.7)
          ..lineTo(gameSize.x * 0.4, gameSize.y * 0.7)
          ..lineTo(gameSize.x * 0.5, gameSize.y * 0.8)
          ..lineTo(gameSize.x * 0.6, gameSize.y * 0.7)
          ..lineTo(gameSize.x * 0.8, gameSize.y * 0.7)
          ..lineTo(gameSize.x * 0.8, gameSize.y * 0.3)
          ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, outlinePaint);

    // 상단 레이블 배경
    final labelRect = Rect.fromLTWH(
      gameSize.x * 0.3,
      gameSize.y * 0.32,
      gameSize.x * 0.4,
      gameSize.y * 0.08,
    );

    canvas.drawRect(labelRect, Paint()..color = Colors.white);

    // 텍스트 설정 (간단한 표시)
    final textPaint =
        Paint()
          ..color = Colors.blue[800]!
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(gameSize.x * 0.5, gameSize.y * 0.36),
      gameSize.x * 0.03,
      textPaint,
    );
  }
}
