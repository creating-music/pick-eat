import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pick_eat/game/lotto_machine_game.dart';

class LottoMachineWidget extends StatelessWidget {
  final VoidCallback? onBallCollision;

  const LottoMachineWidget({super.key, this.onBallCollision});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width * 0.8;
    final double height = screenSize.height * 0.4;

    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: GameWidget(
          game: LottoMachineGame(
            widgetSize: Vector2(width, height),
            onBallCollision: onBallCollision,
          ),
        ),
      ),
    );
  }
}
