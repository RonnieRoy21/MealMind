import 'package:flutter/material.dart';
import 'package:flutter1/DataModels/meal_model.dart';
import 'package:flutter1/Database/manage_meals.dart';

class EditMeal extends StatefulWidget {
  const EditMeal({super.key});

  @override
  State<EditMeal> createState() => _EditMealState();
}

class _EditMealState extends State<EditMeal> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    final Meals meal = ModalRoute.of(context)!.settings.arguments as Meals;
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Meal'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController..text = meal.mealName!,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Name cannot be empty'
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Food Name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController
                      ..text = meal.mealPrice.toString(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price cannot be empty';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Price must be a valid number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Price', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController
                      ..text = meal.mealDescription!,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Description cannot be empty'
                        : null,
                    maxLines: 4,
                    decoration: InputDecoration(
                        labelText: 'Description', border: OutlineInputBorder()),
                  ),
                  ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                // Call your edit meal function here
                                ManageMeals().editMeal(
                                    foodName: _nameController.text.trim(),
                                    price:
                                        int.parse(_priceController.text.trim()),
                                    description:
                                        _descriptionController.text.trim());
                              }
                              Navigator.pop(context);
                            },
                      child: Text('Save Changes'))
                ],
              )),
        ));
  }
}
