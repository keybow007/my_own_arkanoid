/*
* TODO ９−２：ボールの作成（Create the ball component）
* https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#4
*
* 先ほど、RectangleComponentを使ってPlayAreaを定義した。
* CircleComponentはRectangleComponentと同様、PositionedComponentから派生しているので、
* ボールを画面上に配置することができる。
* さらに重要なのは、その位置を更新できることだ。
* このコンポーネントでは、ベロシティ（時間経過による位置の変化）の概念を導入している。
* VelocityはVector2オブジェクトで、速度と方向の両方を表します。
* 位置を更新するには、ゲームエンジンがフレームごとに呼び出すupdateメソッドをオーバーライドします。
* dtは前のフレームからこのフレームまでの時間です。
* これにより、異なるフレームレート（60hzや120hz）や過剰な計算による長いフレームなどの要因に適応することができます。
*
* */
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:my_own_arkanoid/game/brick_breaker.dart';
import 'package:my_own_arkanoid/game/components/bat.dart';
import 'package:my_own_arkanoid/game/components/brick.dart';
import 'package:my_own_arkanoid/game/components/play_area.dart';

//TODO 14-1: ボールをはねさせる（Bounce the ball）
//https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#5
//https://docs.flame-engine.org/latest/flame/collision_detection.html#collisioncallbacks
class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
//  TODO9-2時点ではwith以降なし
//class Ball extends CircleComponent {

  /*
  * Vector2自体はFlutterのクラス
  * https://api.flutter.dev/flutter/vector_math/Vector2-class.html
  *
  * 余談：このゲームでは、位置や速度のような構成要素を持つ属性をモデル化する方法としてベクトルを使用します。
  * このゲームは2次元の世界をシミュレートしているので、位置と速度はxとyの2つのコンポーネントを持っています。
  * これらのコンポーネントを1つの概念としてまとめることで、
  * ベクトルをスケーリングするような概念をよりシンプルに扱えるようになります。
  * たとえば、速度に1より大きい数値を掛けてボールを速くしたり、現在の速度の適切な部分で位置を更新したりできます。
  * */
  final Vector2 velocity;

  final double difficultyModifier;

  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    /*
    * TODO 20: レンガを追加したことに伴うBallの変更（Add bricks to the world）
    *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#7
    * */
    required this.difficultyModifier,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()
            ..color = Color(0xff1e6091)
            ..style = PaintingStyle.fill,
          //TODO 14-2: ボールをはねさせる（Bounce the ball）
          //https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#5
          children: [CircleHitbox()],
        );

  /*
  * update
  * https://docs.flame-engine.org/latest/flame/components.html#component-lifecycle
  * 位置を更新するには、ゲームエンジンがフレームごとに呼び出すupdateメソッドをオーバーライドします。
  * dtは前のフレームからこのフレームまでの時間です。
  * これにより、異なるフレームレート（60hzや120hz）や過剰な計算による長いフレームなどの要因に適応することができます。
  *
  * */
  @override
  void update(double dt) {
    super.update(dt);

    //position += velocity * dtの更新に注意してください。
    // これは、離散的(discrete ⇔ 連続的)な動きのシミュレーションを時間経過とともに更新する方法です。
    // https://dictionary.goo.ne.jp/word/%E9%9B%A2%E6%95%A3%E7%9A%84/
    position += velocity * dt;
  }

  /*
  * TODO 14-3: ボールをはねさせる（Bounce the ball）
  * https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#5
  * https://docs.flame-engine.org/latest/flame/collision_detection.html#collisioncallbacks
  *
  * この例では、onCollisionStart コールバックの追加により大きな変更が行われます。
  * 前の例で BrickBreaker に追加された衝突判定システムがこのコールバックを呼び出します。
  * まず、コードは Ball が PlayArea と衝突したかどうかをテストします。
  * ゲームの世界に他のコンポーネントがないため、現時点ではこれは冗長に見えるかもしれません。
  * 次のステップでバットを世界に追加すると、状況は変わります。
  * また、ボールがバット以外のものと衝突したときに処理するための else 条件も追加されています。
  * 残りのロジックを実装するための親切なリマインダーです。
  *
  * ボールが底壁に衝突すると、視界内にはあるものの、プレイエリアから消えてしまいます。
  * このアーティファクト（バグや意図しない動作によって生じる、本来意図しない要素）は、
  * 次の一歩で Flame の Effects の力を利用して処理します。
  *
  * 注意：Flame の衝突判定コールバックはライフサイクルを持っています。
  * 使用可能なコールバックは onCollisionStart, onCollision, onCollisionEnd の 3 種類です。
  * このゲームの初期バージョンは onCollision を使用していたため、
  * 後続の衝突コールバックを処理するために追加のコードが必要でした。
  * 目的ごとに適切なコールバックを使用することで、コードを大幅に簡略化できます。
  * */

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    print("[$otherと衝突！]");
    //衝突相手がPlayAreaであるかどうか（Ball が PlayArea と衝突したかどうか）
    if (other is PlayArea) {
      print("[PlayAreaと衝突！]");
      if (intersectionPoints.first.y <= 0) {
        //上に衝突したら縦方向の向きを逆に
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        //左に衝突したら横方向の向きを逆に
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        //右に衝突したら横方向の向きを逆に
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        //下に衝突したら縦方向の向きを逆に
        //velocity.y = -velocity.y;
        /*
        * TODO 17: 下にボールが落ちたら跳ね返らずに消えさせる（RemoveEffectの追加）
        *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#6
        *  => TODO26で修正
        * RemoveEffect
        * https://docs.flame-engine.org/latest/flame/effects.html#removeeffect
        * */
        add(
          RemoveEffect(
            delay: 0.35,
            /*
            * TODO 26: ボールが下に落ちたらステータスをGameOverに => RemoveEffect#onCompleteで
            * https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#8
            * */
            onComplete: () {
              game.playState = PlayState.gameOver;
            },
          ),
        );
      }
    } else if (other is Bat) {
      /*
      * TODO 18: 板（Bat）との衝突判定
      *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#6
      *
      * */
      print("[Batと衝突！]${velocity.x} / ${velocity.y}");

      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {
      /*
      * TODO 21: レンガ（Brick）との衝突判定（Add bricks to the world）
      *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#7
      *
      * */
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }
      ////レンガが衝突するたびにボールの速度を増加させる
      velocity.setFrom(velocity * difficultyModifier);
    }
  }
}
