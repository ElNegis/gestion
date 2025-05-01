import 'package:flutter/material.dart';
import '../../service/TableUsersService.dart';

class TableUsersScreen extends StatefulWidget {
  final String accessToken;

  const TableUsersScreen({Key? key, required this.accessToken}) : super(key: key);

  @override
  _TableUsersScreenState createState() => _TableUsersScreenState();
}

class _TableUsersScreenState extends State<TableUsersScreen> {
  final TableUsersService _tableUsersService = TableUsersService();
  late Future<List<Map<String, dynamic>>?> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _tableUsersService.fetchAllUsers(widget.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No se encontraron usuarios'),
            );
          } else {
            final users = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16.0,
                columns: const [
                  DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Correo', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: users.map((user) {
                  return DataRow(cells: [
                    DataCell(Text(user['id'].toString())),
                    DataCell(Text(user['username'] ?? 'N/A')),
                    DataCell(Text(user['email'] ?? 'N/A')),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

