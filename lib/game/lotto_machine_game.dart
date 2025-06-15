import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';
import 'package:pick_eat/game/constant/ball_color.dart';

class LottoMachineGame extends Forge2DGame {
  final Vector2 widgetSize;

  LottoMachineGame({required this.widgetSize}) : super(gravity: Vector2(0, 10));

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: widgetSize);

    ///////////////////////// machine ///////////////////////////
    final bodyRadius = widgetSize.x / 7;

    final bodyCenter = Vector2(widgetSize.x / 2, widgetSize.y / 2);
    add(MachineBody(startPosition: bodyCenter, radius: bodyRadius));
    add(
      MachineHat(
        position: bodyCenter - Vector2(0, bodyRadius),
        radius: bodyRadius / 2,
      ),
    );

    /////////////////////////// ball ////////////////////////////
    for (final color in BallColor.values) {
      final ballRadius = widgetSize.x / 40;
      final index = BallColor.values.indexOf(color);
      final center = Vector2(
        widgetSize.x / 2 + index * 0.001,
        widgetSize.y / 2 + index * 0.001,
      );
      add(Ball(startPosition: center, radius: ballRadius, color: color));
    }
  }
}

class Ball extends BodyComponent {
  final Vector2 startPosition;
  final double radius; // 👉 크기를 외부에서 지정
  final BallColor color;

  late final Svg svg;

  Ball({
    required this.startPosition,
    required this.radius,
    required this.color,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svg = await Svg.load(color.imagePath);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef =
        FixtureDef(shape)
          ..density = 1.0
          ..restitution = 0.8
          ..friction = 0.5;

    final bodyDef =
        BodyDef()
          ..type = BodyType.dynamic
          ..position = startPosition;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final size = Vector2.all(radius * 2);

    canvas.save();

    // 회전 중심을 원 중심으로 이동
    canvas.translate(0, 0);

    // 바디의 회전 각도 적용 (radian 단위)
    canvas.rotate(body.angle);

    // 이미지 그릴 때 중심 정렬을 위해 반지름만큼 이동
    canvas.translate(-radius, -radius);

    svg.render(canvas, size);

    canvas.restore();
  }
}

class MachineBody extends BodyComponent {
  final Vector2 startPosition;
  final double radius; // 👉 크기를 외부에서 지정

  late final Svg svg;

  MachineBody({required this.startPosition, required this.radius});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svg = await Svg.load('images/lotto/machine/machine-body.svg');
  }

  @override
  Body createBody() {
    final bodyDef =
        BodyDef()
          ..type = BodyType.static
          ..position = startPosition;

    final body = world.createBody(bodyDef);

    final int segmentCount = 128;
    final double angleStep = 2 * pi / segmentCount;
    final double wallThickness = radius * 0.01; // 얇은 벽 두께

    for (int i = 0; i < segmentCount; i++) {
      final angle = i * angleStep;
      final x = cos(angle) * radius;
      final y = sin(angle) * radius;

      final double exitStartAngle = (75 / 180) * pi; // 출구 시작 각도 (하단 중앙)
      final double exitEndAngle = (105 / 180) * pi;

      final startAngle = i * angleStep;

      // 구멍
      if (startAngle >= exitStartAngle && startAngle <= exitEndAngle) {
        continue;
      }

      final wallPosition = Vector2(x, y);
      final rotation = angle;

      final shape =
          PolygonShape()..setAsBox(
            wallThickness / 2,
            radius * 0.05, // 세로 길이
            wallPosition, // 중심 위치 (MachineBody 기준 상대 좌표)
            rotation, // 회전 각도
          );

      final fixtureDef =
          FixtureDef(shape)
            ..friction = 0.9
            ..restitution = 0.5;

      body.createFixture(fixtureDef);
    }

    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final size = Vector2.all(radius * 2);
    canvas.translate(-radius, -radius);
    svg.render(canvas, size);
  }
}

class MachineHat extends BodyComponent {
  final Vector2 position;
  final double radius;
  late final Svg svg;

  MachineHat({required this.position, required this.radius});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    svg = await Svg.load('images/lotto/machine/machine-hat.svg');
  }

  @override
  Body createBody() {
    final bodyDef =
        BodyDef()
          ..type = BodyType.static
          ..position = position;

    final body = world.createBody(bodyDef);
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    double diff = radius * 1.6;
    canvas.translate(-diff / 2, -diff / 2);
    final size = Vector2.all(diff);
    svg.render(canvas, size);
  }
}
