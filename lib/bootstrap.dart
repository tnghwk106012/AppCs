// lib/bootstrap.dart
import 'package:flutter/widgets.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();  // MVP 단계 생략
} 