/*
* TODO ９−２：ボールの作成（Create the ball component）
* https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#4
* */
import 'dart:ui';

import 'package:flame/components.dart';

class Ball extends CircleComponent {
  //Vector2自体はFlutterのクラス
  //https://api.flutter.dev/flutter/vector_math/Vector2-class.html
  final Vector2 velocity;

  Ball(
      {required this.velocity, required super.position, required double radius,})
      : super(
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()
        ..color = Color(0xff1e6091)
        ..style = PaintingStyle.fill);

  //update
  //https://docs.flame-engine.org/latest/flame/components.html#component-lifecycle
  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

}