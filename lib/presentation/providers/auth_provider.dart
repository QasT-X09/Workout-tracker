import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booklook/core/router/router_notifier.dart';
import 'package:booklook/data/datasources/auth_local_datasource.dart';

// ---------------------------------------------------------------------------
// Auth state
// ---------------------------------------------------------------------------

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? token;

  const AuthState({
    required this.status,
    this.errorMessage,
    this.token,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(String token) =>
      AuthState(status: AuthStatus.authenticated, token: token);
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);
}

// ---------------------------------------------------------------------------
// AuthNotifier
// ---------------------------------------------------------------------------

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthLocalDatasource _datasource;

  AuthNotifier(this._datasource) : super(AuthState.initial());

  // --- validation helpers ---------------------------------------------------

  bool _isValidEmail(String email) =>
      email.isNotEmpty && email.contains('@') && email.contains('.');

  bool _isValidPassword(String password) => password.length >= 4;

  // --- public API -----------------------------------------------------------

  /// Login with [email] and [password].
  /// No real backend — validates locally and saves a demo token.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_isValidEmail(email)) {
      state =
          AuthState.error('Введите корректный email (например, user@mail.com)');
      return;
    }

    if (!_isValidPassword(password)) {
      state = AuthState.error('Пароль должен содержать минимум 4 символа');
      return;
    }

    const token = 'demo_token';
    await _datasource.saveToken(token);
    routerNotifier.setLoggedIn(true);
    state = AuthState.authenticated(token);
  }

  /// Register with [email], [password] and [confirmPassword].
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    state = AuthState.loading();

    await Future.delayed(const Duration(milliseconds: 500));

    if (!_isValidEmail(email)) {
      state =
          AuthState.error('Введите корректный email (например, user@mail.com)');
      return;
    }

    if (!_isValidPassword(password)) {
      state = AuthState.error('Пароль должен содержать минимум 4 символа');
      return;
    }

    if (password != confirmPassword) {
      state = AuthState.error('Пароли не совпадают');
      return;
    }

    const token = 'demo_token';
    await _datasource.saveToken(token);
    routerNotifier.setLoggedIn(true);
    state = AuthState.authenticated(token);
  }

  /// Logout — clears the stored token and redirects to login.
  Future<void> logout() async {
    await _datasource.deleteToken();
    routerNotifier.setLoggedIn(false);
    state = AuthState.unauthenticated();
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final authDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  return AuthLocalDatasource();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final datasource = ref.watch(authDatasourceProvider);
  return AuthNotifier(datasource);
});
