/*
* TODO ４．画面サイズの設定（Size up the game）
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#3
* */
import 'dart:ui';

const gameWidth = 820.0;
const gameHeight = 1600.0;

/*
* TODO ９-1．ボールの大きさの設定（Create the ball component）
* https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#4
* */
const ballRadius = gameWidth * 0.02;

/*
* TODo 15-1: 板（bat）の大きさの設定（Create the bat）
* https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#6
* */
const batWidth = gameWidth * 0.2;
const batHeight = ballRadius * 2;
const batStep = gameWidth * 0.05;

/*
* TODO 19-1: レンガ（brics）のサイズ等設定（Creating the bricks）
*  https://codelabs.developers.google.com/codelabs/flutter-flame-brick-breaker#7
*
* */
const brickColors = [                                           // Add this const
  Color(0xfff94144),
  Color(0xfff3722c),
  Color(0xfff8961e),
  Color(0xfff9844a),
  Color(0xfff9c74f),
  Color(0xff90be6d),
  Color(0xff43aa8b),
  Color(0xff4d908e),
  Color(0xff277da1),
  Color(0xff577590),
];
//レンガ間のすきま
const brickGutter = gameWidth * 0.015;
final brickWidth =
    (gameWidth - (brickGutter * (brickColors.length + 1)))
        / brickColors.length;
const brickHeight = gameHeight * 0.03;
//レンガが衝突するたびにボールの速度を増加させる難易度ファクター
const difficultyModifier = 1.03;
