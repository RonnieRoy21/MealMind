import 'package:flutter1/DataModels/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../DataModels/meal_model.dart';

class Orders{
  SupabaseClient supabase = Supabase.instance.client;
  Future<List<Meals>> fetchMeals() async {
    final response = await supabase.from('MEALS').select();

    final data = response as List;
    return data.map((meal) => Meals.fromJson(meal)).toList();
  }

  Future addOrder(OrderModel order) async {
    try {
     final response=await supabase.from("ORDERS").insert({
        'user_id': order.uid,
        'order_description': order.orderDescription,
        'total_price_paid': order.totalAmount,
        'paying_number': order.phoneNumber,
        'method_of_pay': order.methodOfPayment,
        'confirmation_code': order.confirmationNumber,
        'payment_status': order.paymentStatus,
        'date_of_pay': order.dateCreated,
     });
     print(response.toString());
     return response;
    }catch(err){
      return err.toString();
    }
  }

  Future getMyOrders(String userId)async{
    try {
      final response = await supabase.from("ORDERS").select().eq(
          'user_id', userId);
      final data = response as List;
      return data.map((order) => OrderModel.fromJson(order)).toList();
    }catch(error){
      return error.toString();
    }
  }


}