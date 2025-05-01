import 'package:flutter/material.dart';
import 'views/home_page.dart';

void main() async{
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Metalize - 8-bit Style',
      theme: ThemeData.dark(),
      home: HomePage(
        imageUrl: 'assets/images/metalize.png',
      ),
    );
  }
}
