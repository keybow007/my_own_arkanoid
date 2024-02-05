import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_own_arkanoid/game/brick_breaker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    * TODO ３．Gameインスタンスの作成
    * https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#2
    *
    * （別のCodelabでFlameの説明も）
    * https://codelabs.developers.google.com/codelabs/flutter-flame-game?hl=ja#2
    *
    * （Flame公式）
    * FlameGame
    * https://docs.flame-engine.org/latest/flame/game.html
    * Game Widget
    * https://docs.flame-engine.org/latest/flame/game_widget.html
    * */
    //ここはあとでBrickBreakerクラス作成時に修正
    //final game = FlameGame();
    //TODO 8. FlameGame => BrickBreakerに（Get the game on screen）
    //https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#3
    final game = BrickBreaker();
    return GameWidget(game: game);
  }
}
