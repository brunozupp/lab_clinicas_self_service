import 'package:asyncstate/asyncstate.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:lab_clinicas_self_service/src/models/patient_model.dart';
import 'package:lab_clinicas_self_service/src/models/self_service_model.dart';
import 'package:lab_clinicas_self_service/src/repositories/information_form/i_information_form_repository.dart';

enum FormSteps {
  none,
  whoIAm,
  findPatient,
  patient,
  documents,
  done,
  restart,
}

class SelfServiceController with MessageStateMixin {

  final IInformationFormRepository _informationFormRepository;

  SelfServiceController({
    required IInformationFormRepository informationFormRepository,
  }) : _informationFormRepository = informationFormRepository;

  final _step = ValueSignal(FormSteps.none);
  FormSteps get step => _step();

  var _model = const SelfServiceModel();
  SelfServiceModel get model => _model;

  var password = "";

  void startProcess() {
    _step.forceUpdate(FormSteps.whoIAm);
  }

  void setWhoIAmDataStepAndNext(String name, String lastName) {
    _model = _model.copyWith(
      name: () => name,
      lastName: () => lastName,
    );

    _step.forceUpdate(FormSteps.findPatient);
  }

  void clearForm() {
    _model = _model.clear();
  }

  void goToFormPatient(PatientModel? patient) {
    _model = _model.copyWith(
      patient: () => patient,
    );

    _step.forceUpdate(FormSteps.patient);
  }

  void restartProcess() {
    _step.forceUpdate(FormSteps.restart);
    clearForm();
  }

  void updatePatientAndGoDocument(PatientModel? patient) {
    _model = _model.copyWith(
      patient: () => patient,
    );

    _step.forceUpdate(FormSteps.documents);
  }

  void registerDocument(DocumentType type, String filePath) {

    final documents = _model.documents ?? {};

    // Limpando porque só posso ter um na lista desse tipo
    if(type == DocumentType.healthInsuranceCard) {
      documents[type]?.clear();
    }

    final values = documents[type] ?? [];

    values.add(filePath);

    documents[type] = values;

    _model = _model.copyWith(documents: () => documents);
  }

  void clearDocuments() {
    _model = _model.copyWith(
      documents: () => {},
    );
  }

  Future<void> finalize() async {

    final result = await _informationFormRepository.register(model).asyncLoader();

    switch(result) {
      case Left():
        showError("Erro ao registrar atendimento");
      case Right():
        password = "${_model.name} ${_model.lastName}";
        _step.forceUpdate(FormSteps.done);
    }
  }
}
