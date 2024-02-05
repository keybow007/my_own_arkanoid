/*
* TODO 5.プレイエリアの作成（Create a PlayArea）
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#3
* => 感覚的にはTODO.6のBrickBreakerくらす（FlameGame）の作成を先にやった方がいい気がするけど、
*   とりあえずCodelabの通りにやっていく
*
*   ここで一応Componentの話をしておいた方がよさそうだ（アホみたいに種類がある＋ライフサイクル）
*   https://docs.flame-engine.org/latest/flame/components.html
* */

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:my_own_arkanoid/game/brick_breaker.dart';

/*
* TODO5の時点ではまだBrickBreakerクラスがないので文法エラーが出る
*   On entering the previous code, the IDE displays some angry looking red squiggly lines.
*   You will fix this later when you create the BrickBreaker class.
* */

// HasGameRefクラスはv2.0でHasGameReferenceにreplaceされるらしい
//TODO 7. TODO6が完了した時点でジェネリクス<BrickBreaker>をALt+Enter

class PlayArea extends RectangleComponent with HasGameReference<BrickBreaker> {
  PlayArea() : super(paint: Paint()..color = Color(0xfff2e8cf),);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}