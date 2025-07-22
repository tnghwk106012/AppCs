import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bootstrap.dart';
import 'core/theme/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'features/splash/splash_page.dart';

void main() async {
  await bootstrap();
  runApp(const ProviderScope(child: CareSyncApp()));
}

class CareSyncApp extends StatefulWidget {
  const CareSyncApp({super.key});
  @override
  State<CareSyncApp> createState() => _CareSyncAppState();
}

class _CareSyncAppState extends State<CareSyncApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareSync',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ko', 'KR'),
      home: const SplashPage(),
    );
  }
}
