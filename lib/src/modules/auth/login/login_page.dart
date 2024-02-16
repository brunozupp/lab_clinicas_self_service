import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/core/constants/images_constants.dart';
import 'package:lab_clinicas_self_service/src/modules/auth/login/login_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MessageViewMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  final controller = Injector.get<LoginController>();

  @override
  void initState() {
    
    effect(() {
      if(controller.logged) {
        Navigator.of(context).pushReplacementNamed("/home");
      }
    });
    
    messageListener(controller);

    super.initState();
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: sizeOf.height,
          ),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(ImagesConstants.backgroundLogin),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              constraints: BoxConstraints(
                maxWidth: sizeOf.width * 0.8,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Login",
                      style: LabClinicasTheme.titleStyle,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: _emailEC,
                      validator: Validatorless.multiple([
                        Validatorless.required("Email obrigatório"),
                        Validatorless.email("Email inválido"),
                      ]),
                      decoration: const InputDecoration(
                        label: Text("Email"),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Watch((_) {
                      return TextFormField(
                        controller: _passwordEC,
                        obscureText: controller.obscurePassword,
                        validator: Validatorless.required("Senha obrigatória"),
                        decoration: InputDecoration(
                          label: const Text("Senha"),
                          suffixIcon: IconButton(
                            onPressed: controller.togglePassword,
                            icon: Icon(
                              controller.obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: sizeOf.width * 0.8,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final valid =
                              _formKey.currentState?.validate() ?? false;

                          if (valid) {
                            controller.login(_emailEC.text, _passwordEC.text);
                          }
                        },
                        child: const Text("ENTRAR"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
