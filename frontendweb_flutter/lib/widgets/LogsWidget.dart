import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../controllers/UserController.dart';
import 'botones/CustomButton.dart';

class LogsWidget extends StatefulWidget {
  final UserController userController;

  const LogsWidget({Key? key, required this.userController}) : super(key: key);

  @override
  _LogsWidgetState createState() => _LogsWidgetState();
}

class _LogsWidgetState extends State<LogsWidget> {
  List<Map<String, dynamic>> filteredLogs = [];
  String searchQuery = '';
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<void> loadLogs() async {
    final success = await widget.userController.fetchLogs(context);
    if (success) {
      fetchAndFilterLogs();
    }
  }

  void fetchAndFilterLogs() {
    setState(() {
      filteredLogs = widget.userController.logs
          .take(100) // Mostrar últimos 100 logs
          .where((log) {
        // Filtro por búsqueda
        final matchesSearch = log['log']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());

        // Filtro por fecha (procesando formato ISO8601)
        final logDateString = log['fecha_hora'].split('T').first; // Extraer la fecha
        final logDate = DateTime.parse(logDateString);

        // Incluir la fecha inicial y final en las comparaciones
        final matchesDate = (startDate == null || logDate.isAtSameMomentAs(startDate!) || logDate.isAfter(startDate!)) &&
            (endDate == null || logDate.isAtSameMomentAs(endDate!) || logDate.isBefore(endDate!));
        return matchesSearch && matchesDate;
      })
          .toList();
    });
  }



  void onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    fetchAndFilterLogs();
  }

  void onDateFilterChanged(DateTime? start, DateTime? end) {
    setState(() {
      startDate = start;
      endDate = end;
    });
    fetchAndFilterLogs();
  }

  Future<void> generatePdfAndDownload() async {
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
              itemCount: filteredLogs.length,
              itemBuilder: (context, index) {
                final log = filteredLogs[index];
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "ID: ${log['id']}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
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

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'filtered_logs.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Buscar logs...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Filtro por fecha
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        onDateFilterChanged(selectedDate, endDate);
                      }
                    },
                    child: Text(
                      startDate == null
                          ? 'Seleccionar Fecha Inicial'
                          : DateFormat('yyyy-MM-dd').format(startDate!), // Corrección aquí
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        onDateFilterChanged(startDate, selectedDate);
                      }
                    },
                    child: Text(
                      endDate == null
                          ? 'Seleccionar Fecha Final'
                          : DateFormat('yyyy-MM-dd').format(endDate!), // Corrección aquí
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de logs
          Expanded(
            child: filteredLogs.isEmpty
                ? const Center(child: Text('No se encontraron logs.'))
                : ListView.builder(
              itemCount: filteredLogs.length,
              itemBuilder: (context, index) {
                final log = filteredLogs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(log['id'].toString()),
                  ),
                  title: Text(log['log']),
                  subtitle: Text(log['fecha_hora']),
                );
              },
            ),
          ),
          // Botón para generar PDF
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              buttonText: "Generar PDF",
              onPressed: generatePdfAndDownload,
            ),
          ),
        ],
      ),
    );
  }
}
