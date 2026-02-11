import 'package:flutter1/DataModels/macro_model.dart';
import 'package:flutter1/DataModels/order_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  Future insertConsumedMacros(MacroModel macros) async {
    try {
      await supabase.from("MACROS").insert({
        'userId': l.userId.toString(),
        'calories': macros.calories,
        'carbs': macros.carbohydrates,
        'protein': macros.protein,
        'fat': macros.fats,
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
