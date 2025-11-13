import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NutritionixPage extends StatefulWidget {
  const NutritionixPage({super.key});

  @override
  State<NutritionixPage> createState() => _NutritionixPageState();
}

class _NutritionixPageState extends State<NutritionixPage> {

  List<Map<String, dynamic>> nutritionList = [];
  bool isLoading = true;
  List<String> userConditions = [];
  bool conditionsLoaded = false;

  @override
  void initState() {
    super.initState();

  }




  Future<void> fetchNutrition(String meal) async {
    nutritionList.clear();
    final  uri="";
    final myUrl=Uri.parse(uri);
    final response = await http.post(
        myUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({"food_name": meal}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data["foods"] != null && data["foods"].isNotEmpty) {
          nutritionList.add(data['foods']);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Error fetching nutrition for $meal: ${response.statusCode}")));
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
  Widget build(BuildContext context) {
    final totals = calculateTotals();

    return Scaffold(
      appBar: AppBar(title: const Text("Meal Nutrition")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : nutritionList.isEmpty
            ? const Center(child: Text("No nutrition info found"))
            : ListView(
          children: [
            // Individual food cards
            ...nutritionList.map(
                  (item) => Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Food: ${item["food_name"]}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text("Calories: ${item["nf_calories"]} kcal"),
                      Text("Carbs: ${item["nf_total_carbohydrate"]} g"),
                      Text("Protein: ${item["nf_protein"]} g"),
                      Text("Fat: ${item["nf_total_fat"]} g"),
                      Text("Sodium: ${item["nf_sodium"]} mg"),
                      Text("Sugar: ${item["nf_sugars"]} g"),
                      Text("Fiber: ${item["nf_dietary_fiber"]} g"),
                      Text("Cholesterol: ${item["nf_cholesterol"]} mg"),

                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Totals card with warnings
            Card(
              color: Colors.purple.shade50,
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: ExpansionTile(
                  title: const Text("Total Macros"),
                  children: [
                    ListTile(
                      title: Text("Calories: ${totals['calories']}"),
                      subtitle: Text("Carbs: ${totals['carbs']}"),
                    ),
                    ListTile(
                      title: Text("Sodium: ${totals['sodium']}"),
                      subtitle: Text("Sugars: ${totals['sugar']}"),
                    ),
                    ListTile(
                      title: Text("Proteins: ${totals['protein']}"),
                      subtitle: Text("Fats: ${totals['fat']}"),
                    ),
                    ListTile(
                      title: Text("Fiber: ${totals['fiber']}"),
                      subtitle: Text("Cholesterol: ${totals['cholesterol']}"),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
