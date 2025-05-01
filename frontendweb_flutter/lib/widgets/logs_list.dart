import 'package:flutter/material.dart';

class LogsList extends StatelessWidget {
  final List<Map<String, dynamic>> logs;

  const LogsList({Key? key, required this.logs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(child: Text('No se encontraron logs.'));
    }
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Text(log['id'].toString()),
          ),
          title: Text(log['log']),
          subtitle: Text(log['fecha_hora']),
        );
      },
    );
  }
}
