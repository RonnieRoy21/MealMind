import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class Logins extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  String? _userId;
  String? _role;
  String? get userId => _userId;
  String? get role => _role;

  Logins() {
    // restore session automatically on provider creation
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final session = supabase.auth.currentSession;
    if (session?.user != null) {
      _userId = session!.user.id;
      final roleResponse = await supabase
          .from('USERS')
          .select('role')
          .eq('userId', _userId!)
          .maybeSingle();
      _role = roleResponse?['role'] as String;
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
        final roleResponse = await supabase
            .from('USERS')
            .select('role')
            .eq('userId', _userId!)
            .maybeSingle();
        _role = await roleResponse!['role'] as String;
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

  Future signUpWithGoogle({required String tokenId}) async {
    try {
      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: tokenId,
      );
      return null;
    } on AuthApiException catch (error) {
      return error.message;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> logout() async {
    try {
      await supabase.auth.signOut();
      _userId = null;
      _role = null;
      notifyListeners();
      return "Success";
    } catch (e) {
      return e.toString();
    }
  }
}
