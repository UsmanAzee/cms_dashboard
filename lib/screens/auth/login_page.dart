import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/views/async_widgets.dart';
import '../../providers/services/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  final GoRouterState? routerState;

  const LoginPage({super.key, this.routerState});

  static String get routeName => 'login';

  static String get routeLocation => '/$routeName';

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController emailInputController;
  late final TextEditingController passInputController;

  @override
  void initState() {
    emailInputController = TextEditingController();
    passInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailInputController.dispose();
    passInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider.notifier);

    return Scaffold(
      appBar: null,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Login Page"),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autofillHints: const [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                          controller: emailInputController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            label: Text("Email"),
                          ),
                        ),
                        TextFormField(
                          autofillHints: const [AutofillHints.password],
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          controller: passInputController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            label: Text("Password"),
                          ),
                        ),
                        const SizedBox(height: 16),
                        LoadingButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              await auth.signInWithEmailAndPassword(
                                emailInputController.value.text,
                                passInputController.value.text,
                              );
                            }
                          },
                          label: 'Sign in with Email',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              LoadingButton(
                onPressed: () async {
                  try {
                    await auth.signInAnonymously();
                  } catch (err) {
                    debugPrint("Error signing in anonymously: $err");
                  }
                },
                label: "Login Anonymously",
              ),
              const SizedBox(height: 20),
              LoadingButton(
                onPressed: () async {
                  final bool isAuthenticated = await auth.localAuthentication();
                  debugPrint("biometric authenticated? : $isAuthenticated");
                },
                label: "Biometric authentication",
              ),
              const SizedBox(height: 20),
              LoadingButton(
                onPressed: () async {
                  try {
                    // await auth.signInWithGoogle();
                    await auth.signInWithGoogleWeb();
                  } catch (err) {
                    debugPrint("Error signing in using google: $err");
                  }
                },
                imageAsset: "assets/images/google_logo.png",
                label: "Sign in with Google",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
