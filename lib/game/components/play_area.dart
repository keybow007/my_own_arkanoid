/*
* TODO 5.プレイエリアの作成（Create a PlayArea）
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#3
* => 感覚的にはTODO.6のBrickBreakerくらす（FlameGame）の作成を先にやった方がいい気がするけど、
*   とりあえずCodelabの通りにやっていく
*
*   ここで一応Componentの話をしておいた方がよさそうだ（アホみたいに種類がある＋ライフサイクル）
*   https://docs.flame-engine.org/latest/flame/components.html
*
*   二次元（2D）でプレイするゲームにはプレイエリアが必要です。
*   特定の寸法のエリアを作り、その寸法を使ってゲームの他の局面のサイズを決める。
*   プレイエリアの座標をレイアウトするには、さまざまな方法があります。
*   原点(0,0)を画面の中心に置き、正の値でx軸に沿って右に、y軸に沿って上にアイテムを移動させ、
*   画面の中心からの方向を測定することができます。この基準は、最近のほとんどのゲーム、特に3次元を含むゲームに適用される。
*
*   オリジナルのBreakoutゲームが作られたときの慣例は、原点を左上に設定することだった。
*   xの正方向は変わらないが、yは反転した。xの正方向は右で、yは下だった。
*   時代を忠実に再現するため、このゲームでは原点を左上に設定しています。
*
*
*   余談：時代によって次元の取り方が違うので、混乱するかもしれない。ここで気づくべきことが2つある。
*
*   第一に、ゲームに携わる人々のデフォルトは、デフォルトのコンテキストに依存していた。
*   70年代と80年代のプログラマーにとって、デフォルトの視覚環境は、左上に(0,0)があるテキスト・バッファだった。
*   この慣習は、グラフィカル・ディメンジョンのデフォルトにも引き継がれた。
*   3Dゲームがデフォルトとなった90年代には、これらのゲームに携わるプログラマーは3次元の数学に重点を置くようになり、
*   (0,0)を画面中央に置くことがより理にかなっていた。
*
*   第二に、これらのゲームは、これらの規約のどれを使って表現しても、すべてが一貫している限り、うまくいく。
*   Breakout』を(0,0)で表現しても、ゲームのプレイヤーは何の変化にも気づかない。
*   あなたが問題を表現しやすいように、世界をモデル化してください。
*
* */

import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:my_own_arkanoid/game/brick_breaker.dart';

/*
* TODO5の時点ではまだBrickBreakerクラスがないので文法エラーが出る
*   On entering the previous code, the IDE displays some angry looking red squiggly lines.
*   You will fix this later when you create the BrickBreaker class.
*
*   Flutterにはウィジェットがあるが、Flameにはコンポーネントがある。
*   Flutterのアプリがウィジェットのツリーを作るのに対し、Flameのゲームはコンポーネントのツリーを管理する。
*   そこにFlutterとFlameの興味深い違いがある。
*   Flutterのウィジェットツリーは、永続的でミュータブルなRenderObjectレイヤーを更新するために作られたエフェメラルな記述だ。
*   Flameのコンポーネントは永続的でミュータブルであり、開発者はこれらのコンポーネントをシミュレーションシステムの一部として使うことを想定している。
*   Flameのコンポーネントは、ゲームメカニクスの表現に最適化されています。
*   このコードラボでは、次のステップで紹介するゲームループから始めます。
*
* */

// HasGameRefクラスはv2.0でHasGameReferenceにreplaceされるらしい
//TODO 7. TODO6が完了した時点でジェネリクス<BrickBreaker>をALt+Enter

class PlayArea extends RectangleComponent with HasGameReference<BrickBreaker> {
  PlayArea()
      : super(
          /*
          * Paint
          * https://docs.flame-engine.org/latest/flame/rendering/palette.html
          * https://api.flutter.dev/flutter/dart-ui/Paint-class.html
          * */
          paint: Paint()..color = Color(0xfff2e8cf),

          /*
          * TODO 13-2: 衝突判定（Add collision detection：これもComponent！）
          * https://docs.flame-engine.org/latest/flame/collision_detection.html#rectanglehitbox
          * ShapeHitbox
          * https://docs.flame-engine.org/latest/flame/collision_detection.html#shapehitbox
          *
          * RectangleComponentの子コンポーネントとしてRectangleHitboxコンポーネントを追加すると、
          * 親コンポーネントのサイズに合った衝突判定用のヒットボックスが作成されます。
          * 親コンポーネントより小さい、または大きいヒットボックスが必要な場合のために、
          * RectangleHitboxにはrelativeというファクトリーコンストラクタがあります。
          *
          * 補足: ヒットボックスとは、当たり判定システムがコンポーネント同士の衝突を計算するために使用する領域のことです。
          * この名前の由来は、当たり判定に使用される領域が、プレイヤーが画面上で見える視覚的な表現から、
          * 一般的には単純な矩形やボックスに簡略化されるからです。
          * ヒットボックスのサイズは、プレイヤーの操作性を向上させるために、画面上のアバターとは異なる場合があります。
          * このゲームでは、ボールとレンガのヒットボックスのサイズは、それらが装着されているコンポーネントと同じです。
          * しかし、バットは、画面上のように丸みを帯びた形状ではなく、長方形のヒットボックスを持っています。
          * これにより、バットは見た目よりもわずかに大きくなっています。
          * ゲーム開発において、見た目と当たり判定をどのように調整するかは、興味深いポイントです。
          * プレイヤーにとって操作しやすいバランスを考えることは重要ですが、見た目にこだわることも魅力的です。
          *
          * */

          children: [RectangleHitbox()]
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
