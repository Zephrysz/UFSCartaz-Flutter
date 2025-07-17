import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufscartaz_flutter/presentation/providers/theme_provider.dart';

void main() {
  group('ThemeProvider Tests', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    test('should have system theme as default', () {
      expect(themeProvider.themeMode, ThemeMode.system);
    });

    test('should set theme mode to light', () async {
      await themeProvider.setThemeMode(ThemeMode.light);
      
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('should set theme mode to dark', () async {
      await themeProvider.setThemeMode(ThemeMode.dark);
      
      expect(themeProvider.themeMode, ThemeMode.dark);
    });

    test('should set theme mode to system', () async {
      await themeProvider.setThemeMode(ThemeMode.system);
      
      expect(themeProvider.themeMode, ThemeMode.system);
    });

    test('should toggle theme from light to dark', () async {
      await themeProvider.setThemeMode(ThemeMode.light);
      await themeProvider.toggleTheme();
      
      expect(themeProvider.themeMode, ThemeMode.dark);
    });

    test('should toggle theme from dark to system', () async {
      await themeProvider.setThemeMode(ThemeMode.dark);
      await themeProvider.toggleTheme();
      
      expect(themeProvider.themeMode, ThemeMode.system);
    });

    test('should toggle theme from system to light', () async {
      await themeProvider.setThemeMode(ThemeMode.system);
      await themeProvider.toggleTheme();
      
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('should notify listeners when theme changes', () async {
      bool notified = false;
      themeProvider.addListener(() {
        notified = true;
      });

      await themeProvider.setThemeMode(ThemeMode.dark);
      
      expect(notified, true);
    });

    test('should notify listeners when toggling theme', () async {
      bool notified = false;
      themeProvider.addListener(() {
        notified = true;
      });

      await themeProvider.toggleTheme();
      
      expect(notified, true);
    });

    test('should handle multiple theme changes', () async {
      final List<ThemeMode> themeModes = [];
      themeProvider.addListener(() {
        themeModes.add(themeProvider.themeMode);
      });

      await themeProvider.setThemeMode(ThemeMode.dark);
      await themeProvider.setThemeMode(ThemeMode.light);
      await themeProvider.setThemeMode(ThemeMode.system);

      expect(themeModes, [
        ThemeMode.dark,
        ThemeMode.light,
        ThemeMode.system,
      ]);
    });

    test('should return correct isDarkMode for dark theme', () async {
      await themeProvider.setThemeMode(ThemeMode.dark);
      
      expect(themeProvider.isDarkMode, true);
    });

    test('should return correct isDarkMode for light theme', () async {
      await themeProvider.setThemeMode(ThemeMode.light);
      
      expect(themeProvider.isDarkMode, false);
    });

    test('should handle system theme for isDarkMode', () async {
      await themeProvider.setThemeMode(ThemeMode.system);
      
      // For system mode, isDarkMode depends on platform brightness
      // We can't easily test this without mocking the platform
      // But we can at least verify it doesn't throw
      expect(() => themeProvider.isDarkMode, returnsNormally);
    });

    test('should complete full toggle cycle', () async {
      // Start with light
      await themeProvider.setThemeMode(ThemeMode.light);
      
      // Toggle to dark
      await themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.dark);
      
      // Toggle to system
      await themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.system);
      
      // Toggle back to light
      await themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('should dispose properly', () {
      // This test ensures the provider can be disposed without issues
      themeProvider.dispose();
      
      // After disposal, the provider should not be able to notify listeners
      // This is more of a smoke test to ensure dispose() doesn't throw
      expect(() => themeProvider.dispose(), returnsNormally);
    });
  });
} 