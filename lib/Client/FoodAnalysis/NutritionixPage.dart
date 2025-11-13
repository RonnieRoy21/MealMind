import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NutritionixPage extends StatefulWidget {
  final String mealName;
  const NutritionixPage({super.key,required this.mealName});

  @override
  State<NutritionixPage> createState() => _NutritionixPageState();
}

class _NutritionixPageState extends State<NutritionixPage> {

  List<Map<String, dynamic>> nutritionList = [];
  List<String> userConditions = [];
  bool conditionsLoaded = false;

  @override
  void initState() {
    super.initState();

  }


  Future<List<dynamic>> fetchNutrition(String meal) async {
    try {
      final uri = "https://ronnieroy-nutritionalanalysis.onrender.com/getNutrients";
      final myUrl = Uri.parse(uri);

      final response = await http.post(
        myUrl,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json"
        },
        body: json.encode({
          "food_name": meal.toLowerCase()
        }),
      );
      print("Response is :${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["foods"] != null && data["foods"].isNotEmpty) {

          return data["foods"];
        } else {
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                "Error fetching nutrition for $meal: ${response.statusCode}"
            ))
        );
        return [];
      }
    } catch (error) {
      return [];
    }
  }




  Map<String, num> calculateTotals() {
    double calories = 0, carbs = 0, protein = 0, fat = 0, sodium = 0, sugar = 0,fiber = 0, cholesterol = 0;

    for (var item in nutritionList) {
      calories += (item["nf_calories"] ?? 0).toDouble();
      carbs += (item["nf_total_carbohydrate"] ?? 0).toDouble();
      protein += (item["nf_protein"] ?? 0).toDouble();
      fat += (item["nf_total_fat"] ?? 0).toDouble();
      sodium += (item["nf_sodium"] ?? 0).toDouble();
      sugar += (item["nf_sugars"] ?? 0).toDouble();
      fiber += (item["nf_dietary_fiber"] ?? 0).toDouble();
      cholesterol += (item["nf_cholesterol"] ?? 0).toDouble();

    }
    return {
      "calories": calories,
      "carbs": carbs,
      "protein": protein,
      "fat": fat,
      "sodium": sodium,
      "sugar": sugar,
      "fiber": fiber,
      "cholesterol": cholesterol,
    };
  }

  @override
 build(BuildContext context)  {
    final totals = calculateTotals();

    return Scaffold(
      appBar: AppBar(title: const Text("Meal Nutrition")),
      body: FutureBuilder(
          future:  fetchNutrition(widget.mealName),
          builder: (context,snapshot){
            if (snapshot.hasError){
              return Center(child: Text('Error : ${snapshot.error}'));
            }
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(semanticsLabel: "Loading ...",));
            }
            final fList=snapshot.data!;
            print("Nutrition List: $fList");
            return ListView.builder(
                itemCount: fList.length,
                itemBuilder: (context,index){
                  final item=fList[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text('Food Name: ${item["food_name"]} '),
                            subtitle: Text('Cholesterol:${item["cholesterol"]} g'),
                          ),
                          ListTile(
                            title: Text('Calories: ${item["calories"] ?? 0} g'),
                            subtitle: Text('Carbs: ${item["carbs"] ?? 0} g'),
                          ),
                          ListTile(
                            title: Text('Protein: ${item["protein"] ?? 0} g'),
                            subtitle: Text('Fat: ${item["fat"] ?? 0} g'),
                          ),
                          ListTile(
                            title: Text('Sodium: ${item["sodium"] ?? 0} g'),
                            subtitle: Text('Sugars : ${item["sugar"] ?? 0} g')
                          )
                        ]
                      )
                    );
                },
              );
          })
    );
  }
}
