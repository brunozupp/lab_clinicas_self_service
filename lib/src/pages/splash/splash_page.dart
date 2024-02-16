import 'package:flutter/material.dart';

import '../../core/constants/images_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      Navigator.of(context).pushReplacementNamed("/auth/login");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImagesConstants.logoVertical),
      ),
    );
  }
}