import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/odoo/odoo_exception.dart';
import '../data/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isInternalUser;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isInternalUser = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isInternalUser,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInternalUser: isInternalUser ?? this.isInternalUser,
      errorMessage: errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AuthState()) {
    checkAutoLogin();
  }

  Future<void> checkAutoLogin() async {
    state = state.copyWith(isLoading: true);
    try {
      final creds = await _authRepository.getSavedCredentials();
      final uid = creds['uid'] as int?;
      final baseUrl = creds['baseUrl'] as String?;
      final db = creds['db'] as String?;
      final username = creds['username'] as String?;
      final password = creds['password'] as String?;
      final isInternal = creds['isInternalUser'] as bool? ?? false;

      if (uid != null && baseUrl != null && db != null && username != null && password != null) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          isInternalUser: isInternal,
        );
      } else {
        state = state.copyWith(isLoading: false, isAuthenticated: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isAuthenticated: false, errorMessage: e.toString());
    }
  }

  Future<bool> login({
    required String baseUrl,
    required String db,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await _authRepository.login(
        baseUrl: baseUrl,
        db: db,
        username: username,
        password: password,
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        isInternalUser: res['isInternalUser'] as bool? ?? false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: userFacingOdooError(e),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(isAuthenticated: false);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});
