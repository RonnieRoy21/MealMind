import 'package:supabase_flutter/supabase_flutter.dart';
class ProfileDetails{
  SupabaseClient supabase=Supabase.instance.client;
  Future<List<String>> getConditions() async {

    final userId = supabase.auth.currentUser!.id;
    final response = await supabase
        .from('USERS')
        .select('health_conditions')
        .eq('id', userId)
        .single();

    if (response['health_conditions'] != null) {
      // Assuming 'conditions' column is stored as array<string>
      final List<dynamic> rawConditions = response['health_conditions'];
      return rawConditions.map((e) => e.toString()).toList();
    }
    return [];
  }
}