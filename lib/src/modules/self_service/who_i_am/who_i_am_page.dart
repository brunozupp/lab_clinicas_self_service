import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validatorless/validatorless.dart';
    
class WhoIAmPage extends StatefulWidget {

  const WhoIAmPage({ Key? key }) : super(key: key);

  @override
  State<WhoIAmPage> createState() => _WhoIAmPageState();
}

class _WhoIAmPageState extends State<WhoIAmPage> {

  final _selfServiceController = Injector.get<SelfServiceController>();

  final _formKey = GlobalKey<FormState>();
  final _firstNameEC = TextEditingController();
  final _lastNameEC = TextEditingController();

  @override
  void dispose() {
    _firstNameEC.dispose();
    _lastNameEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final sizeOf = MediaQuery.sizeOf(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        _firstNameEC.text = "";
        _lastNameEC.text = "";
        _selfServiceController.clearForm();
      },
      child: Scaffold(
        appBar: LabClinicasAppBar(
          actions: [
            PopupMenuButton(
              child: const IconPopupMenuWidget(),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Finalizar Terminal"),
                  ),
                ];
              },
              onSelected: (value) async {
                if(value == 1) {

                  final nav = Navigator.of(context);

                  await SharedPreferences.getInstance().then((sp) => sp.clear());

                  nav.pushNamedAndRemoveUntil("/", (route) => false);
                }
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context,constraints) {
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background_login.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    width: sizeOf.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Image.asset("assets/images/logo_vertical.png"),
                          const SizedBox(
                            height: 48,
                          ),
                          const Text(
                            "Bem-vindo",
                            style: LabClinicasTheme.titleStyle,
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          TextFormField(
                            controller: _firstNameEC,
                            validator: Validatorless.required("Nome obrigatório"),
                            decoration: const InputDecoration(
                              label: Text("Digite seu nome"),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: _lastNameEC,
                            validator: Validatorless.required("Sobrenome obrigatório"),
                            decoration: const InputDecoration(
                              label: Text("Digite seu sobrenome"),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                            width: sizeOf.width * 0.8,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                
                                final valid = _formKey.currentState?.validate() ?? false;
      
                                if(valid) {
                                  _selfServiceController.setWhoIAmDataStepAndNext(
                                    _firstNameEC.text,
                                    _lastNameEC.text,
                                  );
                                }
                              },
                              child: const Text("CONTINUAR"),
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
        ),
      ),
    );
  }
}