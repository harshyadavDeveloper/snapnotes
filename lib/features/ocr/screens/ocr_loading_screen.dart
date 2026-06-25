import 'package:flutter/material.dart';

class OcrLoadingScreen extends StatelessWidget {
  const OcrLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),

            SizedBox(height: 24),

            Text(
              'Extracting text...',
            ),
          ],
        ),
      ),
    );
  }
}