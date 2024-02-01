import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_self_service/src/modules/auth/login/login_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/auth/login/login_page.dart';
import 'package:lab_clinicas_self_service/src/services/user_login/user_login_service.dart';

class LoginRouter extends FlutterGetItModulePageRouter {
  
  const LoginRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
    Bind.lazySingleton<LoginController>((i) => LoginController()),
    Bind.lazySingleton<UserLoginService>((i) => UserLoginService(
      userRepository: i(),
    )),
  ];

  @override
  WidgetBuilder get view => (_) => const LoginPage();
  
}