import 'dart:math';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'ball.dart';
import 'machine.dart';

class LotteryGame extends Forge2DGame {
  LotteryGame() : super(gravity: Vector2(0, 10));

  final List<Ball> balls = [];
  late Machine machine;
  Ball? selectedBall;

  Function? onBallSelected;
  bool isRunning = false;

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var viewportSize = camera.viewport.size;
    var gameSize = Vector2(viewportSize.x, viewportSize.y);

    machine = Machine(gameSize: gameSize);
    await add(machine);

    // 10개의 공 추가
    final random = Random();
    final ballRadius = gameSize.x * 0.01;

    for (int i = 0; i < 50; i++) {
      final ball = Ball(
        initialPosition: Vector2(
          gameSize.x * 0.3 + random.nextDouble() * gameSize.x * 0.4,
          gameSize.y * 0.4 + random.nextDouble() * gameSize.y * 0.2,
        ),
        radius: ballRadius,
      );
      balls.add(ball);
      await add(ball);
      
      // 각 공에 초기 임펄스 부여하여 움직임 시작 (임펄스 강도 증가)
      final impulse = Vector2(
        random.nextDouble() * 4 - 2,  // -2에서 2 사이의 랜덤 값
        random.nextDouble() * 4 - 2,
      ) * 10000.0;  // 임펄스 강도를 5.0에서 10000.0으로 증가
      
      ball.body.applyLinearImpulse(impulse);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    super.update(dt);
    super.update(dt);
    super.update(dt);
    super.update(dt);
    super.update(dt);
    super.update(dt);
    super.update(dt);
  }

  void startLottery() {
    if (isRunning) return;

    isRunning = true;

    selectedBall!.isSelected = true;

    // 콜백 호출
    if (onBallSelected != null) {
      onBallSelected!();
    }

    isRunning = false;
  }
}
