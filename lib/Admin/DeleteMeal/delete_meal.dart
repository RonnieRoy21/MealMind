import 'package:flutter/material.dart';
import 'package:flutter1/Database/manage_meals.dart';
import 'package:flutter1/Database/orders.dart';

class DeleteMeal extends StatefulWidget {
  const DeleteMeal({super.key});

  @override
  State<DeleteMeal> createState() => _DeleteMealState();
}

class _DeleteMealState extends State<DeleteMeal> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Orders meals = Orders();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text('Delete a Meal'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: meals.fetchMeals(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final mealList = snapshot.data!;
              return ListView.builder(
                  itemCount: mealList.length,
                  itemBuilder: (context, index) {
                    final meal = mealList[index];
                    return ListTile(
                      leading: Image.network(meal.mealImage!),
                      title: Text(meal.mealName!),
                      subtitle: Text(meal.mealDescription!),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                isLoading = true;
                                await ManageMeals().deleteMeal(
                                  int.parse(meal.id.toString()),
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              },
                      ),
                    );
                  });
            }));
  }
}
