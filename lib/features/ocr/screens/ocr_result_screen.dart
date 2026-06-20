import 'package:flutter/material.dart';

class OcrResultScreen extends StatefulWidget {
  final String extractedText;

  const OcrResultScreen({super.key, required this.extractedText});

  @override
  State<OcrResultScreen> createState() => _OcrResultScreenState();
}

class _OcrResultScreenState extends State<OcrResultScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.extractedText);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          expands: true,
          maxLines: null,
          minLines: null,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ),
    );
  }
}
