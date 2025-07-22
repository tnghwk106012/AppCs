import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/repositories/auth_fake_repo.dart';
import '../../domain/entities/user.dart';

final _repoProvider = Provider((_) => AuthFakeRepo());
 
final authProvider = FutureProvider.family<User?, (String, String)>((ref, creds) {
  final (email, pwd) = creds;
  return ref.read(_repoProvider).login(email, pwd);
}); 