import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/core/constants/images_constants.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/scan_confirm/documents_scan_confirm_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';
    
class DocumentsScanConfirmPage extends StatefulWidget {

  const DocumentsScanConfirmPage({ Key? key }) : super(key: key);

  @override
  State<DocumentsScanConfirmPage> createState() => _DocumentsScanConfirmPageState();
}

class _DocumentsScanConfirmPageState extends State<DocumentsScanConfirmPage> with MessageViewMixin {

  final controller = Injector.get<DocumentsScanConfirmController>();

  @override
  void initState() {
    messageListener(controller);

    controller.pathRemoteStorage.listen(context, () { 
      if(controller.pathRemoteStorage.value != null && controller.pathRemoteStorage.value != "") {
        
        /**
         * Não posso usar o popUntil com valor de retorno, por isso preciso utilizar dois pop para
         * retornar para a tela que desejo.
         */
        Navigator.of(context).pop();
        Navigator.of(context).pop(controller.pathRemoteStorage.value);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.pathRemoteStorage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);

    final photo = ModalRoute.of(context)!.settings.arguments as XFile;

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
                Image.asset(ImagesConstants.fotoConfirmIcon),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "CONFIRA SUA FOTO",
                  style: LabClinicasTheme.titleSmallStyle,
                ),
                const SizedBox(
                  height: 32,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: sizeOf.width * 0.5,
                    child: DottedBorder(
                      dashPattern: const [1,10,1,3],
                      borderType: BorderType.RRect,
                      strokeWidth: 4,
                      strokeCap: StrokeCap.square,
                      color: LabClinicasTheme.orangeColor,
                      radius: const Radius.circular(16),
                      child: Image.file(
                        File(photo.path),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("TIRAR OUTRA"),
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
                          onPressed: () async {
                            final imageBytes = await photo.readAsBytes();
                            final fileName = photo.name;

                            await controller.uploadImage(imageBytes, fileName);
                          },
                          child: const Text("SALVAR"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}