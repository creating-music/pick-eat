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

    final gameSize = screenToWorld(camera.viewport.size);
    machine = Machine(gameSize: gameSize);
    await add(machine);

    // 10개의 공 추가
    final random = Random();
    final ballRadius = gameSize.x * 0.05;

    for (int i = 0; i < 10; i++) {
      final ball = Ball(
        initialPosition: Vector2(
          gameSize.x * 0.3 + random.nextDouble() * gameSize.x * 0.4,
          gameSize.y * 0.4 + random.nextDouble() * gameSize.y * 0.2,
        ),
        radius: ballRadius,
      );
      balls.add(ball);
      await add(ball);
    }
  }

  void startLottery() {
    if (isRunning) return;

    isRunning = true;

    // 랜덤으로 공 하나를 선택
    final random = Random();
    selectedBall = balls[random.nextInt(balls.length)];

    // 선택된 공에 약간의 추가 힘을 가함
    final force = Vector2(
      -2.0 + random.nextDouble() * 4.0,
      -5.0 - random.nextDouble() * 3.0,
    );
    selectedBall!.body.applyLinearImpulse(force);

    // 3초 후에 선택된 공을 표시하고 결과 처리
    Future.delayed(const Duration(seconds: 3), () {
      selectedBall!.isSelected = true;

      // 콜백 호출
      if (onBallSelected != null) {
        onBallSelected!();
      }

      isRunning = false;
    });
  }
}
