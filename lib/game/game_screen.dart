import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return GameScreenState();
  }
}

enum GameState {
  idle,
  playing,
  gameOver,
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool clockwise = true;
  int stage = 1;
  double targetAngle = 0;
  GameState gameState = GameState.idle;
  VoidCallback listener = () {};

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void gameOver() {
    setState(() {
      controller.stop();
      gameState = GameState.gameOver;
    });
  }

  getNextTargetAngle(bool clockwise) {
    final angleBetween90and180 = Random().nextDouble() * pi / 2 + pi / 2;

    if (clockwise) {
      final startAngle = controller.value * 2 * pi;
      var targetAngle = startAngle - angleBetween90and180;

      if (targetAngle < 0) {
        targetAngle += 2 * pi;
      }

      return targetAngle;
    } else {
      final startAngle = (1 - controller.value) * 2 * pi;
      var targetAngle = startAngle + angleBetween90and180;

      if (targetAngle > 2 * pi) {
        targetAngle -= 2 * pi;
      }

      return targetAngle;
    }
  }

  void tap() {
    controller.removeListener(listener);

    HapticFeedback.lightImpact();

    setState(() {
      if (gameState == GameState.idle) {
        gameState = GameState.playing;
        final startAngle = controller.value * 2 * pi;
        targetAngle = getNextTargetAngle(false);
        controller.repeat();

        final screenWidth = MediaQuery.sizeOf(context).width;
        final circleSize = screenWidth - 50;
        final borderWidth = circleSize / 6;
        final targetSize = borderWidth;
        final circleAngle = 2 * asin(targetSize / 2 / (circleSize / 2));

        listener = () {
          if (clockwise) {
            final angleDiff = targetAngle + circleAngle / 2 - startAngle;
            final angleGap = angleDiff < 0 ? angleDiff + 2 * pi : angleDiff;

            final currentAngleDiff =
                targetAngle + circleAngle / 2 - controller.value * 2 * pi;
            final currentAngleGap = currentAngleDiff < 0
                ? currentAngleDiff + 2 * pi
                : currentAngleDiff;

            if (currentAngleGap > angleGap) {
              setState(() {
                controller.stop();
                gameState = GameState.gameOver;
              });
            }
          } else {}
        };

        controller.addListener(listener);

        return;
      }

      if (gameState == GameState.playing) {
        final startAngle = clockwise
            ? controller.value * 2 * pi
            : (1 - controller.value) * 2 * pi;

        final screenWidth = MediaQuery.sizeOf(context).width;
        final circleSize = screenWidth - 50;
        final borderWidth = circleSize / 6;
        final targetSize = borderWidth;
        final circleAngle = 2 * asin(targetSize / 2 / (circleSize / 2));

        var diff = (targetAngle - startAngle).abs();
        if (diff > pi) {
          diff = 2 * pi - diff;
        }

        print('diff: $diff, circleAngle: $circleAngle');

        if (diff <= circleAngle) {
          print('alive');

          targetAngle = getNextTargetAngle(clockwise);
          controller.value = 1 - controller.value;
          controller.repeat();
          clockwise = !clockwise;

          listener = () {
            if (clockwise) {
              final angleDiff = targetAngle + circleAngle / 2 - startAngle;
              final angleGap = angleDiff < 0 ? angleDiff + 2 * pi : angleDiff;

              final currentAngleDiff =
                  targetAngle + circleAngle / 2 - controller.value * 2 * pi;
              final currentAngleGap = currentAngleDiff < 0
                  ? currentAngleDiff + 2 * pi
                  : currentAngleDiff;

              if (currentAngleGap > angleGap) {
                print('die 1');
                // gameOver();
              }
            } else {
              final animationValue = 1 - controller.value;

              final angleDiff = targetAngle - circleAngle / 2 - startAngle;
              final angleGap = angleDiff < 0 ? -angleDiff : 2 * pi - angleDiff;

              final currentAngleDiff =
                  targetAngle - circleAngle / 2 - animationValue * 2 * pi;
              final currentAngleGap = currentAngleDiff < 0
                  ? -currentAngleDiff
                  : 2 * pi - currentAngleDiff;

              if (currentAngleGap > angleGap) {
                print('die 2');
                // gameOver();
              }
            }
          };

          controller.addListener(listener);
          return;
        } else {
          print('die');
          gameOver();
          return;
        }
      }

      if (gameState == GameState.gameOver) {
        reset();
      }
    });
  }

  void reset() {
    setState(() {
      controller.reset();
      stage = 1;
      targetAngle = 0;
      clockwise = true;
      gameState = GameState.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = MediaQuery.sizeOf(context).width - 50;
    final borderWidth = circleSize / 6;
    final targetSize = borderWidth;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Stage $stage'),
      ),
      child: GestureDetector(
        onTap: tap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: CupertinoColors.systemGreen,
                      width: borderWidth,
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: CupertinoButton(
                        onPressed: tap,
                        child: Text(
                          gameState == GameState.idle
                              ? 'Start'
                              : gameState == GameState.gameOver
                                  ? 'Retry'
                                  : '',
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: targetAngle,
                      child: Transform.translate(
                        offset: Offset(0, -circleSize / 2 + borderWidth / 2),
                        child: Center(
                          child: Container(
                            width: targetSize,
                            height: targetSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9999),
                              color: CupertinoColors.systemYellow.withOpacity(
                                gameState == GameState.idle ? 0 : 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          // angle: controller.value * 2 * pi,
                          angle: clockwise
                              ? controller.value * 2 * pi
                              : (1 - controller.value) * 2 * pi,
                          child: Transform.translate(
                            offset:
                                Offset(0, -circleSize / 2 + borderWidth / 2),
                            child: Center(
                              child: Container(
                                width: 10,
                                height: borderWidth - 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9999),
                                  color: CupertinoColors.systemRed,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
