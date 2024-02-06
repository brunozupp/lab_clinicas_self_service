import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/self_service_model.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/widgets/document_box_widget.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
    
class DocumentsPage extends StatefulWidget {

  const DocumentsPage({ Key? key }) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> with MessageViewMixin {

  final _selfServiceController = Injector.get<SelfServiceController>();

  @override
  void initState() {
    messageListener(_selfServiceController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final sizeOf = MediaQuery.sizeOf(context);

    final documents = _selfServiceController.model.documents;
    final totalHealthInsuranceCard = documents?[DocumentType.healthInsuranceCard]?.length ?? 0;
    final totalMedicalOrder = documents?[DocumentType.medicalOrder]?.length ?? 0;

    return Scaffold(
      appBar: LabClinicasAppBar(),
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
            child: Column(
              children: [
                Image.asset("assets/images/folder.png"),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  "ADICIONAR DOCUMENTOS",
                  style: LabClinicasTheme.titleSmallStyle,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  "ADICIONAR DOCUMENTOS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: LabClinicasTheme.blueColor,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: sizeOf.width * 0.8,
                  height: 300,
                  child: Row(
                    children: [
                      DocumentBoxWidget(
                        uploaded: totalHealthInsuranceCard > 0,
                        icon: Image.asset("assets/images/id_card.png"),
                        label: "CARTEIRINHA",
                        totalFiles: totalHealthInsuranceCard,
                        onTap: () async {
                          final filePath = await Navigator.of(context).pushNamed<String?>("/self-service/documents/scan");

                          if(filePath != null && filePath != "") {
                            _selfServiceController.registerDocument(DocumentType.healthInsuranceCard, filePath);

                            setState(() { });
                          }
                        },
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      DocumentBoxWidget(
                        uploaded: totalMedicalOrder > 0,
                        icon: Image.asset("assets/images/document.png"),
                        label: "PEDIDO MÉDICO",
                        totalFiles: totalMedicalOrder,
                        onTap: () async {
                          final filePath = await Navigator.of(context).pushNamed<String?>("/self-service/documents/scan");

                          if(filePath != null && filePath != "") {
                            _selfServiceController.registerDocument(DocumentType.medicalOrder, filePath);

                            setState(() { });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Visibility(
                  visible: totalMedicalOrder > 0 && totalHealthInsuranceCard > 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _selfServiceController.clearDocuments();
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            side: const BorderSide(
                              color: Colors.red,
                            ),
                            fixedSize: const Size.fromHeight(48),
                          ),
                          child: const Text("REMOVER TODAS"),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LabClinicasTheme.orangeColor,
                            fixedSize: const Size.fromHeight(48),
                          ),
                          child: const Text("FINALIZAR"),
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
    );
  }
}