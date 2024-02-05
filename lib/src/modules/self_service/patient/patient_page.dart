import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/self_service_model.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/patient/patient_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/patient/patient_form_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

import '../widgets/lab_clinicas_self_service_app_bar.dart';
    
class PatientPage extends StatefulWidget {

  const PatientPage({ Key? key }) : super(key: key);

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> with PatientFormController, MessageViewMixin {

  final _selfServiceController = Injector.get<SelfServiceController>();

  final controller = Injector.get<PatientController>();

  late bool patientFound;
  late bool enableForm;

  @override
  void initState() {

    messageListener(controller);

    effect(() {

      if(controller.nextStep) {
        _selfServiceController.updatePatientAndGoDocument(controller.patient);
      }
    });

    final SelfServiceModel(:patient) = _selfServiceController.model;

    patientFound = patient != null;
    enableForm = !patientFound; // Se o paciente foi encontrado, NÃO pode ser editado

    initializeForm(patient);

    super.initState();
  }

  @override
  void dispose() {
    disposeForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final sizeOf = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: LabClinicasSelfServiceAppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: sizeOf.width * 0.85,
            margin: const EdgeInsets.only(
              top: 18,
            ),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: LabClinicasTheme.orangeColor,
              )
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Visibility(
                    visible: patientFound,
                    replacement: Image.asset("assets/images/lupa_icon.png"),
                    child: Image.asset("assets/images/check_icon.png"),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Visibility(
                    visible: patientFound,
                    replacement: const Text(
                      "Cadastro não encontrado",
                      style: LabClinicasTheme.titleSmallStyle,
                    ),
                    child: const Text(
                      "Cadastro encontrado",
                      style: LabClinicasTheme.titleSmallStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Visibility(
                    visible: patientFound,
                    replacement: const Text(
                    "Preencha o formulário abaixo para fazer o seu cadastro",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: LabClinicasTheme.blueColor,
                    ),
                  ),
                    child: const Text(
                    "Confirme os dados do seu cadastro",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: LabClinicasTheme.blueColor,
                    ),
                  ),
                  ),
                  
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: nameEC,
                    validator: Validatorless.required("Nome obrigatório"),
                    decoration: const InputDecoration(
                      label: Text("Nome paciente *")
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: emailEC,
                    validator: Validatorless.multiple([
                      Validatorless.required("Email obrigatório"),
                      Validatorless.email("Email inválido")
                    ]),
                    decoration: const InputDecoration(
                      label: Text("Email *")
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: phoneEC,
                    validator: Validatorless.required("Telefone obrigatório"),
                    decoration: const InputDecoration(
                      label: Text("Telefone de contato *")
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: documentEC,
                    validator: Validatorless.required("CPF obrigatório"),
                    decoration: const InputDecoration(
                      label: Text("Digite seu CPF *")
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: cepEC,
                    validator: Validatorless.required("CEP obrigatório"),
                    decoration: const InputDecoration(
                      label: Text("CEP *")
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CepInputFormatter(),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: streetEC,
                          validator: Validatorless.required("Endereço obrigatório"),
                          decoration: const InputDecoration(
                            label: Text("Endereço *")
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: numberEC,
                          validator: Validatorless.required("Número obrigatório"),
                          decoration: const InputDecoration(
                            label: Text("Número *")
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: complementEC,
                          decoration: const InputDecoration(
                            label: Text("Complemento")
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: stateEC,
                          validator: Validatorless.required("Estado obrigatório"),
                          decoration: const InputDecoration(
                            label: Text("Estado *")
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: cityEC,
                          validator: Validatorless.required("Cidade obrigatória"),
                          decoration: const InputDecoration(
                            label: Text("Cidade *")
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: districtEC,
                          validator: Validatorless.required("Bairro obrigatório"),
                          decoration: const InputDecoration(
                            label: Text("Bairro *")
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: guardianEC,
                    decoration: const InputDecoration(
                      label: Text("Responsável")
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: guardianIdentificationNumberEC,
                    decoration: const InputDecoration(
                      label: Text("Identificação responsável")
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Visibility(
                    visible: !enableForm,
                    replacement: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          
                          final valid = formKey.currentState?.validate() ?? false;

                          if(valid) {

                            final updatedPatient = updatePatient(_selfServiceController.model.patient!);

                            controller.updateAndNext(updatedPatient);
                          }
                        },
                        child: Visibility(
                          visible: !patientFound,
                          replacement: const Text("SALVAR E CONTINUAR"),
                          child: const Text("CADASTRAR"),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  enableForm = true;
                                });
                              },
                              child: const Text("EDITAR"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.patient = _selfServiceController.model.patient;
                                controller.goNextStep();
                              },
                              child: const Text("CONTINUAR"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}