import 'package:hello_world_app/core/mock/mock_delay.dart';
import '../../domain/entities/user.dart';

class AuthFakeRepo {
  Future<User?> login(String email, String password) async {
    await Future.delayed(kMockLatency);
    if (email == 'demo@cs.ai' && password == 'pass') {
      return const User(id: 1, email: 'demo@cs.ai');
    }
    throw Exception('로그인 실패');
  }
} 