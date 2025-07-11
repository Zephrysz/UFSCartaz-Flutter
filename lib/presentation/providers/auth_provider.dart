import 'package:flutter/material.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._userRepository) {
    _checkAuthState();
  }

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Check if user is already logged in
  Future<void> _checkAuthState() async {
    if (_userRepository.isLoggedIn) {
      _currentUser = await _userRepository.getCurrentUser();
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;
    
    try {
      final user = await _userRepository.login(email, password);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid email or password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<bool> register(String name, String email, String password, {String? avatarUrl}) async {
    _setLoading(true);
    _error = null;
    
    try {
      final user = await _userRepository.register(name, email, password, avatarUrl: avatarUrl);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    await _userRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  // Update user avatar
  Future<void> updateAvatar(String avatarUrl) async {
    try {
      await _userRepository.updateUserAvatar(avatarUrl);
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(avatarUrl: avatarUrl);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 