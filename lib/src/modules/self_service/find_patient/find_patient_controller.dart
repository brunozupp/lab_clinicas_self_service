import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/patient_model.dart';
import 'package:lab_clinicas_self_service/src/repositories/patients/patients_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

class FindPatientController with MessageStateMixin {
  final PatientsRepository _patientsRepository;

  FindPatientController({
    required PatientsRepository patientsRepository,
  }) : _patientsRepository = patientsRepository;

  final _patientNotFound = ValueSignal<bool?>(null);
  bool? get patientNotFound => _patientNotFound();

  final _patient = ValueSignal<PatientModel?>(null);
  PatientModel? get patient => _patient();

  Future<void> findPatientByDocument(String document) async {
    final patientResult = await _patientsRepository.findPatientByDocument(document);

    bool patientNotFound;
    PatientModel? patient;

    switch(patientResult) {
      case Right(value: PatientModel model?):
        patientNotFound = false;
        patient = model;
      case Right(value: _):
        patientNotFound = true;
        patient = null;
      case Left():
        showError("Erro ao buscar paciente");
        return;
    }

    // Todos os signals serem notificados de uma vez e não um de cada vez caso deixasse sem esse batch
    batch(() {
      _patient.value = patient;
      _patientNotFound.forceUpdate(patientNotFound);
    });
  }

  void continueWithoutDocument() {
    batch(() {
      _patient.value = null;
      _patientNotFound.forceUpdate(true);
    });
  }
}
