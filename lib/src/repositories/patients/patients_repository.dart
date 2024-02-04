import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/patient_model.dart';
import 'package:lab_clinicas_self_service/src/repositories/patients/i_patients_repository.dart';

class PatientsRepository implements IPatientsRepository {

  @override
  Future<Either<RepositoryException, PatientModel>> findPatientByDocument(String document) {
    // TODO: implement findPatientByDocument
    throw UnimplementedError();
  }
  
}