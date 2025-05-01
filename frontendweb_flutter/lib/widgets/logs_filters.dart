import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogsFilters extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<String> onSearchChanged;
  final Function(DateTime?, DateTime?) onDateFilterChanged;

  const LogsFilters({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onSearchChanged,
    required this.onDateFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Buscador
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Buscar logs...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // Filtros por fecha
        Row(
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
                child: Text(startDate == null
                    ? 'Fecha Inicial'
                    : DateFormat('yyyy-MM-dd').format(startDate!)),
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
                child: Text(endDate == null
                    ? 'Fecha Final'
                    : DateFormat('yyyy-MM-dd').format(endDate!)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
