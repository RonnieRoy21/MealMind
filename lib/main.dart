import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    const MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Main(),

    ),
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        centerTitle: true,
        title: Text('MealMind'),
      ),
    );
  }
}

