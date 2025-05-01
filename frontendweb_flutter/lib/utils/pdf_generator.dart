import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePdfAndDownload(List<Map<String, dynamic>> logs) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "Logs Generados",
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("ID: ${log['id']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Log: ${log['log']}"),
                  pw.Text("Fecha y Hora: ${log['fecha_hora']}"),
                  pw.Divider(),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
  await Printing.sharePdf(bytes: await pdf.save(), filename: 'filtered_logs.pdf');
}
