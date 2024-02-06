/*
* TODo 15-2: 板（bat）の作成（Create the bat）
* https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#6
* */
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:my_own_arkanoid/game/brick_breaker.dart';

/*
* PositionComponent
* https://docs.flame-engine.org/latest/flame/components.html#positioncomponent
*
* Bat コンポーネントは RectangleComponent や CircleComponent ではなく PositionComponent です。
* これは、このコードは画面上に Bat を描画する必要があることを意味します。
* これを達成するために、render コールバックをオーバーライドします。
* */
class Bat extends PositionComponent
    with DragCallbacks, HasGameReference<BrickBreaker> {
  final Radius cornerRadius;

  /*
  * TODo 15-3: 板（bat）の作成（Create the bat）:コンストラクタ
  * https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#6
  * */
  Bat(
      {required this.cornerRadius,
      required super.position,
      required super.size})
      : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        );

  /*
  * TODo 15-4: 板（bat）の作成（Create the bat）:Paintの作成
  * https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#6
  * */
  final _paint = Paint()
    ..color = Color(0xff1e6091)
    ..style = PaintingStyle.fill;

  /*
  * TODo 15-5: 板（bat）の作成（Create the bat）:renderメソッド
  * https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#6
  *
  * render（updateとの違い）
  * https://docs.flame-engine.org/latest/flame/game.html#game-loop
  * https://docs.flame-engine.org/latest/flame/game.html#lifecycle
  * */
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    /*
    * canvas.drawRRect（丸みを帯びた矩形を描画）の呼び出しをよく見ると、"矩形はどこにあるのか？"と疑問に思うかもしれません。
    * Offset.zero & size.toSize() は、矩形を作成する dart:ui Offset クラスの演算子「& オーバーロード」を利用しています。
    * https://api.flutter.dev/flutter/dart-ui/Offset/operator_bitwise_and.html
    * （オーバーロード：名前は同じだけど引数の数とか型とかが違う関数を複数個、用意すること）
    * https://wa3.i-3-i.info/word17678.html
    * この省略記法は最初は戸惑うかもしれませんが、FlutterやFlameの低レベルのコードでは頻繁に目にするものです。
    * */
    //drawRRect
    //https://api.flutter.dev/flutter/dart-ui/Canvas/drawRRect.html
    canvas.drawRRect(
        //https://api.flutter.dev/flutter/dart-ui/RRect/RRect.fromRectAndRadius.html
        RRect.fromRectAndRadius(
          //Rect
          //https://api.flutter.dev/flutter/dart-ui/Rect-class.html
          //Offset（基準点からの距離）
          //https://api.flutter.dev/flutter/dart-ui/Offset-class.html
          //https://wa3.i-3-i.info/word11923.html
          Offset.zero & size.toSize(),
          cornerRadius,
        ),
        _paint);
  }

  /*
  * TODo 15-6: 板（bat）の作成（Create the bat）:ドラッグした際の処理
  * onDragUpdate
  * https://docs.flame-engine.org/latest/flame/inputs/drag_events.html#ondragupdate
  *
  * この Bat コンポーネントは、プラットフォームによって指またはマウスを使ってドラッグすることができます。
  * この機能を実装するには、DragCallbacks mixinを追加し、onDragUpdate イベントをオーバーライドします。
  * */
  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x = (position.x + event.localDelta.x)
        .clamp(width / 2, game.width - width / 2);
  }

/*
  * TODo 15-5: 板（bat）の作成（Create the bat）:moveByメソッド
  *
  * Batコンポーネントはキーボード操作に反応する必要がある。
  * => BrickBreaker#onKeyEventから呼び出す
  *
  * moveBy 関数により、他のコードは、このバットを特定の仮想ピクセル数だけ左または右に移動するように指示できます。
  * この関数は、Flame ゲームエンジンの新しい機能である Effects を導入します。
  * MoveToEffect オブジェクトをこのコンポーネントの子として追加することで、
  * プレイヤーはバットが新しい位置にアニメーション化されるのを見ることができます。
  * Flame には、さまざまな効果を実現するための Effects コレクションがあります。
  * Effect のコンストラクタ引数には、game ゲッターへの参照が含まれています。
  * そのため、このクラスに HasGameReference ミキシンを含めています。
  * このミキシンは、コンポーネントツリーの一番上にある BrickBreaker インスタンスにアクセスするための
  * 型安全な game アクセサーをこのコンポーネントに追加します。
  *
  * Effects
  * https://docs.flame-engine.org/latest/flame/effects.html
  *
  * */
  void moveBy(double dx) {
    //MoveByEffect
    //https://docs.flame-engine.org/latest/flame/effects.html#movebyeffect
    add(
      MoveToEffect(
        Vector2(
          //clamp（値を範囲内に制限すること）
          //https://api.dart.dev/stable/3.2.6/dart-core/num/clamp.html
          (position.x + dx).clamp(width / 2, game.width - width / 2),
          position.y,
        ),
        //EffectController
        //https://docs.flame-engine.org/latest/flame/effects.html#effectcontroller
        EffectController(duration: 0.1),
      ),
    );
  }
}
