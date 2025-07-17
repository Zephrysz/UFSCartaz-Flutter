import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ufscartaz_flutter/core/utils/service_locator.dart';
import 'package:ufscartaz_flutter/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufscartaz_flutter/presentation/screens/welcome_screen.dart';

void main() {
  // Garante que o binding de integração esteja pronto
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    // --- SETUP ÚNICO ---
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await ServiceLocator.init();
    });

    // --- TESTE DE FLUXO PRINCIPAL ---
    testWidgets('Fluxo de inicialização: da Splash Screen à primeira tela', (WidgetTester tester) async {
      // 1. CARREGA O APP
      await tester.pumpWidget(const app.MyApp());

      // 2. VERIFICA O ESTADO INICIAL (SPLASH SCREEN)
      expect(find.byType(MaterialApp), findsOneWidget, reason: 'O MaterialApp deve ser carregado no início.');

      // 3. AGUARDA A TRANSIÇÃO DA SPLASH
      await tester.pumpAndSettle();

      // 4. VERIFICA A PRÓXIMA TELA
      // É a WelcomeScreen? É a LoginScreen? É a HomeScreen?
      expect(find.byType(WelcomeScreen), findsOneWidget, reason: 'A tela de boas-vindas deve aparecer após a splash.');
    });


    // --- TESTES DE CONFIGURAÇÃO E PROPRIEDADES ---

    testWidgets('Deve verificar as configurações de localização', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(materialApp.supportedLocales, contains(const Locale('en')), reason: 'Deve suportar o idioma inglês.');
      expect(materialApp.supportedLocales, contains(const Locale('pt')), reason: 'Deve suportar o idioma português.');
    });


    // --- TESTES DE ADAPTABILIDADE DA UI ---

    testWidgets('Deve se adaptar a diferentes tamanhos de tela e orientações', (WidgetTester tester) async {
      await tester.pumpWidget(const app. MyApp());
      await tester.pumpAndSettle();

      // Teste em tamanho de celular (Retrato)
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget, reason: 'App deve se manter estável em modo retrato.');

      // Teste em tamanho de celular (Paisagem)
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget, reason: 'App deve se manter estável em modo paisagem.');

      // Teste em tamanho de tablet
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget, reason: 'App deve se manter estável em tela de tablet.');

      // Opcional: Voltar ao tamanho original no final
      await tester.binding.setSurfaceSize(null);
      await tester.pumpAndSettle();
    });
  });
}