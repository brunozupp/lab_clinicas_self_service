import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/binding/lab_clinicias_application_binding.dart';
import 'package:lab_clinicas_self_service/src/modules/auth/auth_module.dart';
import 'package:lab_clinicas_self_service/src/modules/home/home_module.dart';

import 'src/pages/splash/splash_page.dart';

void main() {

  runZonedGuarded(() {
    runApp(const LabClinicasSelfServiceApp());
  }, (error, stack) { 
    log("Erro não tratado", error: error, stackTrace: stack);
    throw error;
  });

  
}

class LabClinicasSelfServiceApp extends StatelessWidget {
  const LabClinicasSelfServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LabClinicasCoreConfig(
      title: "Lab Clinicas Auto Atendimento",
      binding: LabCliniciasApplicationBinding(),
      pagesBuilders: [
        FlutterGetItPageBuilder(
          page: (_) => const SplashPage(), 
          path: "/",
        ),
      ],
      modules: [
        AuthModule(),
        HomeModule(),
      ],
    );
  }
}