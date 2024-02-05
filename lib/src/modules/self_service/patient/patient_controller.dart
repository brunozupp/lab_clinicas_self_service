import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/patient_model.dart';
import 'package:lab_clinicas_self_service/src/repositories/patients/i_patients_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PatientController with MessageStateMixin {

  final IPatientsRepository _repository;

  PatientController({
    required IPatientsRepository repository,
  }) : _repository = repository;

  PatientModel? patient;

  final _nextStep = signal<bool>(false);
  bool get nextStep => _nextStep();


  void goNextStep() {
    _nextStep.value = true;
  }
  
  Future<void> updateAndNext(PatientModel model) async {

    final updateResult = await _repository.update(model);

    switch(updateResult) {
      case Right():
        showInfo("Paciente atualizado com sucesso");
        patient = model;
        goNextStep();
      case Left():
        showError("Erro ao atualizar dados do paciente, chame o atendente");
    }
  }

  Future<void> saveAndNext(RegisterPatientModel registerPatientModel) async {

    final registerResult = await _repository.register(registerPatientModel);

    switch(registerResult) {
      case Right(value: final model):
        showInfo("Paciente cadastrado com sucesso");
        patient = model;
        goNextStep();
      case Left():
        showError("Erro ao cadastrar dados do paciente, chame o atendente");
    }
  }
}