import 'package:flutter/material.dart';

import 'camera_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Stack(children: [CameraScreen()]));
  }
}
