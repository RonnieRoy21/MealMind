import 'package:flutter/material.dart';
class EditMeal extends StatefulWidget {
  const EditMeal({super.key});

  @override
  State<EditMeal> createState() => _EditMealState();
}

class _EditMealState extends State<EditMeal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Meal'),
        centerTitle: true,
      ),
    );
  }
}
