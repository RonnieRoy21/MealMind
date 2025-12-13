import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ManageMeals {
  final supabase =Supabase.instance.client;

  //admin add meal
Future uploadMeal({required String fileName, required int price,required String description,required Uint8List image})async {
  try {
     await supabase.storage.from('FOOD_IMAGES')
        .uploadBinary(
      fileName,
      image,
      fileOptions: const FileOptions(
        contentType: 'image/png',
        upsert: false,
      ),
    );
    Fluttertoast.showToast(msg: "Uploaded to storage");
    final fileLink = supabase.storage.from('FOOD_IMAGES').getPublicUrl(
        fileName);
    await supabase.from('MEALS').insert({
      'food_name': fileName,
      'food_price': price,
      'food_description': description,
      'food_image': fileLink.toString()
    });
    Fluttertoast.showToast(msg: "Uploaded to public database");
  }on StorageException catch(dbError){
    Fluttertoast.showToast(msg: dbError.error!.toString());
  }catch(err){
    Fluttertoast.showToast(msg: "Other Error : ${err.toString()}");
  }
}
  //admin can delete a meal
  //admin can edit a meal
}