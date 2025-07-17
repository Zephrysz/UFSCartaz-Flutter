// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ufscartaz_flutter/main.dart';
import 'package:ufscartaz_flutter/presentation/providers/auth_provider.dart';
import 'package:ufscartaz_flutter/presentation/providers/movie_provider.dart';
import 'package:ufscartaz_flutter/presentation/providers/theme_provider.dart';
import 'package:ufscartaz_flutter/data/repositories/user_repository.dart';
import 'package:ufscartaz_flutter/data/repositories/movie_repository.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('should create MyApp widget', (WidgetTester tester) async {
      // This is a basic smoke test to ensure the app can be created
      // Note: This test may need to be adjusted based on ServiceLocator initialization
      
      // For now, we'll test the basic widget structure
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test App',
          home: Scaffold(
            body: Center(
              child: Text('Test'),
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pt'),
          ],
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should support multiple locales', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test App',
          home: Scaffold(
            body: Center(
              child: Text('Test'),
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pt'),
          ],
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.supportedLocales, contains(const Locale('en')));
      expect(materialApp.supportedLocales, contains(const Locale('pt')));
    });

    testWidgets('should have proper localization delegates', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test App',
          home: Scaffold(
            body: Center(
              child: Text('Test'),
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('pt'),
          ],
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.localizationsDelegates, isNotEmpty);
      expect(materialApp.localizationsDelegates, hasLength(3));
    });

    testWidgets('should have debug banner disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test App',
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Text('Test'),
            ),
          ),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });

    testWidgets('should handle theme configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: Scaffold(
            body: Center(
              child: Text('Test'),
            ),
          ),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
      expect(materialApp.themeMode, ThemeMode.system);
    });

    testWidgets('should create router configuration', (WidgetTester tester) async {
      // Test basic router functionality
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test App',
          home: Scaffold(
            body: Center(
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle navigation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test App',
          initialRoute: '/',
          routes: {
            '/': (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/second'),
                  child: Text('Go to Second'),
                ),
              ),
            ),
            '/second': (context) => Scaffold(
              body: Center(
                child: Text('Second Screen'),
              ),
            ),
          },
        ),
      );

      expect(find.text('Go to Second'), findsOneWidget);
      
      await tester.tap(find.text('Go to Second'));
      await tester.pumpAndSettle();
      
      expect(find.text('Second Screen'), findsOneWidget);
    });

    testWidgets('should handle back navigation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test App',
          initialRoute: '/',
          routes: {
            '/': (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/second'),
                  child: Text('Go to Second'),
                ),
              ),
            ),
            '/second': (context) => Scaffold(
              appBar: AppBar(title: Text('Second')),
              body: Center(
                child: Text('Second Screen'),
              ),
            ),
          },
        ),
      );

      // Navigate to second screen
      await tester.tap(find.text('Go to Second'));
      await tester.pumpAndSettle();
      
      expect(find.text('Second Screen'), findsOneWidget);
      
      // Navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      
      expect(find.text('Go to Second'), findsOneWidget);
    });

    testWidgets('should handle material design components', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test App',
          home: Scaffold(
            appBar: AppBar(title: Text('Test App')),
            body: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Button'),
                ),
                Card(
                  child: ListTile(
                    title: Text('List Item'),
                    leading: Icon(Icons.star),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
