import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that notifies [GoRouter] when auth state changes.
/// Used as [refreshListenable] so the router re-evaluates redirects
/// whenever the user logs in or out.
class RouterNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool value) {
    if (_isLoggedIn != value) {
      _isLoggedIn = value;
      notifyListeners();
    }
  }
}

/// Global singleton — intentionally not a Riverpod provider so it can be
/// accessed both inside and outside of widget tree (e.g. from GoRouter).
final routerNotifier = RouterNotifier();
