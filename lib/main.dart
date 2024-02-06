import 'package:flutter/material.dart';

import 'widgets/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

//TODO 1．HomeScreen作成まで（CodeLabにはない）
// （Codelabはいきなりmain関数内でGameWidget作っているが、ここはみんプロ流で）
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      /*
      * TODO 33: Googleフォントの設定
      * */
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
    );

  }
}
