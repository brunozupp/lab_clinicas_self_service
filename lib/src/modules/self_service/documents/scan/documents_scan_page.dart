import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
    
class DocumentsScanPage extends StatefulWidget {

  const DocumentsScanPage({ Key? key }) : super(key: key);

  @override
  State<DocumentsScanPage> createState() => _DocumentsScanPageState();
}

class _DocumentsScanPageState extends State<DocumentsScanPage> {

  late CameraController cameraController;

  @override
  void initState() {
    cameraController = CameraController(
      Injector.get<List<CameraDescription>>().first, 
      ResolutionPreset.ultraHigh,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final sizeOf = MediaQuery.sizeOf(context);

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
                Image.asset("assets/images/cam_icon.png"),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  "TIRAR A FOTO AGORA",
                  style: LabClinicasTheme.titleSmallStyle,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  "Posicione o documento dentro do quadrado abaixo e aperte o botão para tirar a foto",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: LabClinicasTheme.blueColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                FutureBuilder(
                  future: cameraController.initialize(),
                  builder: (context, snapshot) {
                    switch(snapshot) {
                      case AsyncSnapshot(
                        connectionState: ConnectionState.waiting || ConnectionState.active
                      ):
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case AsyncSnapshot(
                        connectionState: ConnectionState.done,
                      ):
                        if(cameraController.value.isInitialized) {
                          return CameraPreview(cameraController);
                        }
                    }

                    return const Center(
                      child: Text("Erro ao carregar câmera"),
                    );
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LabClinicasTheme.orangeColor,
                    fixedSize: const Size.fromHeight(48),
                  ),
                  child: const Text("FINALIZAR"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}