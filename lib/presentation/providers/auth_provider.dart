import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booklook/core/router/router_notifier.dart';

// ---------------------------------------------------------------------------
// Auth state
// ---------------------------------------------------------------------------

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final User? user;

  const AuthState({
    required this.status,
    this.errorMessage,
    this.user,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(User user) =>
      AuthState(status: AuthStatus.authenticated, user: user);
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);
}

// ---------------------------------------------------------------------------
// AuthNotifier
// ---------------------------------------------------------------------------

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth;

  AuthNotifier(this._auth) : super(AuthState.initial());

  // --- helpers --------------------------------------------------------------

  /// Переводит [FirebaseAuthException.code] в понятное русское сообщение.
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Некорректный формат email.';
      case 'user-not-found':
        return 'Пользователь с таким email не найден.';
      case 'wrong-password':
        return 'Неверный пароль.';
      case 'email-already-in-use':
        return 'Этот email уже зарегистрирован.';
      case 'weak-password':
        return 'Пароль слишком простой (минимум 6 символов).';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже.';
      case 'network-request-failed':
        return 'Нет интернет-соединения.';
      case 'invalid-credential':
        return 'Неверный email или пароль.';
      default:
        return e.message ?? 'Произошла ошибка. Попробуйте снова.';
    }
  }

  // --- public API -----------------------------------------------------------

  /// Вход по email и паролю через Firebase Authentication.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      routerNotifier.setLoggedIn(true);
      state = AuthState.authenticated(credential.user!);
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_mapFirebaseError(e));
    } catch (_) {
      state = AuthState.error('Произошла непредвиденная ошибка.');
    }
  }

  /// Регистрация нового аккаунта через Firebase Authentication.
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      state = AuthState.error('Пароли не совпадают.');
      return;
    }

    state = AuthState.loading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      routerNotifier.setLoggedIn(true);
      state = AuthState.authenticated(credential.user!);
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_mapFirebaseError(e));
    } catch (_) {
      state = AuthState.error('Произошла непредвиденная ошибка.');
    }
  }

  /// Выход — Firebase signOut.
  Future<void> logout() async {
    await _auth.signOut();
    routerNotifier.setLoggedIn(false);
    state = AuthState.unauthenticated();
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthNotifier(auth);
});
