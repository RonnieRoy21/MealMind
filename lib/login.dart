import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login {
  final supabase = Supabase.instance.client;

  Future<bool> signUpUser(String email, String password) async {
    final supabase = Supabase.instance.client;

    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (res.user != null) {
        Fluttertoast.showToast(msg: "Signup successful! Please verify your email.");
        return true;
      } else {
        Fluttertoast.showToast(msg: "Signup failed. Try again.");
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: ${error.toString()}");
      print("Signup Error: $error");
      return false; // 🔹 Ensure a return value in case of failure
    }
  }


  Future<bool> loginWithEmail(String email, String password) async {
    try {
      final AuthResponse response = await supabase.auth
          .signInWithPassword(email: email, password: password);

      if (response.user != null) {
        Fluttertoast.showToast(msg: "Login Success");
        return true;
      } else {
        Fluttertoast.showToast(msg: "Login Failed");
        return false;
      }
    }catch(e){
      Fluttertoast.showToast(msg: "ERROR : ${e.toString()}");
      print("Login Error: $e");
      return false;

    }
  }
}
