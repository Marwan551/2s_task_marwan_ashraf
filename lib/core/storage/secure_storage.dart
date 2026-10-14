import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _keyBaseUrl = 'odoo_base_url';
  static const _keyDb = 'odoo_db';
  static const _keyUsername = 'odoo_username';
  static const _keyPassword = 'odoo_password';
  static const _keyUid = 'odoo_uid';
  static const _keyIsInternalUser = 'odoo_is_internal_user';

  Future<void> saveCredentials({
    required String baseUrl,
    required String db,
    required String username,
    required String password,
    required int uid,
    required bool isInternalUser,
  }) async {
    await _storage.write(key: _keyBaseUrl, value: baseUrl);
    await _storage.write(key: _keyDb, value: db);
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyPassword, value: password);
    await _storage.write(key: _keyUid, value: uid.toString());
    await _storage.write(key: _keyIsInternalUser, value: isInternalUser.toString());
  }

  Future<Map<String, dynamic>> getCredentials() async {
    final baseUrl = await _storage.read(key: _keyBaseUrl);
    final db = await _storage.read(key: _keyDb);
    final username = await _storage.read(key: _keyUsername);
    final password = await _storage.read(key: _keyPassword);
    final uidStr = await _storage.read(key: _keyUid);
    final isInternalStr = await _storage.read(key: _keyIsInternalUser);

    return {
      'baseUrl': baseUrl,
      'db': db,
      'username': username,
      'password': password,
      'uid': uidStr != null ? int.tryParse(uidStr) : null,
      'isInternalUser': isInternalStr == 'true',
    };
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _keyBaseUrl);
    await _storage.delete(key: _keyDb);
    await _storage.delete(key: _keyUsername);
    await _storage.delete(key: _keyPassword);
    await _storage.delete(key: _keyUid);
    await _storage.delete(key: _keyIsInternalUser);
  }
}
