import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/patient_model.dart';
import 'package:lab_clinicas_self_service/src/models/self_service_model.dart';
import 'package:lab_clinicas_self_service/src/repositories/information_form/i_information_form_repository.dart';

class InformationFormRepository implements IInformationFormRepository {
  
  final RestClient _restClient;

  InformationFormRepository({
    required RestClient restClient,
  }) : _restClient = restClient;

  @override
  Future<Either<RepositoryException, Unit>> register(SelfServiceModel model) async {
    
    try {

      final SelfServiceModel(
        :name!,
        :lastName!,
        patient: PatientModel(id: patientId)!,
        documents: {
          DocumentType.healthInsuranceCard: List(first: healthInsuranceCardDoc),
          DocumentType.medicalOrder: medicalOrderDocs,
        }!
      ) = model;

      await _restClient.auth.post(
        "/patientInformationForm",
        data: {
          "patient_id": patientId,
          "health_insurance_card": healthInsuranceCardDoc,
          "medical_order": medicalOrderDocs,
          "password": "$name $lastName",
          "date_created": DateTime.now().toIso8601String(),
          "status": "Waiting",
          "tests": [],
        }
      );

      return Right(unit);

    } on DioException catch(e,s) {
      log("Erro ao finalizar formulário de auto atendimento", error: e, stackTrace: s);

      return Left(RepositoryException());
    }
  }
}