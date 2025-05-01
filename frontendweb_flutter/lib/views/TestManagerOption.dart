import 'package:flutter/material.dart';
import 'DummyView.dart';
import '../widgets/ManagerOption.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ManagerOption(
      menuItems: [
        "View 1 hola pruebaaa",
        "View assssssssss2",
        "View assssssssss3",
        "View 4aaaaa",
      ],
      views: [
        DummyView(title: "Dummy View 1"),
        DummyView(title: "Dummy View 2"),
        DummyView(title: "Dummy View 3"),
        DummyView(title: "Dummy View 4"),
      ],
      menuWidth: 900,
      menuHeight: 70, // Ajusta la altura del menú si lo deseas
    );
  }
}
