import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_own_arkanoid/game/brick_breaker.dart';
import 'package:my_own_arkanoid/game/utils/config.dart';
import 'package:my_own_arkanoid/widgets/components/score_card.dart';
import 'package:my_own_arkanoid/widgets/screens/overlay_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BrickBreaker game;

  @override
  void initState() {
    super.initState();
    /*
    * TODO 32-2: ScoreCardの追加
    *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#9
    *   => FittedBoxをColumnでくるむ
    *   => このときにgame.scoreが必要なので、gameインスタンスをinitStateで先に作成しておく必要あり
    * */
    game = BrickBreaker();
  }

  //ここはTODO28で修正
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xffa9d6e5),
              Color(0xfff2e8cf),
            ])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  /*
                  * TODO 32-1: ScoreCardの追加
                  *  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#9
                  *   => FittedBoxをColumnでくるむ + FittedBox以下をExpandedに
                  *   => このときにgame.scoreが必要なので、gameインスタンスをinitStateで先に作成しておく必要あり
                  *   => GameWidget.controlled => GameWidgetに変更
                  * */
                  ScoreCard(score: game.score),
                  Expanded(
                    child: FittedBox(
                      child: SizedBox(
                        width: gameWidth,
                        height: gameHeight,
                        /*
                        * TODO 28: Overlayの追加
                        * GameWidget.controlled
                        * https://docs.flame-engine.org/latest/flame/game_widget.html#constructors
                        *
                        * This constructor can be useful when you want to put GameWidget into another widget,
                        * but would like to avoid the need to store the game’s instance yourself.
                        * */
                        child: GameWidget(
                          game: game,
                        // child: GameWidget.controlled(
                        //   gameFactory: BrickBreaker.new,
                          /*
                           * Overlay
                           * https://docs.flame-engine.org/latest/flame/overlays.html
                           */
                    
                          /*
                          * TODO 31-2: overlayを表示する画面の追加
                          * https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#9
                          *  => CodelabではHomeScreenをstateful
                          * */
                          overlayBuilderMap: {
                            PlayState.welcome.name: (context, game) {
                              return const OverlayScreen(
                                title: 'TAP TO PLAY',
                                subTitle: 'Use arrow keys or swipe',
                              );
                            },
                            PlayState.gameOver.name: (context, game) {
                              return const OverlayScreen(
                                title: 'G A M E   O V E R',
                                subTitle: 'Tap to Play Again',
                              );
                            },
                            PlayState.won.name: (context, game) {
                              return const OverlayScreen(
                                title: 'Y O U   W O N ! ! !',
                                subTitle: 'Tap to Play Again',
                              );
                            },
                          },
                    
                          // overlayBuilderMap: {
                          //   PlayState.welcome.name: (context, game) {
                          //     return Center(
                          //         child: Text(
                          //           "TAP TO PLAY",
                          //           style: Theme.of(context).textTheme.headlineLarge,
                          //         ),
                          //       );
                          //   },
                          //   PlayState.gameOver.name: (context, game) {
                          //     return Center(
                          //       child: Text(
                          //         "G A M E   O V E R",
                          //         style: Theme.of(context).textTheme.headlineLarge,
                          //       ),
                          //     );
                          //   },
                          //   PlayState.won.name: (context, game) {
                          //     return Center(
                          //       child: Text(
                          //         "Y O U   W O N ! ! !",
                          //         style: Theme.of(context).textTheme.headlineLarge,
                          //       ),
                          //     );
                          //   },
                          // },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
