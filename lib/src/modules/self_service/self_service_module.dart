import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/scan_confirm/documents_scan_confirm_router.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/done/done_page.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/find_patient/find_patient_router.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/patient/patient_router.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_page.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/who_i_am/who_i_am_page.dart';
import 'package:lab_clinicas_self_service/src/repositories/information_form/i_information_form_repository.dart';
import 'package:lab_clinicas_self_service/src/repositories/information_form/information_form_repository.dart';
import 'package:lab_clinicas_self_service/src/repositories/patients/i_patients_repository.dart';
import 'package:lab_clinicas_self_service/src/repositories/patients/patients_repository.dart';

import 'documents/documents_page.dart';
import 'documents/scan/documents_scan_page.dart';

class SelfServiceModule extends FlutterGetItModule {

  @override
  List<Bind<Object>> get bindings => [
    Bind.lazySingleton<IInformationFormRepository>((i) => InformationFormRepository(restClient: i())),
    Bind.lazySingleton((i) => SelfServiceController(
      informationFormRepository: i(),
    )),
    Bind.lazySingleton<IPatientsRepository>((i) => PatientsRepository(restClient: i())),
  ];
  
  @override
  String get moduleRouteName => "/self-service";

  @override
  Map<String, WidgetBuilder> get pages => {
    "/": (context) => const SelfServicePage(),
    "/who-i-am": (context) => const WhoIAmPage(),
    "/find-patient": (context) => const FindPatientRouter(),
    "/patient": (context) => const PatientRouter(),
    "/documents": (context) => const DocumentsPage(),
    "/documents/scan": (context) => const DocumentsScanPage(),
    "/documents/scan/confirm": (context) => const DocumentsScanConfirmRouter(),
    "/done": (context) => DonePage(),
  };
}