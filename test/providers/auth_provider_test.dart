import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ufscartaz_flutter/data/models/user.dart';
import 'package:ufscartaz_flutter/data/repositories/user_repository.dart';
import 'package:ufscartaz_flutter/presentation/providers/auth_provider.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  group('AuthProvider Tests', () {
    late MockUserRepository mockUserRepository;
    late AuthProvider authProvider;
    late User testUser;

    setUp(() {
      mockUserRepository = MockUserRepository();
      testUser = User(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        passwordHash: 'hashedpassword123',
        avatarUrl: 'https://example.com/avatar.jpg',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    group('Initial State', () {
      test('should have correct initial state when user is not logged in', () {
        when(mockUserRepository.isLoggedIn).thenReturn(false);
        
        authProvider = AuthProvider(mockUserRepository);
        
        expect(authProvider.currentUser, null);
        expect(authProvider.isLoading, false);
        expect(authProvider.error, null);
        expect(authProvider.isAuthenticated, false);
      });

      test('should load current user when user is logged in', () async {
        when(mockUserRepository.isLoggedIn).thenReturn(true);
        when(mockUserRepository.getCurrentUser()).thenAnswer((_) async => testUser);
        
        authProvider = AuthProvider(mockUserRepository);
        
        // Wait for async initialization
        await Future.delayed(Duration.zero);
        
        expect(authProvider.currentUser, testUser);
        expect(authProvider.isAuthenticated, true);
        verify(mockUserRepository.getCurrentUser()).called(1);
      });
    });

    group('Login', () {
      setUp(() {
        when(mockUserRepository.isLoggedIn).thenReturn(false);
        authProvider = AuthProvider(mockUserRepository);
      });

      test('should login successfully with valid credentials', () async {
        when(mockUserRepository.login('test@example.com', 'password123'))
            .thenAnswer((_) async => testUser);
        
        final result = await authProvider.login('test@example.com', 'password123');
        
        expect(result, true);
        expect(authProvider.currentUser, testUser);
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.error, null);
        expect(authProvider.isLoading, false);
        verify(mockUserRepository.login('test@example.com', 'password123')).called(1);
      });

      test('should fail login with invalid credentials', () async {
        when(mockUserRepository.login('test@example.com', 'wrongpassword'))
            .thenAnswer((_) async => null);
        
        final result = await authProvider.login('test@example.com', 'wrongpassword');
        
        expect(result, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.error, 'Invalid email or password');
        expect(authProvider.isLoading, false);
        verify(mockUserRepository.login('test@example.com', 'wrongpassword')).called(1);
      });

      test('should handle login exception', () async {
        when(mockUserRepository.login('test@example.com', 'password123'))
            .thenThrow(Exception('Network error'));
        
        final result = await authProvider.login('test@example.com', 'password123');
        
        expect(result, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.error, 'Exception: Network error');
        expect(authProvider.isLoading, false);
        verify(mockUserRepository.login('test@example.com', 'password123')).called(1);
      });

      test('should set loading state during login', () async {
        when(mockUserRepository.login('test@example.com', 'password123'))
            .thenAnswer((_) async {
          // Verify loading state is true during async operation
          expect(authProvider.isLoading, true);
          return testUser;
        });
        
        await authProvider.login('test@example.com', 'password123');
        
        expect(authProvider.isLoading, false);
      });
    });

    group('Register', () {
      setUp(() {
        when(mockUserRepository.isLoggedIn).thenReturn(false);
        authProvider = AuthProvider(mockUserRepository);
      });

      test('should register successfully with valid data', () async {
        when(mockUserRepository.register('Test User', 'test@example.com', 'password123'))
            .thenAnswer((_) async => testUser);
        
        final result = await authProvider.register('Test User', 'test@example.com', 'password123');
        
        expect(result, true);
        expect(authProvider.currentUser, testUser);
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.error, null);
        expect(authProvider.isLoading, false);
        verify(mockUserRepository.register('Test User', 'test@example.com', 'password123')).called(1);
      });

      test('should register successfully with avatar URL', () async {
        const avatarUrl = 'https://example.com/avatar.jpg';
        when(mockUserRepository.register('Test User', 'test@example.com', 'password123', avatarUrl: avatarUrl))
            .thenAnswer((_) async => testUser);
        
        final result = await authProvider.register('Test User', 'test@example.com', 'password123', avatarUrl: avatarUrl);
        
        expect(result, true);
        expect(authProvider.currentUser, testUser);
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.error, null);
        expect(authProvider.isLoading, false);
        verify(mockUserRepository.register('Test User', 'test@example.com', 'password123', avatarUrl: avatarUrl)).called(1);
      });

      test('should fail registration when repository returns null', () async {
        when(mockUserRepository.register('Test User', 'test@example.com', 'password123'))
            .thenAnswer((_) async => null);
        
        final result = await authProvider.register('Test User', 'test@example.com', 'password123');
        
        expect(result, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.isLoading, false);
        verify(mockUserRepository.register('Test User', 'test@example.com', 'password123')).called(1);
      });

      test('should handle registration exception', () async {
        when(mockUserRepository.register('Test User', 'test@example.com', 'password123'))
            .thenThrow(Exception('Email already exists'));
        
        final result = await authProvider.register('Test User', 'test@example.com', 'password123');
        
        expect(result, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.error, 'Exception: Email already exists');
        expect(authProvider.isLoading, false);
        verify(mockUserRepository.register('Test User', 'test@example.com', 'password123')).called(1);
      });

      test('should set loading state during registration', () async {
        when(mockUserRepository.register('Test User', 'test@example.com', 'password123'))
            .thenAnswer((_) async {
          // Verify loading state is true during async operation
          expect(authProvider.isLoading, true);
          return testUser;
        });
        
        await authProvider.register('Test User', 'test@example.com', 'password123');
        
        expect(authProvider.isLoading, false);
      });
    });

    group('Logout', () {
      setUp(() {
        when(mockUserRepository.isLoggedIn).thenReturn(true);
        when(mockUserRepository.getCurrentUser()).thenAnswer((_) async => testUser);
        authProvider = AuthProvider(mockUserRepository);
      });

      test('should logout successfully', () async {
        when(mockUserRepository.logout()).thenAnswer((_) async => {});
        
        await authProvider.logout();
        
        expect(authProvider.currentUser, null);
        expect(authProvider.isAuthenticated, false);
        verify(mockUserRepository.logout()).called(1);
      });
    });

    group('Update Avatar', () {
      setUp(() {
        when(mockUserRepository.isLoggedIn).thenReturn(true);
        when(mockUserRepository.getCurrentUser()).thenAnswer((_) async => testUser);
        authProvider = AuthProvider(mockUserRepository);
      });

      test('should update avatar successfully', () async {
        const newAvatarUrl = 'https://example.com/new-avatar.jpg';
        when(mockUserRepository.updateUserAvatar(newAvatarUrl))
            .thenAnswer((_) async => {});
        
        await authProvider.updateAvatar(newAvatarUrl);
        
        expect(authProvider.currentUser?.avatarUrl, newAvatarUrl);
        expect(authProvider.error, null);
        verify(mockUserRepository.updateUserAvatar(newAvatarUrl)).called(1);
      });

      test('should handle update avatar exception', () async {
        const newAvatarUrl = 'https://example.com/new-avatar.jpg';
        when(mockUserRepository.updateUserAvatar(newAvatarUrl))
            .thenThrow(Exception('Update failed'));
        
        await authProvider.updateAvatar(newAvatarUrl);
        
        expect(authProvider.error, 'Exception: Update failed');
        verify(mockUserRepository.updateUserAvatar(newAvatarUrl)).called(1);
      });

      test('should not update avatar when user is null', () async {
        when(mockUserRepository.isLoggedIn).thenReturn(false);
        authProvider = AuthProvider(mockUserRepository);
        
        const newAvatarUrl = 'https://example.com/new-avatar.jpg';
        when(mockUserRepository.updateUserAvatar(newAvatarUrl))
            .thenAnswer((_) async => {});
        
        await authProvider.updateAvatar(newAvatarUrl);
        
        expect(authProvider.currentUser, null);
        verify(mockUserRepository.updateUserAvatar(newAvatarUrl)).called(1);
      });
    });

    group('Error Handling', () {
      setUp(() {
        when(mockUserRepository.isLoggedIn).thenReturn(false);
        authProvider = AuthProvider(mockUserRepository);
      });

      test('should clear error', () async {
        // Set an error first
        when(mockUserRepository.login('test@example.com', 'wrongpassword'))
            .thenAnswer((_) async => null);
        
        await authProvider.login('test@example.com', 'wrongpassword');
        expect(authProvider.error, 'Invalid email or password');
        
        // Clear the error
        authProvider.clearError();
        expect(authProvider.error, null);
      });

      test('should clear error before new login attempt', () async {
        // Set an error first
        when(mockUserRepository.login('test@example.com', 'wrongpassword'))
            .thenAnswer((_) async => null);
        
        await authProvider.login('test@example.com', 'wrongpassword');
        expect(authProvider.error, 'Invalid email or password');
        
        // New login attempt should clear previous error
        when(mockUserRepository.login('test@example.com', 'password123'))
            .thenAnswer((_) async => testUser);
        
        await authProvider.login('test@example.com', 'password123');
        expect(authProvider.error, null);
      });

      test('should clear error before new registration attempt', () async {
        // Set an error first
        when(mockUserRepository.register('Test User', 'test@example.com', 'password123'))
            .thenThrow(Exception('Registration failed'));
        
        await authProvider.register('Test User', 'test@example.com', 'password123');
        expect(authProvider.error, 'Exception: Registration failed');
        
        // New registration attempt should clear previous error
        when(mockUserRepository.register('New User', 'new@example.com', 'password123'))
            .thenAnswer((_) async => testUser);
        
        await authProvider.register('New User', 'new@example.com', 'password123');
        expect(authProvider.error, null);
      });
    });
  });
} 