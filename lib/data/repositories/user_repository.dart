import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../database/app_database.dart';
import '../models/user.dart';
import '../../core/constants/app_constants.dart';

class UserRepository {
  final AppDatabase _database;
  final SharedPreferences _preferences;

  UserRepository(this._database, this._preferences);

  Future<User?> login(String email, String password) async {
    final passwordHash = _hashPassword(password);
    final user = await _database.userDao.getUserByEmailAndPassword(email, passwordHash);
    
    if (user != null) {
      await _saveUserSession(user);
    }
    
    return user;
  }

  Future<User?> register(String name, String email, String password, {String? avatarUrl}) async {
    final existingUser = await _database.userDao.getUserByEmail(email);
    if (existingUser != null) {
      throw Exception('User with this email already exists');
    }

    final passwordHash = _hashPassword(password);
    final now = DateTime.now();
    
    final user = User(
      name: name,
      email: email,
      passwordHash: passwordHash,
      avatarUrl: avatarUrl,
      createdAt: now,
      updatedAt: now,
    );

    final userId = await _database.userDao.insertUser(user);
    final createdUser = user.copyWith(id: userId);
    
    await _saveUserSession(createdUser);
    
    return createdUser;
  }

  Future<void> logout() async {
    await _preferences.setBool(AppConstants.keyIsLoggedIn, false);
    await _preferences.remove(AppConstants.keyUserId);
    await _preferences.remove(AppConstants.keyUserName);
    await _preferences.remove(AppConstants.keyUserEmail);
    await _preferences.remove(AppConstants.keyUserAvatar);
  }

  // User session methods
  Future<void> _saveUserSession(User user) async {
    await _preferences.setBool(AppConstants.keyIsLoggedIn, true);
    await _preferences.setInt(AppConstants.keyUserId, user.id!);
    await _preferences.setString(AppConstants.keyUserName, user.name);
    await _preferences.setString(AppConstants.keyUserEmail, user.email);
    if (user.avatarUrl != null) {
      await _preferences.setString(AppConstants.keyUserAvatar, user.avatarUrl!);
    }
  }

  bool get isLoggedIn => _preferences.getBool(AppConstants.keyIsLoggedIn) ?? false;

  int? get currentUserId => _preferences.getInt(AppConstants.keyUserId);

  String? get currentUserName => _preferences.getString(AppConstants.keyUserName);

  String? get currentUserEmail => _preferences.getString(AppConstants.keyUserEmail);

  String? get currentUserAvatar => _preferences.getString(AppConstants.keyUserAvatar);

  Future<User?> getCurrentUser() async {
    final userId = currentUserId;
    if (userId != null) {
      return await _database.userDao.getUserById(userId);
    }
    return null;
  }

  // User management methods
  Future<User?> getUserById(int id) async {
    return await _database.userDao.getUserById(id);
  }

  Future<User?> getUserByEmail(String email) async {
    return await _database.userDao.getUserByEmail(email);
  }

  Future<void> updateUser(User user) async {
    await _database.userDao.updateUser(user.copyWith(updatedAt: DateTime.now()));
    
    // Update session if it's the current user
    if (currentUserId == user.id) {
      await _saveUserSession(user);
    }
  }

  Future<void> updateUserAvatar(String avatarUrl) async {
    final userId = currentUserId;
    if (userId != null) {
      final user = await _database.userDao.getUserById(userId);
      if (user != null) {
        final updatedUser = user.copyWith(avatarUrl: avatarUrl, updatedAt: DateTime.now());
        await updateUser(updatedUser);
      }
    }
  }

  Future<bool> emailExists(String email) async {
    final count = await _database.userDao.countUsersByEmail(email);
    return (count ?? 0) > 0;
  }

  // Utility methods
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
} 