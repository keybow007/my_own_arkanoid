/*
* TODO 19-2: レンガ（brics）の作成（Creating the bricks）
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#7
* */

import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:my_own_arkanoid/game/brick_breaker.dart';
import 'package:my_own_arkanoid/game/components/ball.dart';
import 'package:my_own_arkanoid/game/components/bat.dart';
import 'package:my_own_arkanoid/game/utils/config.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Brick(Vector2 position, Color color)
      : super(
          position: position,
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
        );

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    //ボールがレンガの衝突したら消す（ComponentTreeから削除）
    removeFromParent();

    /*
    * TODO 29-3: スコアの記録（Add score to the game）：レンガを壊した際にスコア追加
    *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#9
    * */
    game.score.value++;

    /*
    * ボールがレンガを壊した際に勝利条件チェックを行う
    * Worldに残っているレンガを問い合わし、残っているのが「1つ」だけであることを確認します。
    * => 前の行でremoveFromParentしているのになぜ「0」じゃなくて「1」なのか？？
    * => コンポーネントの削除はキューに入れられたコマンドであるということです
    *   （次のTickでの削除予約であってまだこのTickでは削除されていない）。
    *    このコードが実行された後、次のゲームワールドのティックの前に、レンガは削除されます。
    * */
    if (game.world.children.query<Brick>().length == 1) {

      /*
      * TODO 27: 勝利した際にステータスをwonに
      *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#8
      * */
      game.playState = PlayState.won;

      //ここはTODO19-2で書く部分
      game.world.removeAll(game.world.children.query<Ball>());
      game.world.removeAll(game.world.children.query<Bat>());
    }
  }
}
