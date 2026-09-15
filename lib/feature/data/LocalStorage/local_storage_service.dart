import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../feature/data/model/auth_user.dart';

class LocalStorageService {
  static const _secureStorage = FlutterSecureStorage();
  static const _keyAccessToken = 'accessToken';
  static const _keyRefreshToken = 'refreshToken';
  static const _keyUserData = 'userData';

  static Future<void> saveAuthData(AuthUser user) async {
    await _secureStorage.write(key: _keyAccessToken, value: user.accessToken);
    await _secureStorage.write(key: _keyRefreshToken, value: user.refreshToken);

    final prefs = await SharedPreferences.getInstance();
    final userJsonString = jsonEncode({
      'id': user.id,
      'username': user.username,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'gender': user.gender,
      'image': user.image,
    });
    await prefs.setString(_keyUserData, userJsonString);
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _keyAccessToken);
  }

  static Future<AuthUser?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUserData);
    final token = await getAccessToken();

    if (userString != null && token != null) {
      final Map<String, dynamic> userMap = jsonDecode(userString);
      userMap['accessToken'] = token;
      userMap['refreshToken'] = (await _secureStorage.read(key: _keyRefreshToken));
      return AuthUser.fromJson(userMap);
    }
    return null;
  }

  static Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserData);
  }
}