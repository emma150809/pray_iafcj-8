import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:pray_iafcj/firebase_options.dart';
import 'package:pray_iafcj/core/app_navigator.dart';
import 'package:pray_iafcj/core/app_theme.dart';
import 'package:pray_iafcj/screens/about_screen.dart';
import 'package:pray_iafcj/screens/splash.dart';
import 'package:pray_iafcj/screens/welcome/welcome_screen.dart';
import 'package:pray_iafcj/screens/auth/login_screen.dart';
import 'package:pray_iafcj/screens/auth/register_screen.dart';
import 'package:pray_iafcj/screens/home/tab_shell.dart';
import 'package:pray_iafcj/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializa el servicio de notificaciones locales.
  // Esto no requiere configuración en Firebase.
  await NotificationService().init();

  // Programa la notificación diaria con una frase.
  await NotificationService().scheduleDailyPhraseNotification();

  runApp(const PrayIAFCJ());
}

class PrayIAFCJ extends StatelessWidget {
  const PrayIAFCJ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pray IAFCJ',
      theme: AppTheme.lightTheme,
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return AppNavigator.spa(const Splash());
          case '/':
          case '/welcome':
            return AppNavigator.spa(const WelcomeScreen());
          case '/login':
            return AppNavigator.spa(const LoginScreen());
          case '/register':
            return AppNavigator.spa(const RegisterScreen());
          case '/home':
            return AppNavigator.spa(const TabShell());
          case '/lectura':
            return AppNavigator.spa(const TabShell(initialIndex: 1));
          case '/oracion':
            return AppNavigator.spa(const TabShell(initialIndex: 2));
          case '/profile':
            return AppNavigator.spa(const TabShell(initialIndex: 3));
          case '/about':
            return AppNavigator.spa(const AboutScreen());
          default:
            return AppNavigator.spa(const WelcomeScreen());
        }
      },
    );
  }
}
