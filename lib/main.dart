
import 'package:alisverislistem/screens/alisveris_listem_sayfasi.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AlisverisListemApp());
}


class AlisverisListemApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"Alışveriş Listem" ,
      debugShowCheckedModeBanner: false,
      theme: ThemeData( primarySwatch: Colors.green, accentColor:Colors.greenAccent  ),
      home: AlisverisListemSayfasi(),



    );
  }
}
