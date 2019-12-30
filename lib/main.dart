import 'package:flutter/material.dart';
import 'package:scb_pwd_mgr/pages/Home/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SCB Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('SCB Password Manager'),
        ),
        body: Home(),
      ),
    );
  }
}
