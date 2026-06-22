import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  Future<File> generateNotePdf({
    required String title,
    required String content,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Text(content),
            ],
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$title.pdf');

    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
