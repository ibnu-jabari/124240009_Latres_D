import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan sesi login (username) di SharedPreferences.
/// Selama belum logout, data ini tetap ada walaupun aplikasi ditutup.
class SessionService {
  static const String _keyUsername = 'username';
  static late SharedPreferences _prefs;

  /// Dipanggil sekali di main() sebelum runApp().
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Username yang sedang login (null kalau belum login).
  static String? get username => _prefs.getString(_keyUsername);

  static bool get isLoggedIn => (username ?? '').isNotEmpty;

  static Future<void> login(String username) async {
    await _prefs.setString(_keyUsername, username);
  }

  static Future<void> logout() async {
    await _prefs.remove(_keyUsername);
  }
}
