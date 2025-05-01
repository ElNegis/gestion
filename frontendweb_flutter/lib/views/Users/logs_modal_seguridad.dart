import 'package:flutter/material.dart';
import '../../controllers/UserController.dart';
import '../../widgets/logs_list.dart';
import '../../widgets/logs_filters.dart';

class LogsModalSecurity extends StatefulWidget {
  final UserController userController;

  const LogsModalSecurity({Key? key, required this.userController}) : super(key: key);

  @override
  _LogsModalState createState() => _LogsModalState();
}

class _LogsModalState extends State<LogsModalSecurity> {
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
    final success = await widget.userController.fetchLogsSecurity(context);
    if (success) {
      fetchAndFilterLogs();
    }
  }

  void fetchAndFilterLogs() {
    setState(() {
      filteredLogs = widget.userController.logs
          .take(100)
          .where((log) {
        final matchesSearch = log['log']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final logDateString = log['fecha_hora'].split('T').first;
        final logDate = DateTime.parse(logDateString);
        final matchesDate =
            (startDate == null || logDate.isAtSameMomentAs(startDate!) || logDate.isAfter(startDate!)) &&
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LogsFilters(
            startDate: startDate,
            endDate: endDate,
            onSearchChanged: onSearchChanged,
            onDateFilterChanged: onDateFilterChanged,
          ),
          Expanded(
            child: LogsList(logs: filteredLogs),
          ),
        ],
      ),
    );
  }
}
