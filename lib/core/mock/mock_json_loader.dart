import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
 
Future<List<Map<String, dynamic>>> loadMockJson(String path) async =>
    (jsonDecode(await rootBundle.loadString(path)) as List)
        .cast<Map<String, dynamic>>(); 