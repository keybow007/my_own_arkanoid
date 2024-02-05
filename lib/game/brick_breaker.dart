/*
* TODO 6.Gameの親玉クラス（FlameGame）の作成（BrickBreaker）：Create a Flame game
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#3
*
* */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:my_own_arkanoid/game/components/ball.dart';
import 'package:my_own_arkanoid/game/utils/config.dart';
import 'package:my_own_arkanoid/game/components/play_area.dart';

//TODO 10-1: ボールの加速度算出（Adding the ball to the world）
//https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#4
import 'dart:math' as math;

//FlameGame
//https://docs.flame-engine.org/latest/flame/game.html
class BrickBreaker extends FlameGame {
  BrickBreaker()
      : super(
          //CameraComponent
          //https://docs.flame-engine.org/latest/flame/camera_component.html
          //CameraComponent.withFixedResolution()
          //https://docs.flame-engine.org/latest/flame/camera_component.html#cameracomponent-withfixedresolution
          camera: CameraComponent.withFixedResolution(
              width: gameWidth, height: gameHeight),
        );

  double get width => size.x;

  double get height => size.y;

  //TODO 10-2: ボールの加速度算出（Adding the ball to the world）
  //https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#4
  final rand = math.Random();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    //Viewfinder
    //https://docs.flame-engine.org/latest/flame/camera_component.html#viewfinder
    camera.viewfinder.anchor = Anchor.topLeft;

    //World
    //https://docs.flame-engine.org/latest/flame/camera_component.html#world
    world.add(PlayArea());

    //TODO 10-3: ボールの加速度算出（Adding the ball to the world）
    //https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#4
    //このとき「rand」使うために「math」パッケージのimport要
    // => ベクトルの正規化（normalize）してから高さの4/1まで伸ばす
    //https://www.nekonecode.com/math-lab/pages/vector2/normalize/
    final ballVelocity =
        Vector2((rand.nextDouble() - 0.5) * width, height * 0.2).normalized()
          ..scale(height / 4);
    //TODO 11: ボールをWorldに追加（Adding the ball to the world）
    world.add(
      Ball(
        // Add from here...
        radius: ballRadius,
        position: size / 2,
        velocity: ballVelocity,
      ),
    );
    //TODO 12: debugModeをtrueに（画面上で起動中のComponentの詳細な情報が得られる）
    //https://docs.flame-engine.org/latest/flame/other/debug.html
    debugMode = true;
  }
}
