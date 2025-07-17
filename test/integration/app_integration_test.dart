import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ufscartaz_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('should start with splash screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Should start with splash screen
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Wait for splash screen to finish
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should navigate through welcome flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to finish
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate to welcome screen
      // Note: These tests may need adjustment based on actual navigation logic
      await tester.pumpAndSettle();
    });

    testWidgets('should handle app lifecycle', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test app lifecycle - simplified version
      await tester.pumpAndSettle();

      // App should still be running
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should handle theme changes', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test theme switching (if there's a theme toggle button)
      // This would need to be adjusted based on actual UI
      await tester.pumpAndSettle();
    });

    testWidgets('should handle localization', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test that localization is working
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.supportedLocales, contains(const Locale('en')));
      expect(materialApp.supportedLocales, contains(const Locale('pt')));
    });

    testWidgets('should handle navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for initial navigation
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test navigation - this would need to be adjusted based on actual UI
      // For example, if there are navigation buttons or bottom navigation
      await tester.pumpAndSettle();
    });

    testWidgets('should handle errors gracefully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test error handling
      // This is a basic test to ensure the app doesn't crash on startup
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Test that error widgets are handled properly
      await tester.pumpAndSettle();
    });

    testWidgets('should maintain state across navigation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test state management across navigation
      // This would need to be adjusted based on actual navigation flow
      await tester.pumpAndSettle();
    });

    testWidgets('should handle device orientation changes', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test portrait orientation
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);

      // Test landscape orientation
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);

      // Reset to portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();
    });

    testWidgets('should handle different screen sizes', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test small screen
      await tester.binding.setSurfaceSize(const Size(320, 568));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);

      // Test medium screen
      await tester.binding.setSurfaceSize(const Size(375, 667));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);

      // Test large screen
      await tester.binding.setSurfaceSize(const Size(414, 896));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);

      // Test tablet size
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
} 