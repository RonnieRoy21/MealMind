import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class Logins extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  String? _userId;
  String? get userId => _userId;

  Logins() {
    // restore session automatically on provider creation
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final session = supabase.auth.currentSession;
    if (session?.user != null) {
      _userId = session!.user.id;
      notifyListeners();
    }
  }

  Future<String> loginWithEmail(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        _userId = user.id;
        notifyListeners();
        return "Success";
      } else {
        return "Login failed: no user returned";
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> registerWithEmail({
    required String email,
    required String password,
    required List<String> conditions,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        await supabase.from('USERS').insert({
          'userId': user.id,
          'email': email,
          'health_conditions': conditions,
        });
        _userId = user.id;
        notifyListeners();
        return "Success";
      } else {
        return "Sign up failed";
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> logout() async {
    try {
      await supabase.auth.signOut();
      _userId = null;
      notifyListeners();
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }
}
