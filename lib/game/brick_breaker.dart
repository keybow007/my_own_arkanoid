import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_own_arkanoid/game/components/ball.dart';
import 'package:my_own_arkanoid/game/components/bat.dart';
import 'package:my_own_arkanoid/game/components/brick.dart';
import 'package:my_own_arkanoid/game/utils/config.dart';
import 'package:my_own_arkanoid/game/components/play_area.dart';

//TODO 10-1: ボールの加速度算出（Adding the ball to the world）
//https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#4
import 'dart:math' as math;


/*
* TODO 23-1: ゲームステータスの設定（Add play states）
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#8
* */
enum PlayState {welcome, playing, gameOver, won}

/*
* TODO 6.Gameの親玉クラス（FlameGame）の作成（BrickBreaker）：Create a Flame game
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#3
* FlameGame
* https://docs.flame-engine.org/latest/flame/game.html
* TODO6の段階ではHasCollisionDetectionなし
*/

/* TODO 13-1: 衝突判定（Add collision detection）
*  https://docs.flame-engine.org/latest/flame/collision_detection.html
*   （注：13-1時点では with KeyboardEventsはまだない）
*
*  衝突判定は、2つのオブジェクトが接触したことをゲームが認識する動作を追加します。
*  ゲームに衝突判定を追加するには、BrickBreaker ゲームに HasCollisionDetection mixinを追加します。
* */
class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents, TapDetector {
//class BrickBreaker extends FlameGame with HasCollisionDetection, KeyboardEvents {
//class BrickBreaker extends FlameGame with HasCollisionDetection {
//class BrickBreaker extends FlameGame {
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

  /*
  * このファイルはゲームのアクションを調整する。
  * ゲームインスタンスの構築中に、このコードは固定解像度のレンダリングを使用するようにゲームを設定する。
  * ゲームは、それを含む画面いっぱいにリサイズされ、必要に応じてレターボックスが追加されます。
  * https://ja.wikipedia.org/wiki/%E3%83%AC%E3%82%BF%E3%83%BC%E3%83%9C%E3%83%83%E3%82%AF%E3%82%B9_(%E6%98%A0%E5%83%8F%E6%8A%80%E8%A1%93)
  * PlayAreaのような子コンポーネントが適切なサイズに設定できるように、ゲームの幅と高さを公開します。
  *
  *
  * [警告]
  * FlameGameの子としてComponentを直接追加することができます。
  * その場合、ワールドコンポーネントの子として追加するのではなく、CameraComponentがそれらのコンポーネントを変換することはありません。
  * このため、ウィンドウのサイズを変更しても思ったように動作せず、アプリのプレイヤーを混乱させる可能性があります。
  *
  * */

  //TODO 10-2: ボールの加速度算出（Adding the ball to the world）
  //https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#4
  final rand = math.Random();

  /*
  * TODO 29-1: スコアの記録（Add score to the game）
  *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#9
  *
  * ValueNotifier
  * https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html
  * */
  final ValueNotifier<int> score = ValueNotifier(0);

   /*
  * TODO 23-2: ゲームステータスの設定（Add play states）
  *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#8
  * */
  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        /*
        * Overlay
        * https://docs.flame-engine.org/latest/flame/overlays.html
        * */
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  /*
  * TODO 24-0: 画面をTapした際にゲームが開始するように修正
  *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#8
  *   １．onLoadにあるBallをWorldに追加する部分以降を別メソッドに外出し（startGame）+ await外していい
  *   ２．onTapメソッドをオーバーライドして１で作成したstartGameメソッド呼び出し（TapDetectorのwithへの追加要）
  *   ３．onLoadメソッドではPlayStateをwelcomeに
  *   ４．startGameメソッドではPlayStateをplayingに
 * */

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    /*
    * onLoadオーバーライド・メソッドでは、2つのアクションを実行します。
    * ビューファインダーのアンカーとして左上を設定します。
    * デフォルトでは、ビューファインダーは領域の中央を (0,0) のアンカーとして使用します。
    * ワールドにPlayAreaを追加します。ワールドはゲームの世界を表します。
    * ワールドは、CameraComponentsビュー変換を通して、すべての子を投影します。
    *
    * */

    //Viewfinder
    //https://docs.flame-engine.org/latest/flame/camera_component.html#viewfinder
    camera.viewfinder.anchor = Anchor.topLeft;

    //World
    //https://docs.flame-engine.org/latest/flame/camera_component.html#world
    world.add(PlayArea());

    /*
    * TODO 24-3: onLoadメソッドではPlayStateをwelcomeに
    * https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#8
    * */
    playState = PlayState.welcome;

    //TODO 24-1で以下はstartGameに移動
    // /*
    // * TODO 10-3: ボールの加速度算出（Adding the ball to the world）
    // *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#4
    // *   このとき「rand」使うために「math」パッケージのimport要
    // *   => ベクトルの正規化（normalize）してから高さの4/1まで伸ばす
    // *   https://www.nekonecode.com/math-lab/pages/vector2/normalize/
    // *
    // *  ボールを適当な速度でランダムな方向に移動させる
    // *  （さまざまな値を正しく設定するには、いくつかの反復が必要であり、業界ではプレイテストとも呼ばれている）
    // *
    // *   ベクトルは通常、方向と大きさの両方を表す。
    // *   大きさは位置であったり、速度の場合は速度であったりする。
    // *   方向はより一般的な概念であり、2つのベクトルを比較するためにベクトルの方向を抽出する必要がよくあります。
    // *   正規化（normalize）とは、位置ベクトルや速度ベクトルを方向はそのままに、
    // *   大きさを1にすることで新しいベクトルを作成する操作のことです。
    // *   下記のコードでは、正規化を使って、ベクトルやランダムな方向に一定の速度を与えるために使用されています。
    // * */
    // final ballVelocity =
    //     Vector2((rand.nextDouble() - 0.5) * width, height * 0.2).normalized()
    //       ..scale(height / 4);
    //
    // /*
    // * TODO 11: ボールをWorldに追加（Adding the ball to the world）
    // * ワールドに Ball コンポーネントを追加します。
    // * Vector2には、Vector2をスカラー値でスケーリングする演算子のオーバーロード（*と/）があるので、
    // * ボールの位置を表示領域の中心に設定するには、まずゲームのサイズを半分にする（position: size / 2）。
    // * ボールの速度を設定するには、さらに複雑な処理が必要になる。
    // * その目的は、ボールを適当な速度でランダムな方向に移動させることです。
    // * normalizedメソッドを呼び出すと、元のVector2と同じ方向に設定されたVector2オブジェクトが作成されますが、
    // * 距離が1にスケールダウンされます。
    // * ボールの速度は、ゲームの高さの1/4にスケールアップされます。
    // * このようなさまざまな値を正しく設定するには、いくつかの反復が必要であり、業界ではプレイテストとも呼ばれている。
    // * */
    // world.add(
    //   Ball(
    //     radius: ballRadius,
    //     //ボールの位置を表示領域の中心に設定するには、ゲームのサイズを半分にする
    //     position: size / 2,
    //     velocity: ballVelocity,
    //     /*
    //     * TODO 22-1: レンガ（Brick）のWorldへの追加（Add bricks to the world）
    //     *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#7
    //     * */
    //     difficultyModifier: difficultyModifier,
    //   ),
    // );
    //
    // /*
    // * TODO 16-1: BallをWorldに追加（Add the bat to the world）
    // *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#6
    // *
    // * */
    // world.add(
    //   Bat(
    //     // Add from here...
    //     size: Vector2(batWidth, batHeight),
    //     cornerRadius: const Radius.circular(ballRadius / 2),
    //     position: Vector2(width / 2, height * 0.95),
    //   ),
    // );
    //
    // /*
    // * TODO 22-1: レンガ（Brick）のWorldへの追加（Add bricks to the world）
    // *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#7
    // * => CodeLabでは直接書いてるけど、メソッドで外出ししよう
    // * => この段階でゲームができるところまでは行った！
    //  */
    // await addBricks();
    //
    // //TODO 12: debugModeをtrueに（画面上で起動中のComponentの詳細な情報が得られる）
    // //https://docs.flame-engine.org/latest/flame/other/debug.html
    // debugMode = true;
    //

  }




  void startGame() {

    /*
    * TODO 24-4: startGameメソッドではPlayStateをplayingに
    *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#8
    *  => 一度画面をきれいにしてからステータス変更
    * */
    if (playState == PlayState.playing) return;
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());
    playState = PlayState.playing;

    /*
    * TODO 29-2: スコアの記録（Add score to the game）：ゲーム開始時の初期値設定
    *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#9
    * */
    score.value = 0;

    /*
    * TODO 24-1: 画面をTapした際にゲームが開始するように修正
    * onLoadにあるBallをWorldに追加する部分以降を別メソッドに外出し（startGame）+ await外していい
    * => ここから下の部分はonLoadにあったものを移動
    * */
    final ballVelocity =
    Vector2((rand.nextDouble() - 0.5) * width, height * 0.2).normalized()
      ..scale(height / 4);
    world.add(
      Ball(
        radius: ballRadius,
        //ボールの位置を表示領域の中心に設定するには、ゲームのサイズを半分にする
        position: size / 2,
        velocity: ballVelocity,
        difficultyModifier: difficultyModifier,
      ),
    );
    world.add(
      Bat(
        // Add from here...
        size: Vector2(batWidth, batHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95),
      ),
    );
    //await外していい
    addBricks();
    debugMode = true;
  }

  /*
  * TODO 25: 背景色の追加
  *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#8
  * */
  @override
  Color backgroundColor() {
    return Color(0xfff2e8cf);
  }

  /*
  * TODO 24-2: 画面をTapした際にゲームが開始するように修正
  *  onTapメソッドをオーバーライドして１で作成したstartGameメソッド呼び出し
  *   （宣言部分でonTapDetectorのwithへの追加要）
  *
  * */
  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  /*
  * TODO 16-2: キーボード操作のコールバック（onKeyEvent）追加
  *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#6
  * １．KeyboardEvents mixinの追加（with）
  *     https://docs.flame-engine.org/latest/flame/inputs/keyboard_input.html
  *     https://docs.flame-engine.org/latest/flame/inputs/keyboard_input.html#receive-keyboard-events-in-a-game-level
  * ２．onKeyEventのオーバーライド（１をしないとオーバーライドできない）
  * */
  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //return super.onKeyEvent(event, keysPressed);
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        /*
        * Querying child components
        * https://docs.flame-engine.org/latest/flame/components.html#querying-child-components
        * */
        world.children.query<Bat>().first.moveBy(-batStep);
      case LogicalKeyboardKey.arrowRight:
        world.children.query<Bat>().first.moveBy(batStep);
      /*
      * TODO 24-5: キーボードのスペース・Enterを押してもstartGameできるように
      *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#8
      * */
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        startGame();
    }

    return KeyEventResult.handled;
  }



  Future<void> addBricks() async {
    var bricks = <Brick>[];
    for (int i = 0; i < brickColors.length; i++) {
      for (int j = 0; j <= 5; j++) {
        bricks.add(Brick(
          Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
          ),
          brickColors[i],
        ),);
      }
    }
    await world.addAll(bricks);
  }

}
