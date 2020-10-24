import 'package:flutter/material.dart';
import 'package:phone_book_deneme/screens/contactmenu.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactMenu(),
    );
  }
}
