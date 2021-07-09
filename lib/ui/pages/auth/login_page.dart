import 'package:diiket_models/src/custom_exception.dart';
import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookWidget {
  static String route = 'driver/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      body: ProviderListener(
        provider: authExceptionProvider,
        onChange: _onAuthExceptionChange,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Masuk',
                    style: kTextTheme.headline1,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      if (!formKey.currentState!.validate()) return;

                      context
                          .read(authProvider.notifier)
                          .signInWithEmailAndPassword(
                            emailController.text,
                            passwordController.text,
                          );
                    },
                    child: Text('Masuk'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onAuthExceptionChange(
    BuildContext context,
    StateController<CustomException?> value,
  ) {
    if (value.state != null) {
      Utils.alert(context, value.state?.message ?? 'Terjadi kesalahan');
    }
  }
}
