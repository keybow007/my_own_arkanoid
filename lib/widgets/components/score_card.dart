import 'package:flutter/material.dart';

/*
* TODO 30: スコアを表示するWidgetの作成（Make a good-looking game）
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#9
* */

class ScoreCard extends StatelessWidget {
  final ValueNotifier<int> score;

  const ScoreCard({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    /*
    * ValueListenableBuilder
    * https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html
    * */
    return ValueListenableBuilder<int>(
        valueListenable: score,
        builder: (context, score, child) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
            child: Text(
              "Score: $score".toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        });
  }
}
