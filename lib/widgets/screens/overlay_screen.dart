/*
* TODO 31-1: overlayを表示するFlutterのWidget作成（Make a good-looking game）
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#9
*  => flutter_animate使ってる
*     https://pub.dev/packages/flutter_animate
* */

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OverlayScreen extends StatelessWidget {
  final String title;
  final String subTitle;

  const OverlayScreen({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ).animate().slideY(
                duration: 750.ms,
                begin: -3,
                end: 0,
              ),
          const SizedBox(height: 16),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          )
              .animate(
                onPlay: (controller) => controller.repeat(),
              )
              .fadeIn(duration: 1.seconds)
              .then()
              .fadeOut(duration: 1.seconds),
        ],
      ),
    );
  }
}
