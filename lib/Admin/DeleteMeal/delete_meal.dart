import 'package:flutter/material.dart';

class DeleteMeal extends StatefulWidget {
  const DeleteMeal({super.key});

  @override
  State<DeleteMeal> createState() => _DeleteMealState();
}

class _DeleteMealState extends State<DeleteMeal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal'),
        centerTitle: true,
      ),
    );
  }
}
