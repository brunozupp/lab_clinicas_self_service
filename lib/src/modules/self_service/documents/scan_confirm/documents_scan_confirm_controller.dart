import 'dart:typed_data';

import 'package:asyncstate/asyncstate.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/repositories/documents/i_documents_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

class DocumentsScanConfirmController with MessageStateMixin {
  
  DocumentsScanConfirmController({
    required IDocumentsRepository documentsRepository,
  }) : _documentsRepository = documentsRepository;

  final IDocumentsRepository _documentsRepository;
  
  final pathRemoteStorage = signal<String?>(null);

  Future<void> uploadImage(Uint8List imageBytes, String fileName) async {

    final result = await _documentsRepository.uploadImage(imageBytes, fileName).asyncLoader();

    switch(result) {
      case Right(value: final pathImage):
        pathRemoteStorage.value = pathImage;
      case Left():
        showError("Erro ao fazer upload da imagem");
    }
  }
}