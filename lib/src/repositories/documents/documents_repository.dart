import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/repositories/documents/i_documents_repository.dart';

class DocumentsRepository implements IDocumentsRepository {
  
  final RestClient _restClient;

  DocumentsRepository({
    required RestClient restClient,
  }) : _restClient = restClient;
  
  @override
  Future<Either<RepositoryException, String>> uploadImage(Uint8List file, String fileName) async {
    
    try {
      final formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(file, filename: fileName),
      });
      
      final Response(data: {'url': pathImage}) = await _restClient.auth.post("/uploads", data: formData);
      
      return Right(pathImage);
    } on DioException catch (e,s) {
      log("Erro ao fazer upload", error: e, stackTrace: s);

      return Left(RepositoryException());
    }
  }
  
}