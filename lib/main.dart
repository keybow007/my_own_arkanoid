import 'package:flutter/material.dart';
import 'package:my_own_arkanoid/screens/home_screen.dart';

//TODO １．HomeScreen作成まで
// （Codelabはいきなりmain関数内でGameWidget作っているが、ここはみんプロ流で）
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
