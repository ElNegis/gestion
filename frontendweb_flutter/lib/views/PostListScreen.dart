import 'package:flutter/material.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final List<Map<String, dynamic>> posts = [
    {"espesor": 0.5, "largo": 100, "precio": 50},
    {"espesor": 1.0, "largo": 200, "precio": 100},
    {"espesor": 1.5, "largo": 300, "precio": 150},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Posts'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Espesor: ${post['espesor']}'),
                      subtitle: Text('Largo: ${post['largo']} - Precio: \$${post['precio']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editPost(context, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _addNewPost(context),
              child: const Text('Agregar Nuevo Post'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewPost(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController espesorController = TextEditingController();
        final TextEditingController largoController = TextEditingController();
        final TextEditingController precioController = TextEditingController();

        return AlertDialog(
          title: const Text('Agregar Nuevo Post'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: espesorController,
                  decoration: const InputDecoration(labelText: 'Espesor'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: largoController,
                  decoration: const InputDecoration(labelText: 'Largo'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  posts.add({
                    'espesor': double.tryParse(espesorController.text) ?? 0,
                    'largo': int.tryParse(largoController.text) ?? 0,
                    'precio': double.tryParse(precioController.text) ?? 0,
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _editPost(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController espesorController =
            TextEditingController(text: posts[index]['espesor'].toString());
        final TextEditingController largoController =
            TextEditingController(text: posts[index]['largo'].toString());
        final TextEditingController precioController =
            TextEditingController(text: posts[index]['precio'].toString());

        return AlertDialog(
          title: const Text('Editar Post'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: espesorController,
                  decoration: const InputDecoration(labelText: 'Espesor'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: largoController,
                  decoration: const InputDecoration(labelText: 'Largo'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  posts[index] = {
                    'espesor': double.tryParse(espesorController.text) ?? 0,
                    'largo': int.tryParse(largoController.text) ?? 0,
                    'precio': double.tryParse(precioController.text) ?? 0,
                  };
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
