
import 'package:alisverislistem/screens/alisveris_listem_sayfasi.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AlisverisListemApp());
}


class AlisverisListemApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData( primarySwatch: Colors.purple, accentColor:Colors.purpleAccent  ),
      home: AlisverisListemSayfasi(),



    );
  }
}
