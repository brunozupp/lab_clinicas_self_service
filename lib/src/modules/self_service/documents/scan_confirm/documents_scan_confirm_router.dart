import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/scan_confirm/documents_scan_confirm_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/scan_confirm/documents_scan_confirm_page.dart';
import 'package:lab_clinicas_self_service/src/repositories/documents/documents_repository.dart';
import 'package:lab_clinicas_self_service/src/repositories/documents/i_documents_repository.dart';

class DocumentsScanConfirmRouter extends FlutterGetItModulePageRouter {
  
  const DocumentsScanConfirmRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
    Bind.lazySingleton<IDocumentsRepository>(
      (i) => DocumentsRepository(
        restClient: i(),
      ),
    ),
    Bind.lazySingleton((i) => DocumentsScanConfirmController(
      documentsRepository: i(),
    )),
  ];
  
  @override
  WidgetBuilder get view => (_) => const DocumentsScanConfirmPage();
  
}