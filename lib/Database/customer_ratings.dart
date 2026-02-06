import 'package:supabase_flutter/supabase_flutter.dart';

class Ratings {
  final supabase = Supabase.instance.client;

  //get all ratings
  Stream fetchRatings() {
    return supabase.from('RATINGS').stream(primaryKey: ['rating_id'])
        .order('created_at', ascending: true)
        .map((data) => List<Map<String, dynamic>>.from(data))
        .map((ratingList) => ratingList.map((rating) => rating).toList());
  }
}