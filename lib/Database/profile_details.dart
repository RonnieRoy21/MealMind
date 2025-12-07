import 'package:flutter1/DataModels/profile_model.dart';
import 'package:flutter1/Database/login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class ProfileDetails{
  SupabaseClient supabase=Supabase.instance.client;
  Logins l=Logins();
  Future<List<String>> getConditions() async {
    final userId = l.userId as String;
    try {
      final response = await supabase
          .from('USERS')
          .select('health_conditions')
          .eq('userId', userId)
          .single();

      if (response['health_conditions'] != null) {
        final List<dynamic> rawConditions = response['health_conditions'];
        return rawConditions.map((e) => e.toString()).toList();
      }
      return [];
    } on PostgrestException catch (apiError) {
      Fluttertoast.showToast(msg: "Database Error : ${apiError.message}");
      return [];
    } catch (anyOtherError) {
      Fluttertoast.showToast(msg: "Error : ${anyOtherError.toString()}");
      return [];
    }
  }

  //Edit own profile
Future editConditions(  {required List<dynamic>conditions})async {
    try {
      final myId=supabase.auth.currentUser!;
      await supabase.from('USERS').upsert({'conditions':conditions}).eq('userId', myId);
      return null;
    }on AuthApiException catch(apiError){
      Fluttertoast.showToast(msg: "Database Error : ${apiError.message}");
    }catch(anyOtherError){
      Fluttertoast.showToast(msg: "Error : ${anyOtherError.toString()}");
    }
}

Future addUserName({required String name})async{
    try{
      final myId=l.userId as String;
     await supabase.from('USERS')
          .update({
       'user_name': name
          }).eq('userId', myId);
      Fluttertoast.showToast(msg: "Username Saved",toastLength: Toast.LENGTH_SHORT);
    }on PostgrestException catch(apiError){
      Fluttertoast.showToast(msg:"Database Error : ${apiError.details.toString()}",toastLength: Toast.LENGTH_LONG);
    }catch(anyOtherError){
      Fluttertoast.showToast(msg:"Error : ${anyOtherError.toString()}",toastLength: Toast.LENGTH_LONG);
    }
}
Future addProfilePhoto(String imgPath)async{
    try{
      final myId=(l.userId).toString();
      await supabase.from("USERS").update({
        'profile_image':imgPath
      }).eq('userId', myId);
      Fluttertoast.showToast(msg: "Profile Photo Saved");
    }on PostgrestException catch(apiError){
      Fluttertoast.showToast(msg: "Database Error  : ${apiError.details}");
    }catch(anyOtherError){
      Fluttertoast.showToast(msg: "Error : ${anyOtherError.toString()}");
    }
}
//get profile of user
  Future<ProfileModel?> getProfile() async {
    try {
      final userId = l.userId as String;
      final response = await supabase.from("USERS").select('*').eq('userId', userId).single();
      return ProfileModel.fromJson(response);
    } on PostgrestException catch (error) {
      Fluttertoast.showToast(msg: "Database Error : ${error.message}");
      return null;
    } catch (error) {
      Fluttertoast.showToast(msg: "Error : ${error.toString()}");
      return null;
    }
  }

//calculate app ratings and show
Future getRatings()async{
    try{
      double avg=0;
      double totalRatings=0;
      var allRatings=[];
      final data=await supabase.from('RATINGS').select('rating_value');
      for (int i=0;i<data.length;i++){
        allRatings.add(data[i]['rating_value']);
      }
      final count=allRatings.length;
      for (int i=0;i<allRatings.length;i++){
        totalRatings= totalRatings + (allRatings[i]);
      }
      avg=(totalRatings/count);
      return avg;
    }catch(error){
      return error.toString();
    }
}

Future addRating({required double rateValue,required String review})async{
    try{
      final userId=l.userId as String;
      await supabase.from("RATINGS").update({
        'rating_value':rateValue,
        'user_comment':review
      }).eq('userId', userId);
      Fluttertoast.showToast(msg: "Rating Saved");
    }on PostgrestException catch(dbError){
      Fluttertoast.showToast(msg: "Insert Error : ${dbError.message.toString()}");
    }catch(anyOtherError){
      Fluttertoast.showToast(msg: "Error : ${anyOtherError.toString()}");
    }

}

}