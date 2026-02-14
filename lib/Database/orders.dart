import 'dart:convert';

import 'package:flutter1/DataModels/macro_model.dart';
import 'package:flutter1/DataModels/order_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

import '../DataModels/meal_model.dart';
import 'login.dart';

class Orders {
  Logins l = Logins();
  SupabaseClient supabase = Supabase.instance.client;

  Stream<List<Meals>> fetchMeals() {
    return supabase
        .from('MEALS')
        .stream(primaryKey: ['food_id'])
        .order('created_at', ascending: true)
        .map((data) => List<Map<String, dynamic>>.from(data))
        .map((mealList) =>
            mealList.map((meal) => Meals.fromJson(meal)).toList());
  }

  Future addOrder(OrderModel order) async {
    try {
      await supabase.from("ORDERS").insert({
        'userId': l.userId.toString(),
        'order_description': order.orderDescription,
        'total_price_paid': order.totalAmount,
        'paying_number': order.phoneNumber,
        'method_of_pay': order.methodOfPayment,
        'confirmation_code': order.confirmationNumber,
        'order_destination': order.orderDestination,
        'payment_status': order.paymentStatus,
        'date_of_pay': order.dateCreated,
      });
    } on PostgrestException catch (dbErr) {
      return dbErr.message;
    } catch (err) {
      return err.toString();
    }
  }

  Future<Map<String, dynamic>> fetchNutrition(String meal) async {
    Map<String, dynamic> nutrition = {};
    try {
      List<String> foods = [meal];
      final separators = ['and', ',', 'with', '&'];
      for (final sep in separators) {
        List<String> temp = [];
        for (final p in foods) {
          if (p.contains(sep)) {
            temp.addAll(p.split(sep));
          } else {
            temp.add(p);
          }
        }
        foods = temp;
      }
      final uri =
          "https://ronnieroy-nutritionalanalysis.onrender.com/getNutrients";
      final myUrl = Uri.parse(uri);
      final response = await http.post(
        myUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({"food_names": foods}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          nutrition.addAll(data['totalsList']);
          return data['totalsList'];
        } else {
          Fluttertoast.showToast(msg: "No Data from server");
          return {};
        }
      } else {
        Fluttertoast.showToast(
            msg:
                "Error: ${response.reasonPhrase}\n Status Code: ${response.statusCode}");
        return {};
      }
    } catch (error) {
      return {};
    }
  }

  Future insertConsumedMacros({required String foodName}) async {
    try {
      final nutritionData = await fetchNutrition(foodName);
      print("Nutrition Data to be stored: $nutritionData");
      final macros = MacroModel(
        calories: int.tryParse(nutritionData['calories'].toString()) ?? 0,
        carbohydrates:
            int.tryParse(nutritionData['carbohydrates'].toString()) ?? 0,
        protein: int.tryParse(nutritionData['protein'].toString()) ?? 0,
        fats: int.tryParse(nutritionData['fats'].toString()) ?? 0,
        sodium: int.tryParse(nutritionData['sodium'].toString()) ?? 0,
        sugar: int.tryParse(nutritionData['sugar'].toString()) ?? 0,
        fiber: int.tryParse(nutritionData['fiber'].toString()) ?? 0,
        cholesterol: int.tryParse(nutritionData['cholesterol'].toString()) ?? 0,
        potassium: int.tryParse(nutritionData['potassium'].toString()) ?? 0,
      );
      await supabase.from("CONSUMED_MACROS").insert({
        'userId': l.userId.toString(),
        'food_name': foodName,
        'calories': macros.calories,
        'carbohydrates': macros.carbohydrates,
        'protein': macros.protein,
        'fats': macros.fats,
        'sodium': macros.sodium,
        'sugar': macros.sugar,
        'fiber': macros.fiber,
        'cholesterol': macros.cholesterol,
        'potassium': macros.potassium,
      });
    } on PostgrestException catch (dbErr) {
      return dbErr.message;
    } catch (err) {
      return err.toString();
    }
  }

  Future getAllMyOrders() async {
    final userId = l.userId.toString();
    try {
      final response =
          await supabase.from("ORDERS").select('*').eq('userId', userId);
      final data = response.toList();
      return data.map((order) => OrderModel.fromJson(order)).toList();
    } on PostgrestException catch (apiError) {
      Fluttertoast.showToast(msg: " Db Error : ${apiError.message}");
      return;
    } catch (anyOtherError) {
      Fluttertoast.showToast(msg: "Error in sth : ${anyOtherError.toString()}");
      return;
    }
  }

  //get all my completed orders
  Future getMyCompletedOrders() async {
    final userId = l.userId.toString();
    try {
      final response = await supabase
          .from("ORDERS")
          .select('*')
          .eq('userId', userId)
          .eq('payment_status', 'Completed');
      final data = response.toList();
      return data.map((order) => OrderModel.fromJson(order)).toList();
    } on PostgrestException catch (apiError) {
      Fluttertoast.showToast(msg: " Db Error : ${apiError.message}");
      return;
    } catch (anyOtherError) {
      Fluttertoast.showToast(msg: "Error in sth : ${anyOtherError.toString()}");
      return;
    }
  }

  //fetch all orders for admin
  Future adminGetAllOrders() async {
    try {
      final response = await supabase.from("ORDERS").select('*');
      final data = response.toList();
      return data.map((order) => OrderModel.fromJson(order)).toList();
    } on PostgrestException catch (apiError) {
      Fluttertoast.showToast(msg: " Db Error : ${apiError.message}");
      return;
    } catch (anyOtherError) {
      Fluttertoast.showToast(msg: "Error in sth : ${anyOtherError.toString()}");
      return;
    }
  }

  //fetch all completed orders for admin
  Future adminGetCompletedOrders() async {
    try {
      final response = await supabase
          .from("ORDERS")
          .select('*')
          .eq('payment_status', 'Completed');
      final data = response.toList();
      return data.map((order) => OrderModel.fromJson(order)).toList();
    } on PostgrestException catch (apiError) {
      Fluttertoast.showToast(msg: " Db Error : ${apiError.message}");
      return;
    } catch (anyOtherError) {
      Fluttertoast.showToast(msg: "Error in sth : ${anyOtherError.toString()}");
      return;
    }
  }
}
