import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/odoo/odoo_exception.dart';
import '../../../core/odoo/odoo_client.dart';
import '../../../core/storage/secure_storage.dart';

class AuthRepository {
  final OdooClient _odooClient;
  final SecureStorageService _secureStorage;

  AuthRepository({
    OdooClient? odooClient,
    SecureStorageService? secureStorage,
  })  : _odooClient = odooClient ?? OdooClient(),
        _secureStorage = secureStorage ?? SecureStorageService();

  Future<Map<String, dynamic>> login({
    required String baseUrl,
    required String db,
    required String username,
    required String password,
  }) async {
    final uid = await _odooClient.authenticate(
      baseUrl: baseUrl,
      db: db,
      username: username,
      password: password,
    );

    if (uid == null || uid <= 0) {
      throw OdooException('Invalid credentials or authentication failed.');
    }

    final hasGroupRes = await _odooClient.executeKw(
      baseUrl: baseUrl,
      db: db,
      uid: uid,
      password: password,
      model: 'res.users',
      method: 'has_group',
      args: [[uid], 'base.group_user'],
    );
    if (hasGroupRes is! bool) {
      throw OdooException('Could not verify the user access level with Odoo.');
    }
    final isInternalUser = hasGroupRes;

    await _secureStorage.saveCredentials(
      baseUrl: baseUrl,
      db: db,
      username: username,
      password: password,
      uid: uid,
      isInternalUser: isInternalUser,
    );

    return {
      'uid': uid,
      'isInternalUser': isInternalUser,
    };
  }

  Future<Map<String, dynamic>> getSavedCredentials() async {
    return await _secureStorage.getCredentials();
  }

  Future<void> logout() async {
    await _secureStorage.clearCredentials();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
