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

  bool _selectionScheduled = false;
  double _selectionTimer = 0.0;
  final double _selectionDelay = 3.0; // 3초 후에 공을 선택

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var viewportSize = camera.viewport.size;
    var gameSize = Vector2(viewportSize.x, viewportSize.y);

    machine = Machine(gameSize: gameSize);
    await add(machine);

    // 여러 개의 공 추가
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
      final impulse =
          Vector2(
            random.nextDouble() * 4 - 2, // -2에서 2 사이의 랜덤 값
            random.nextDouble() * 4 - 2,
          ) *
          10000.0; // 임펄스 강도를 5.0에서 10000.0으로 증가

      ball.body.applyLinearImpulse(impulse);
    }
  }

  @override
  void update(double dt) {
    // 물리 엔진 시뮬레이션 속도를 높이기 위한 트릭
    // 여러 번 호출하는 대신, dt를 조절하여 한 번만 호출
    super.update(dt * 8);

    // 공 선택 타이머 처리
    if (isRunning && _selectionScheduled) {
      _selectionTimer += dt;

      // 지정된 시간이 지나면 공 선택 및 콜백 호출
      if (_selectionTimer >= _selectionDelay) {
        _selectionScheduled = false;

        // 랜덤하게 공 하나 선택
        if (balls.isNotEmpty) {
          final random = Random();
          selectedBall = balls[random.nextInt(balls.length)];
          selectedBall!.isSelected = true;
        }

        // 콜백 호출
        if (onBallSelected != null) {
          onBallSelected!();
        }

        isRunning = false;
      }
    }
  }

  void startLottery() {
    if (isRunning) return;
    isRunning = true;
    _selectionScheduled = true;
    _selectionTimer = 0.0;

    // 주의: 여기서는 공을 선택하지 않음
    // update 메서드에서 시간에 따라 처리
  }

  // 자원 정리를 위한 메서드
  void cleanupResources() {
    // 콜백 참조 제거
    onBallSelected = null;

    // 현재 생성된 모든 볼 객체 제거
    final ballComponents = children.whereType<Ball>().toList();
    for (final ball in ballComponents) {
      ball.removeFromParent();
    }

    // 필요한 경우 추가 정리 로직
    pauseEngine();

    // 모든 공 목록 비우기
    balls.clear();
    selectedBall = null;
    isRunning = false;
    _selectionScheduled = false;

    debugPrint('게임 리소스 정리 완료');
  }
}
