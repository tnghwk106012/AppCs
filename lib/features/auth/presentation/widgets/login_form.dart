import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/auth_provider.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/cs_button.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailCtl = TextEditingController(text: 'demo@cs.ai');
    final pwdCtl = TextEditingController(text: 'pass');

    final loginState = ref.watch(
      authProvider((emailCtl.text, pwdCtl.text)),
    );

    ref.listen<AsyncValue>(
      authProvider((emailCtl.text, pwdCtl.text)),
      (prev, next) {
        next.whenOrNull(
          data: (_) => context.go('/notes'),
          error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          ),
        );
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(controller: emailCtl, decoration: const InputDecoration(labelText: 'Email')),
        TextField(controller: pwdCtl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
        const SizedBox(height: 20),
        AsyncValueWidget(
          value: loginState,
          data: (_) => CsButton(label: 'Login', onPressed: () {
            ref.refresh(authProvider((emailCtl.text, pwdCtl.text)));
          }),
        ),
      ],
    );
  }
} 