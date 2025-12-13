import 'package:flutter/material.dart';

import '../AddMeal/add_meal.dart';
import '../DeleteMeal/delete_meal.dart';
import '../EditMeal/edit_meal.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List <Widget>_screens=[
    AddMeal(),
    EditMeal(),
    DeleteMeal(),
  ];
  final List <BottomNavigationBarItem> _items=[
    BottomNavigationBarItem(icon: Icon(Icons.add),label: 'Add meal'),
    BottomNavigationBarItem(icon: Icon(Icons.edit),label: 'Edit meal'),
    BottomNavigationBarItem(icon: Icon(Icons.delete),label: 'Delete meal'),
  ];
  int currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          currentIndex: currentIndex,
          items: _items,
          onTap: (index){
            setState(() {
              currentIndex=index;
            });
    },
      ),
    );
  }
}
