# UFSCartaz Flutter Test Suite

This directory contains comprehensive tests for the UFSCartaz Flutter application, covering unit tests, widget tests, and integration tests.

## Test Structure

```
test/
├── models/              # Unit tests for data models
│   ├── user_test.dart
│   ├── movie_test.dart
│   └── movie_history_entry_test.dart
├── providers/           # Unit tests for state management
│   ├── auth_provider_test.dart
│   ├── movie_provider_test.dart
│   └── theme_provider_test.dart
├── widgets/             # Widget tests for UI components
│   ├── movie_card_test.dart
│   └── movie_list_test.dart
├── integration/         # Integration tests
│   └── app_integration_test.dart
├── widget_test.dart     # Main widget tests
└── README.md           # This file
```

## Types of Tests

### 1. Unit Tests
- **Models**: Test data models, serialization, and business logic
- **Providers**: Test state management and business logic
- **Repositories**: Test data access and API interactions
- **Services**: Test API services and utilities

### 2. Widget Tests
- **UI Components**: Test individual widgets and their behavior
- **User Interactions**: Test tap, scroll, and other user interactions
- **State Changes**: Test how widgets respond to state changes
- **Accessibility**: Test accessibility features

### 3. Integration Tests
- **User Flows**: Test complete user journeys
- **Navigation**: Test app navigation and routing
- **State Persistence**: Test data persistence across app sessions
- **Performance**: Test app performance and responsiveness

## Running Tests

### Prerequisites
1. Flutter SDK installed
2. Dependencies installed: `flutter pub get`
3. Mocks generated: `flutter pub run build_runner build`

### Running All Tests
```bash
# Run the test runner script
chmod +x test_runner.sh
./test_runner.sh

# Or run manually
flutter test --coverage
```

### Running Specific Test Categories
```bash
# Unit tests only
flutter test test/models/ test/providers/

# Widget tests only
flutter test test/widgets/

# Integration tests only
flutter test test/integration/

# Specific test file
flutter test test/models/user_test.dart
```

### Running Tests with Coverage
```bash
# Generate coverage report
flutter test --coverage

# Generate HTML coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
```

## Test Configuration

### Dependencies
The following testing dependencies are included in `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  mocktail: ^1.0.4
  bloc_test: ^9.1.7
  golden_toolkit: ^0.15.0
  integration_test:
    sdk: flutter
  patrol: ^3.12.0
```

### Mock Generation
Mocks are generated using `mockito` and `build_runner`:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Test Patterns

### Unit Test Pattern
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('ComponentName Tests', () {
    late ComponentName component;
    
    setUp(() {
      component = ComponentName();
    });
    
    test('should do something', () {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### Widget Test Pattern
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetName Tests', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: WidgetName(),
        ),
      );
    }
    
    testWidgets('should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.text('Expected Text'), findsOneWidget);
    });
  });
}
```

### Integration Test Pattern
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Integration Tests', () {
    testWidgets('should complete user flow', (WidgetTester tester) async {
      // Test complete user journey
    });
  });
}
```

## Test Coverage

### Coverage Goals
- **Unit Tests**: 90%+ coverage for business logic
- **Widget Tests**: 80%+ coverage for UI components
- **Integration Tests**: Cover all critical user flows

### Coverage Reports
Coverage reports are generated in the `coverage/` directory:
- `coverage/lcov.info`: LCOV format for CI/CD
- `coverage/html/`: HTML report for viewing in browser

### Viewing Coverage
```bash
# Generate and open HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Continuous Integration

### GitHub Actions
Example workflow for running tests in CI:

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.1'
      - run: flutter pub get
      - run: flutter pub run build_runner build
      - run: flutter test --coverage
      - run: flutter analyze
```

## Best Practices

### Test Organization
1. **Group related tests** using `group()`
2. **Use descriptive test names** that explain what is being tested
3. **Follow AAA pattern**: Arrange, Act, Assert
4. **Keep tests independent** and isolated

### Mocking
1. **Mock external dependencies** (APIs, databases, etc.)
2. **Use dependency injection** for testability
3. **Verify interactions** with mocks when necessary

### Widget Testing
1. **Test user interactions** not just display
2. **Test accessibility** features
3. **Test different screen sizes** and orientations
4. **Use `pumpAndSettle()`** for animations

### Integration Testing
1. **Test critical user flows** end-to-end
2. **Test on real devices** when possible
3. **Keep tests stable** and avoid flakiness
4. **Test performance** characteristics

## Troubleshooting

### Common Issues

1. **Mock generation fails**
   ```bash
   flutter pub run build_runner clean
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Tests fail due to async operations**
   ```dart
   await tester.pumpAndSettle();
   ```

3. **Widget not found in tests**
   ```dart
   await tester.pumpWidget(MaterialApp(home: YourWidget()));
   ```

4. **Coverage not generated**
   ```bash
   flutter test --coverage --test-randomize-ordering-seed random
   ```

### Debug Tips
- Use `debugDumpApp()` to see widget tree
- Use `tester.binding.window.physicalSizeTestValue` for screen size testing
- Use `WidgetTester.printToConsole()` for debugging

## Contributing

When adding new features:
1. **Write tests first** (TDD approach)
2. **Maintain test coverage** above 80%
3. **Update this README** if adding new test patterns
4. **Run full test suite** before committing

## Resources

- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Integration Testing](https://flutter.dev/docs/testing/integration-tests)
- [Golden Toolkit](https://pub.dev/packages/golden_toolkit) 