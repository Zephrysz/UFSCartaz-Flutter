import 'package:flutter_test/flutter_test.dart';
import 'package:ufscartaz_flutter/data/models/user.dart';

void main() {
  group('User Model Tests', () {
    late User testUser;
    late DateTime testDateTime;

    setUp(() {
      testDateTime = DateTime(2024, 1, 1, 12, 0, 0);
      testUser = User(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        passwordHash: 'hashedpassword123',
        avatarUrl: 'https://example.com/avatar.jpg',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );
    });

    test('should create User instance with all properties', () {
      expect(testUser.id, 1);
      expect(testUser.name, 'Test User');
      expect(testUser.email, 'test@example.com');
      expect(testUser.passwordHash, 'hashedpassword123');
      expect(testUser.avatarUrl, 'https://example.com/avatar.jpg');
      expect(testUser.createdAt, testDateTime);
      expect(testUser.updatedAt, testDateTime);
    });

    test('should create User instance without optional properties', () {
      final userWithoutOptionals = User(
        name: 'Test User',
        email: 'test@example.com',
        passwordHash: 'hashedpassword123',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      expect(userWithoutOptionals.id, null);
      expect(userWithoutOptionals.avatarUrl, null);
      expect(userWithoutOptionals.name, 'Test User');
    });

    test('should serialize to JSON correctly', () {
      final json = testUser.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test User');
      expect(json['email'], 'test@example.com');
      expect(json['passwordHash'], 'hashedpassword123');
      expect(json['avatarUrl'], 'https://example.com/avatar.jpg');
      expect(json['createdAt'], testDateTime.toIso8601String());
      expect(json['updatedAt'], testDateTime.toIso8601String());
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'passwordHash': 'hashedpassword123',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'createdAt': testDateTime.toIso8601String(),
        'updatedAt': testDateTime.toIso8601String(),
      };

      final user = User.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.passwordHash, 'hashedpassword123');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.createdAt, testDateTime);
      expect(user.updatedAt, testDateTime);
    });

    test('should create copy with updated properties', () {
      final updatedUser = testUser.copyWith(
        name: 'Updated Name',
        email: 'updated@example.com',
        avatarUrl: 'https://example.com/new-avatar.jpg',
      );

      expect(updatedUser.id, testUser.id);
      expect(updatedUser.name, 'Updated Name');
      expect(updatedUser.email, 'updated@example.com');
      expect(updatedUser.passwordHash, testUser.passwordHash);
      expect(updatedUser.avatarUrl, 'https://example.com/new-avatar.jpg');
      expect(updatedUser.createdAt, testUser.createdAt);
      expect(updatedUser.updatedAt, testUser.updatedAt);
    });

    test('should maintain original properties when copyWith called with null', () {
      final copiedUser = testUser.copyWith();

      expect(copiedUser.id, testUser.id);
      expect(copiedUser.name, testUser.name);
      expect(copiedUser.email, testUser.email);
      expect(copiedUser.passwordHash, testUser.passwordHash);
      expect(copiedUser.avatarUrl, testUser.avatarUrl);
      expect(copiedUser.createdAt, testUser.createdAt);
      expect(copiedUser.updatedAt, testUser.updatedAt);
    });

    test('should implement equality correctly', () {
      final sameUser = User(
        id: 1,
        name: 'Different Name',
        email: 'test@example.com',
        passwordHash: 'differenthash',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final differentUser = User(
        id: 2,
        name: 'Test User',
        email: 'different@example.com',
        passwordHash: 'hashedpassword123',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      expect(testUser == sameUser, true);
      expect(testUser == differentUser, false);
      expect(testUser.hashCode == sameUser.hashCode, true);
      expect(testUser.hashCode == differentUser.hashCode, false);
    });

    test('should have correct string representation', () {
      final stringRepresentation = testUser.toString();
      expect(stringRepresentation, 'User{id: 1, name: Test User, email: test@example.com}');
    });

    test('should handle null values in JSON serialization', () {
      final userWithNulls = User(
        name: 'Test User',
        email: 'test@example.com',
        passwordHash: 'hashedpassword123',
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final json = userWithNulls.toJson();
      expect(json['id'], null);
      expect(json['avatarUrl'], null);
    });
  });
} 