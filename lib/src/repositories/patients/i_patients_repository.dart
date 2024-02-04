import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/patient_model.dart';

abstract interface class IPatientsRepository {

  Future<Either<RepositoryException,PatientModel>> findPatientByDocument(String document);
}