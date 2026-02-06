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
        'payment_status': order.paymentStatus,
        'date_of_pay': order.dateCreated,
      });
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

  //get all completed orders
  Future getCompletedOrders() async {
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
}
