import 'package:al_quran/pages/home.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home:
            Directionality(textDirection: TextDirection.rtl, child: HomePage()),
      );
}
