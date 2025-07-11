import 'package:floor/floor.dart';
import '../models/user.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users WHERE id = :id')
  Future<User?> getUserById(int id);
  
  @Query('SELECT * FROM users WHERE email = :email')
  Future<User?> getUserByEmail(String email);
  
  @Query('SELECT * FROM users WHERE email = :email AND password_hash = :passwordHash')
  Future<User?> getUserByEmailAndPassword(String email, String passwordHash);
  
  @Query('SELECT * FROM users')
  Future<List<User>> getAllUsers();
  
  @insert
  Future<int> insertUser(User user);
  
  @update
  Future<int> updateUser(User user);
  
  @delete
  Future<int> deleteUser(User user);
  
  @Query('DELETE FROM users WHERE id = :id')
  Future<int?> deleteUserById(int id);
  
  @Query('SELECT COUNT(*) FROM users WHERE email = :email')
  Future<int?> countUsersByEmail(String email);
  
  @Query('SELECT COUNT(*) FROM users')
  Future<int?> getUserCount();
} 